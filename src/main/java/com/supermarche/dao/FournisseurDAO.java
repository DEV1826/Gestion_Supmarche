package com.supermarche.dao;

import com.supermarche.entity.Fournisseur;
import com.supermarche.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class FournisseurDAO {

    public List<Fournisseur> findAll() throws SQLException {
        String sql = "SELECT * FROM fournisseur ORDER BY raison_sociale";
        List<Fournisseur> fournisseurs = new ArrayList<>();
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet rs = statement.executeQuery()) {
            while (rs.next()) {
                fournisseurs.add(map(rs));
            }
        }
        return fournisseurs;
    }

    public List<Fournisseur> findFiltered(String search, String delayFilter) throws SQLException {
        return findFiltered(search, delayFilter, "raison_asc", 1, Integer.MAX_VALUE);
    }

    public List<Fournisseur> findFiltered(String search, String delayFilter, String sort, int page, int pageSize) throws SQLException {
        StringBuilder sql = new StringBuilder("SELECT * FROM fournisseur WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (search != null && !search.isBlank()) {
            sql.append(" AND (LOWER(raison_sociale) LIKE ? OR LOWER(telephone) LIKE ? OR LOWER(email) LIKE ?)");
            String like = "%" + search.trim().toLowerCase() + "%";
            params.add(like);
            params.add(like);
            params.add(like);
        }
        if ("fast".equalsIgnoreCase(delayFilter)) {
            sql.append(" AND delai_livraison_jours <= 7");
        } else if ("slow".equalsIgnoreCase(delayFilter)) {
            sql.append(" AND delai_livraison_jours > 7");
        }
        sql.append(" ORDER BY ").append(resolveSort(sort)).append(" LIMIT ? OFFSET ?");
        params.add(pageSize);
        params.add(Math.max(0, (page - 1) * pageSize));

        List<Fournisseur> fournisseurs = new ArrayList<>();
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                statement.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = statement.executeQuery()) {
                while (rs.next()) {
                    fournisseurs.add(map(rs));
                }
            }
        }
        return fournisseurs;
    }

    public int countFiltered(String search, String delayFilter) throws SQLException {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM fournisseur WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (search != null && !search.isBlank()) {
            sql.append(" AND (LOWER(raison_sociale) LIKE ? OR LOWER(telephone) LIKE ? OR LOWER(email) LIKE ?)");
            String like = "%" + search.trim().toLowerCase() + "%";
            params.add(like);
            params.add(like);
            params.add(like);
        }
        if ("fast".equalsIgnoreCase(delayFilter)) {
            sql.append(" AND delai_livraison_jours <= 7");
        } else if ("slow".equalsIgnoreCase(delayFilter)) {
            sql.append(" AND delai_livraison_jours > 7");
        }

        try (Connection connection = DBUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                statement.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = statement.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    public Fournisseur findById(Long id) throws SQLException {
        String sql = "SELECT * FROM fournisseur WHERE id = ?";
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

    public void save(Fournisseur fournisseur) throws SQLException {
        String sql = "INSERT INTO fournisseur(raison_sociale, telephone, email, delai_livraison_jours, conditions_paiement) VALUES (?, ?, ?, ?, ?)";
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, fournisseur.getRaisonSociale());
            statement.setString(2, fournisseur.getTelephone());
            statement.setString(3, fournisseur.getEmail());
            statement.setInt(4, fournisseur.getDelaiLivraisonJours());
            statement.setString(5, fournisseur.getConditionsPaiement());
            statement.executeUpdate();
        }
    }

    public void update(Fournisseur fournisseur) throws SQLException {
        String sql = "UPDATE fournisseur SET raison_sociale = ?, telephone = ?, email = ?, delai_livraison_jours = ?, conditions_paiement = ? WHERE id = ?";
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, fournisseur.getRaisonSociale());
            statement.setString(2, fournisseur.getTelephone());
            statement.setString(3, fournisseur.getEmail());
            statement.setInt(4, fournisseur.getDelaiLivraisonJours());
            statement.setString(5, fournisseur.getConditionsPaiement());
            statement.setLong(6, fournisseur.getId());
            statement.executeUpdate();
        }
    }

    public void delete(Long id) throws SQLException {
        String sql = "DELETE FROM fournisseur WHERE id = ?";
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, id);
            statement.executeUpdate();
        }
    }

    public int countAll() throws SQLException {
        String sql = "SELECT COUNT(*) FROM fournisseur";
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet rs = statement.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
            return 0;
        }
    }

    private String resolveSort(String sort) {
        if ("delai_asc".equalsIgnoreCase(sort)) {
            return "delai_livraison_jours ASC, raison_sociale ASC";
        }
        if ("delai_desc".equalsIgnoreCase(sort)) {
            return "delai_livraison_jours DESC, raison_sociale ASC";
        }
        return "raison_sociale ASC";
    }

    private Fournisseur map(ResultSet rs) throws SQLException {
        Fournisseur fournisseur = new Fournisseur();
        fournisseur.setId(rs.getLong("id"));
        fournisseur.setRaisonSociale(rs.getString("raison_sociale"));
        fournisseur.setTelephone(rs.getString("telephone"));
        fournisseur.setEmail(rs.getString("email"));
        fournisseur.setDelaiLivraisonJours(rs.getInt("delai_livraison_jours"));
        fournisseur.setConditionsPaiement(rs.getString("conditions_paiement"));
        return fournisseur;
    }
}
