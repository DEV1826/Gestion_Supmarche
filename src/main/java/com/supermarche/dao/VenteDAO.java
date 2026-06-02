package com.supermarche.dao;

import com.supermarche.entity.LigneVente;
import com.supermarche.entity.Produit;
import com.supermarche.entity.Vente;
import com.supermarche.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class VenteDAO {

    private final ProduitDAO produitDAO = new ProduitDAO();

    public Long save(Vente vente) throws SQLException {
        String sqlVente = "INSERT INTO vente(caissier_id, date_heure, total_ttc, mode_paiement, numero_ticket) VALUES (?, ?, ?, ?, ?)";
        String sqlLigne = "INSERT INTO ligne_vente(vente_id, produit_id, quantite, prix_unitaire, sous_total) VALUES (?, ?, ?, ?, ?)";

        try (Connection connection = DBUtil.getConnection()) {
            connection.setAutoCommit(false);
            try {
                try (PreparedStatement venteStatement = connection.prepareStatement(sqlVente, Statement.RETURN_GENERATED_KEYS)) {
                    venteStatement.setLong(1, vente.getCaissierId());
                    venteStatement.setTimestamp(2, Timestamp.valueOf(vente.getDateHeure()));
                    venteStatement.setBigDecimal(3, vente.getTotalTtc());
                    venteStatement.setString(4, vente.getModePaiement().name());
                    venteStatement.setString(5, vente.getNumeroTicket());
                    venteStatement.executeUpdate();

                    try (ResultSet keys = venteStatement.getGeneratedKeys()) {
                        if (keys.next()) {
                            vente.setId(keys.getLong(1));
                        }
                    }
                }

                try (PreparedStatement ligneStatement = connection.prepareStatement(sqlLigne)) {
                    for (LigneVente ligne : vente.getLignes()) {
                        ligneStatement.setLong(1, vente.getId());
                        ligneStatement.setLong(2, ligne.getProduitId());
                        ligneStatement.setInt(3, ligne.getQuantite());
                        ligneStatement.setBigDecimal(4, ligne.getPrixUnitaire());
                        ligneStatement.setBigDecimal(5, ligne.getSousTotal());
                        ligneStatement.addBatch();
                    }
                    ligneStatement.executeBatch();
                }

                try (PreparedStatement stockStatement = connection.prepareStatement(
                    "UPDATE produit SET stock_actuel = stock_actuel - ? WHERE id = ?")) {
                    for (LigneVente ligne : vente.getLignes()) {
                        stockStatement.setInt(1, ligne.getQuantite());
                        stockStatement.setLong(2, ligne.getProduitId());
                        stockStatement.addBatch();
                    }
                    stockStatement.executeBatch();
                }

                connection.commit();
                return vente.getId();
            } catch (SQLException e) {
                connection.rollback();
                throw e;
            }
        }
    }

    public Vente findById(Long id) throws SQLException {
        String sqlVente = "SELECT * FROM vente WHERE id = ?";
        String sqlLignes = "SELECT lv.*, p.designation FROM ligne_vente lv JOIN produit p ON p.id = lv.produit_id WHERE vente_id = ?";

        Vente vente = null;
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement venteStatement = connection.prepareStatement(sqlVente)) {
            venteStatement.setLong(1, id);
            try (ResultSet rs = venteStatement.executeQuery()) {
                if (rs.next()) {
                    vente = new Vente();
                    vente.setId(rs.getLong("id"));
                    vente.setCaissierId(rs.getLong("caissier_id"));
                    vente.setDateHeure(rs.getTimestamp("date_heure").toLocalDateTime());
                    vente.setTotalTtc(rs.getBigDecimal("total_ttc"));
                    vente.setModePaiement(Vente.ModePaiement.valueOf(rs.getString("mode_paiement")));
                    vente.setNumeroTicket(rs.getString("numero_ticket"));
                }
            }

            if (vente != null) {
                List<LigneVente> lignes = new ArrayList<>();
                try (PreparedStatement ligneStatement = connection.prepareStatement(sqlLignes)) {
                    ligneStatement.setLong(1, id);
                    try (ResultSet rsLignes = ligneStatement.executeQuery()) {
                        while (rsLignes.next()) {
                            LigneVente ligne = new LigneVente();
                            ligne.setId(rsLignes.getLong("id"));
                            ligne.setVenteId(rsLignes.getLong("vente_id"));
                            ligne.setProduitId(rsLignes.getLong("produit_id"));
                            ligne.setQuantite(rsLignes.getInt("quantite"));
                            ligne.setPrixUnitaire(rsLignes.getBigDecimal("prix_unitaire"));
                            ligne.setSousTotal(rsLignes.getBigDecimal("sous_total"));
                            Produit produit = new Produit();
                            produit.setId(rsLignes.getLong("produit_id"));
                            produit.setDesignation(rsLignes.getString("designation"));
                            ligne.setProduit(produit);
                            lignes.add(ligne);
                        }
                    }
                }
                vente.setLignes(lignes);
            }
        }
        return vente;
    }

    public List<Map<String, Object>> topProduits() throws SQLException {
        String sql = "SELECT p.designation, p.categorie, SUM(lv.quantite) AS quantite_vendue, SUM(lv.sous_total) AS chiffre_affaires "
            + "FROM ligne_vente lv JOIN produit p ON p.id = lv.produit_id "
            + "GROUP BY p.designation, p.categorie ORDER BY quantite_vendue DESC LIMIT 10";
        return readStats(sql);
    }

    public List<Map<String, Object>> caParCategorie() throws SQLException {
        String sql = "SELECT p.categorie, SUM(lv.sous_total) AS ca_total, COUNT(DISTINCT lv.vente_id) AS nb_ventes "
            + "FROM ligne_vente lv JOIN produit p ON p.id = lv.produit_id "
            + "GROUP BY p.categorie ORDER BY ca_total DESC";
        return readStats(sql);
    }

    public List<Map<String, Object>> ventesHebdo() throws SQLException {
        String sql = "SELECT YEAR(date_heure) AS annee, WEEK(date_heure, 1) AS semaine, COUNT(*) AS nb_tickets, SUM(total_ttc) AS ca_semaine "
            + "FROM vente GROUP BY YEAR(date_heure), WEEK(date_heure, 1) ORDER BY annee DESC, semaine DESC";
        return readStats(sql);
    }

    public Map<String, Object> kpis() throws SQLException {
        String sql = "SELECT COUNT(*) AS nb_ventes, COALESCE(SUM(total_ttc), 0) AS ca_total, COALESCE(AVG(total_ttc), 0) AS panier_moyen FROM vente";
        List<Map<String, Object>> rows = readStats(sql);
        return rows.isEmpty() ? new LinkedHashMap<>() : rows.get(0);
    }

    private List<Map<String, Object>> readStats(String sql) throws SQLException {
        List<Map<String, Object>> rows = new ArrayList<>();
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet rs = statement.executeQuery()) {
            int columns = rs.getMetaData().getColumnCount();
            while (rs.next()) {
                Map<String, Object> row = new LinkedHashMap<>();
                for (int i = 1; i <= columns; i++) {
                    row.put(rs.getMetaData().getColumnLabel(i), rs.getObject(i));
                }
                rows.add(row);
            }
        }
        return rows;
    }
}
