package com.supermarche.dao;

import com.supermarche.entity.Utilisateur;
import com.supermarche.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;

public class UtilisateurDAO {

    public Utilisateur findByLogin(String login) throws SQLException {
        String sql = "SELECT * FROM utilisateur WHERE login = ? AND actif = TRUE";
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, login);
            try (ResultSet rs = statement.executeQuery()) {
                if (rs.next()) {
                    return map(rs);
                }
            }
        }
        return null;
    }

    private Utilisateur map(ResultSet rs) throws SQLException {
        Utilisateur utilisateur = new Utilisateur();
        utilisateur.setId(rs.getLong("id"));
        utilisateur.setNom(rs.getString("nom"));
        utilisateur.setPrenom(rs.getString("prenom"));
        utilisateur.setLogin(rs.getString("login"));
        utilisateur.setMotDePasse(rs.getString("mot_de_passe"));
        utilisateur.setRole(Utilisateur.Role.valueOf(rs.getString("role")));
        utilisateur.setActif(rs.getBoolean("actif"));
        Timestamp timestamp = rs.getTimestamp("date_creation");
        if (timestamp != null) {
            utilisateur.setDateCreation(timestamp.toLocalDateTime());
        }
        return utilisateur;
    }
}
