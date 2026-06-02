package com.supermarche.dao;

import com.supermarche.entity.LigneVente;
import com.supermarche.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class LigneVenteDAO {

    public List<LigneVente> findByVenteId(Long venteId) throws SQLException {
        String sql = "SELECT * FROM ligne_vente WHERE vente_id = ?";
        List<LigneVente> lignes = new ArrayList<>();
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, venteId);
            try (ResultSet rs = statement.executeQuery()) {
                while (rs.next()) {
                    LigneVente ligne = new LigneVente();
                    ligne.setId(rs.getLong("id"));
                    ligne.setVenteId(rs.getLong("vente_id"));
                    ligne.setProduitId(rs.getLong("produit_id"));
                    ligne.setQuantite(rs.getInt("quantite"));
                    ligne.setPrixUnitaire(rs.getBigDecimal("prix_unitaire"));
                    ligne.setSousTotal(rs.getBigDecimal("sous_total"));
                    lignes.add(ligne);
                }
            }
        }
        return lignes;
    }
}
