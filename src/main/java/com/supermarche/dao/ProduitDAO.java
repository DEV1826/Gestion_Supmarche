package com.supermarche.dao;

import com.supermarche.entity.Produit;
import com.supermarche.util.DBUtil;
import com.supermarche.util.FormUtil;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class ProduitDAO {

    private static final String SELECT_WITH_FOURNISSEUR = "SELECT p.*, f.id AS f_id, f.raison_sociale, f.telephone, f.email, "
        + "f.delai_livraison_jours, f.conditions_paiement FROM produit p "
        + "LEFT JOIN fournisseur f ON f.id = p.fournisseur_id";

    public List<Produit> findAll() throws SQLException {
        String sql = SELECT_WITH_FOURNISSEUR + " ORDER BY p.designation";
        List<Produit> produits = new ArrayList<>();
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet rs = statement.executeQuery()) {
            while (rs.next()) {
                produits.add(map(rs));
            }
        }
        return produits;
    }

    public Produit findById(Long id) throws SQLException {
        String sql = SELECT_WITH_FOURNISSEUR + " WHERE p.id = ?";
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, id);
            try (ResultSet rs = statement.executeQuery()) {
                if (rs.next()) {
                    return map(rs);
                }
            }
        }
        return null;
    }

    public List<Produit> findAlertesStock() throws SQLException {
        String sql = SELECT_WITH_FOURNISSEUR + " WHERE p.stock_actuel <= p.stock_minimum ORDER BY p.stock_actuel ASC";
        List<Produit> produits = new ArrayList<>();
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet rs = statement.executeQuery()) {
            while (rs.next()) {
                produits.add(map(rs));
            }
        }
        return produits;
    }

    public List<Produit> findFiltered(String search, String categorie, String stockStatus) throws SQLException {
        return findFiltered(search, categorie, stockStatus, "designation_asc", 1, Integer.MAX_VALUE);
    }

    public List<Produit> findAdvancedFiltered(String search, String categorie, String stockStatus,
                                              String minPrix, String maxPrix, String minStock, String maxStock,
                                              String datePeremptionMin, String datePeremptionMax,
                                              String sort, int page, int pageSize) throws SQLException {
        StringBuilder sql = new StringBuilder(SELECT_WITH_FOURNISSEUR + " WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (search != null && !search.isBlank()) {
            sql.append(" AND (LOWER(p.designation) LIKE ? OR LOWER(p.code_barre) LIKE ?)");
            String like = "%" + search.trim().toLowerCase() + "%";
            params.add(like);
            params.add(like);
        }
        if (categorie != null && !categorie.isBlank()) {
            sql.append(" AND p.categorie = ?");
            params.add(categorie);
        }
        if ("alert".equalsIgnoreCase(stockStatus)) {
            sql.append(" AND p.stock_actuel <= p.stock_minimum");
        } else if ("ok".equalsIgnoreCase(stockStatus)) {
            sql.append(" AND p.stock_actuel > p.stock_minimum");
        }
        addAdvancedFilters(sql, params, minPrix, maxPrix, minStock, maxStock, datePeremptionMin, datePeremptionMax);
        sql.append(" ORDER BY ").append(resolveSort(sort)).append(" LIMIT ? OFFSET ?");
        params.add(pageSize);
        params.add(Math.max(0, (page - 1) * pageSize));

        List<Produit> produits = new ArrayList<>();
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql.toString())) {
            bind(statement, params);
            try (ResultSet rs = statement.executeQuery()) {
                while (rs.next()) {
                    produits.add(map(rs));
                }
            }
        }
        return produits;
    }

    public List<Produit> findFiltered(String search, String categorie, String stockStatus, String sort, int page, int pageSize) throws SQLException {
        StringBuilder sql = new StringBuilder(SELECT_WITH_FOURNISSEUR + " WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (search != null && !search.isBlank()) {
            sql.append(" AND (LOWER(p.designation) LIKE ? OR LOWER(p.code_barre) LIKE ?)");
            String like = "%" + search.trim().toLowerCase() + "%";
            params.add(like);
            params.add(like);
        }
        if (categorie != null && !categorie.isBlank()) {
            sql.append(" AND p.categorie = ?");
            params.add(categorie);
        }
        if ("alert".equalsIgnoreCase(stockStatus)) {
            sql.append(" AND p.stock_actuel <= p.stock_minimum");
        } else if ("ok".equalsIgnoreCase(stockStatus)) {
            sql.append(" AND p.stock_actuel > p.stock_minimum");
        }
        sql.append(" ORDER BY ").append(resolveSort(sort)).append(" LIMIT ? OFFSET ?");
        params.add(pageSize);
        params.add(Math.max(0, (page - 1) * pageSize));

        List<Produit> produits = new ArrayList<>();
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql.toString())) {
            bind(statement, params);
            try (ResultSet rs = statement.executeQuery()) {
                while (rs.next()) {
                    produits.add(map(rs));
                }
            }
        }
        return produits;
    }

    public int countFiltered(String search, String categorie, String stockStatus) throws SQLException {
        return countAdvancedFiltered(search, categorie, stockStatus, null, null, null, null, null, null);
    }

    public int countAdvancedFiltered(String search, String categorie, String stockStatus,
                                     String minPrix, String maxPrix, String minStock, String maxStock,
                                     String datePeremptionMin, String datePeremptionMax) throws SQLException {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM produit p WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (search != null && !search.isBlank()) {
            sql.append(" AND (LOWER(p.designation) LIKE ? OR LOWER(p.code_barre) LIKE ?)");
            String like = "%" + search.trim().toLowerCase() + "%";
            params.add(like);
            params.add(like);
        }
        if (categorie != null && !categorie.isBlank()) {
            sql.append(" AND p.categorie = ?");
            params.add(categorie);
        }
        if ("alert".equalsIgnoreCase(stockStatus)) {
            sql.append(" AND p.stock_actuel <= p.stock_minimum");
        } else if ("ok".equalsIgnoreCase(stockStatus)) {
            sql.append(" AND p.stock_actuel > p.stock_minimum");
        }
        addAdvancedFilters(sql, params, minPrix, maxPrix, minStock, maxStock, datePeremptionMin, datePeremptionMax);

        try (Connection connection = DBUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql.toString())) {
            bind(statement, params);
            try (ResultSet rs = statement.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    public List<Produit> findAlertesStockFiltered(String search, Integer stockMax, String categorie, String sort, int page, int pageSize)
        throws SQLException {
        StringBuilder sql = new StringBuilder(SELECT_WITH_FOURNISSEUR + " WHERE p.stock_actuel <= p.stock_minimum");
        List<Object> params = new ArrayList<>();

        if (search != null && !search.isBlank()) {
            sql.append(" AND (LOWER(p.designation) LIKE ? OR LOWER(f.raison_sociale) LIKE ?)");
            String like = "%" + search.trim().toLowerCase() + "%";
            params.add(like);
            params.add(like);
        }
        if (stockMax != null) {
            sql.append(" AND p.stock_actuel <= ?");
            params.add(stockMax);
        }
        if (categorie != null && !categorie.isBlank()) {
            sql.append(" AND p.categorie = ?");
            params.add(categorie);
        }

        sql.append(" ORDER BY ").append(resolveAlertSort(sort)).append(" LIMIT ? OFFSET ?");
        params.add(pageSize);
        params.add(Math.max(0, (page - 1) * pageSize));

        List<Produit> produits = new ArrayList<>();
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql.toString())) {
            bind(statement, params);
            try (ResultSet rs = statement.executeQuery()) {
                while (rs.next()) {
                    produits.add(map(rs));
                }
            }
        }
        return produits;
    }

    public int countAlertesStockFiltered(String search, Integer stockMax, String categorie) throws SQLException {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM produit p LEFT JOIN fournisseur f ON f.id = p.fournisseur_id WHERE p.stock_actuel <= p.stock_minimum");
        List<Object> params = new ArrayList<>();

        if (search != null && !search.isBlank()) {
            sql.append(" AND (LOWER(p.designation) LIKE ? OR LOWER(f.raison_sociale) LIKE ?)");
            String like = "%" + search.trim().toLowerCase() + "%";
            params.add(like);
            params.add(like);
        }
        if (stockMax != null) {
            sql.append(" AND p.stock_actuel <= ?");
            params.add(stockMax);
        }
        if (categorie != null && !categorie.isBlank()) {
            sql.append(" AND p.categorie = ?");
            params.add(categorie);
        }

        try (Connection connection = DBUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql.toString())) {
            bind(statement, params);
            try (ResultSet rs = statement.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    public void save(Produit produit) throws SQLException {
        String sql = "INSERT INTO produit(code_barre, designation, categorie, prix_achat, prix_vente, stock_actuel, stock_minimum, date_peremption, fournisseur_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, produit.getCodeBarre());
            statement.setString(2, produit.getDesignation());
            statement.setString(3, produit.getCategorie());
            statement.setBigDecimal(4, produit.getPrixAchat());
            statement.setBigDecimal(5, produit.getPrixVente());
            statement.setInt(6, produit.getStockActuel());
            statement.setInt(7, produit.getStockMinimum());
            if (produit.getDatePeremption() == null) {
                statement.setDate(8, null);
            } else {
                statement.setDate(8, Date.valueOf(produit.getDatePeremption()));
            }
            if (produit.getFournisseurId() == null) {
                statement.setObject(9, null);
            } else {
                statement.setLong(9, produit.getFournisseurId());
            }
            statement.executeUpdate();
        }
    }

    public void update(Produit produit) throws SQLException {
        String sql = "UPDATE produit SET code_barre = ?, designation = ?, categorie = ?, prix_achat = ?, prix_vente = ?, stock_actuel = ?, stock_minimum = ?, date_peremption = ?, fournisseur_id = ? WHERE id = ?";
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, produit.getCodeBarre());
            statement.setString(2, produit.getDesignation());
            statement.setString(3, produit.getCategorie());
            statement.setBigDecimal(4, produit.getPrixAchat());
            statement.setBigDecimal(5, produit.getPrixVente());
            statement.setInt(6, produit.getStockActuel());
            statement.setInt(7, produit.getStockMinimum());
            if (produit.getDatePeremption() == null) {
                statement.setDate(8, null);
            } else {
                statement.setDate(8, Date.valueOf(produit.getDatePeremption()));
            }
            if (produit.getFournisseurId() == null) {
                statement.setObject(9, null);
            } else {
                statement.setLong(9, produit.getFournisseurId());
            }
            statement.setLong(10, produit.getId());
            statement.executeUpdate();
        }
    }

    public void delete(Long id) throws SQLException {
        String sql = "DELETE FROM produit WHERE id = ?";
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, id);
            statement.executeUpdate();
        }
    }

    public List<Produit> findByFournisseurId(Long fournisseurId) throws SQLException {
        String sql = SELECT_WITH_FOURNISSEUR + " WHERE p.fournisseur_id = ? ORDER BY p.designation";
        List<Produit> produits = new ArrayList<>();
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, fournisseurId);
            try (ResultSet rs = statement.executeQuery()) {
                while (rs.next()) {
                    produits.add(map(rs));
                }
            }
        }
        return produits;
    }

    public List<Produit> findProduitsACommanderParFournisseur(Long fournisseurId) throws SQLException {
        String sql = SELECT_WITH_FOURNISSEUR + " WHERE p.fournisseur_id = ? AND p.stock_actuel <= p.stock_minimum ORDER BY p.designation";
        List<Produit> produits = new ArrayList<>();
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, fournisseurId);
            try (ResultSet rs = statement.executeQuery()) {
                while (rs.next()) {
                    produits.add(map(rs));
                }
            }
        }
        return produits;
    }

    public void decrementerStock(Long produitId, int quantite) throws SQLException {
        String sql = "UPDATE produit SET stock_actuel = stock_actuel - ? WHERE id = ?";
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, quantite);
            statement.setLong(2, produitId);
            statement.executeUpdate();
        }
    }

    public int countAll() throws SQLException {
        return count("SELECT COUNT(*) FROM produit");
    }

    public int countAlertesStock() throws SQLException {
        return count("SELECT COUNT(*) FROM produit WHERE stock_actuel <= stock_minimum");
    }

    private int count(String sql) throws SQLException {
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet rs = statement.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
            return 0;
        }
    }

    private void bind(PreparedStatement statement, List<Object> params) throws SQLException {
        for (int i = 0; i < params.size(); i++) {
            statement.setObject(i + 1, params.get(i));
        }
    }

    private String resolveSort(String sort) {
        if ("stock_asc".equalsIgnoreCase(sort)) {
            return "p.stock_actuel ASC, p.designation ASC";
        }
        if ("stock_desc".equalsIgnoreCase(sort)) {
            return "p.stock_actuel DESC, p.designation ASC";
        }
        if ("prix_desc".equalsIgnoreCase(sort)) {
            return "p.prix_vente DESC, p.designation ASC";
        }
        if ("prix_asc".equalsIgnoreCase(sort)) {
            return "p.prix_vente ASC, p.designation ASC";
        }
        return "p.designation ASC";
    }

    private String resolveAlertSort(String sort) {
        if ("fournisseur_asc".equalsIgnoreCase(sort)) {
            return "f.raison_sociale ASC, p.stock_actuel ASC";
        }
        if ("stock_desc".equalsIgnoreCase(sort)) {
            return "p.stock_actuel DESC, p.designation ASC";
        }
        return "p.stock_actuel ASC, p.designation ASC";
    }

    private void addAdvancedFilters(StringBuilder sql, List<Object> params,
                                    String minPrix, String maxPrix, String minStock, String maxStock,
                                    String datePeremptionMin, String datePeremptionMax) {
        BigDecimal prixMin = parseBigDecimal(minPrix);
        if (prixMin != null) {
            sql.append(" AND p.prix_vente >= ?");
            params.add(prixMin);
        }
        BigDecimal prixMax = parseBigDecimal(maxPrix);
        if (prixMax != null) {
            sql.append(" AND p.prix_vente <= ?");
            params.add(prixMax);
        }
        Integer stockMin = parseInteger(minStock);
        if (stockMin != null) {
            sql.append(" AND p.stock_actuel >= ?");
            params.add(stockMin);
        }
        Integer stockMax = parseInteger(maxStock);
        if (stockMax != null) {
            sql.append(" AND p.stock_actuel <= ?");
            params.add(stockMax);
        }
        LocalDate peremptionMin = FormUtil.parseDate(datePeremptionMin);
        if (peremptionMin != null) {
            sql.append(" AND p.date_peremption >= ?");
            params.add(Date.valueOf(peremptionMin));
        }
        LocalDate peremptionMax = FormUtil.parseDate(datePeremptionMax);
        if (peremptionMax != null) {
            sql.append(" AND p.date_peremption <= ?");
            params.add(Date.valueOf(peremptionMax));
        }
    }

    private BigDecimal parseBigDecimal(String value) {
        if (value == null || value.isBlank()) {
            return null;
        }
        try {
            return new BigDecimal(value.trim());
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private Integer parseInteger(String value) {
        if (value == null || value.isBlank()) {
            return null;
        }
        try {
            return Integer.parseInt(value.trim());
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private Produit map(ResultSet rs) throws SQLException {
        Produit produit = new Produit();
        produit.setId(rs.getLong("id"));
        produit.setCodeBarre(rs.getString("code_barre"));
        produit.setDesignation(rs.getString("designation"));
        produit.setCategorie(rs.getString("categorie"));
        produit.setPrixAchat(rs.getBigDecimal("prix_achat"));
        produit.setPrixVente(rs.getBigDecimal("prix_vente"));
        produit.setStockActuel(rs.getInt("stock_actuel"));
        produit.setStockMinimum(rs.getInt("stock_minimum"));
        Date date = rs.getDate("date_peremption");
        if (date != null) {
            produit.setDatePeremption(date.toLocalDate());
        }
        long fournisseurId = rs.getLong("fournisseur_id");
        if (!rs.wasNull()) {
            produit.setFournisseurId(fournisseurId);
        }
        long fournisseurPk = rs.getLong("f_id");
        if (!rs.wasNull()) {
            com.supermarche.entity.Fournisseur fournisseur = new com.supermarche.entity.Fournisseur();
            fournisseur.setId(fournisseurPk);
            fournisseur.setRaisonSociale(rs.getString("raison_sociale"));
            fournisseur.setTelephone(rs.getString("telephone"));
            fournisseur.setEmail(rs.getString("email"));
            fournisseur.setDelaiLivraisonJours(rs.getInt("delai_livraison_jours"));
            fournisseur.setConditionsPaiement(rs.getString("conditions_paiement"));
            produit.setFournisseur(fournisseur);
        }
        return produit;
    }
}
