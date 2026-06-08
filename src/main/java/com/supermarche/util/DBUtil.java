package com.supermarche.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public final class DBUtil {

    static {
        try {
            String driver = AppConfig.getDb("db.driver", "DB_DRIVER");
            if (driver == null || driver.isBlank()) {
                throw new IllegalStateException("Driver JDBC manquant (db.driver/DB_DRIVER)");
            }
            Class.forName(driver);
        } catch (ClassNotFoundException e) {
            throw new ExceptionInInitializerError("Impossible de charger le driver JDBC : " + e.getMessage());
        }
    }

    private DBUtil() {
    }

    public static Connection getConnection() throws SQLException {
        String url = AppConfig.getDb("db.url", "DB_URL");
        String username = AppConfig.getDb("db.username", "DB_USERNAME");
        String password = AppConfig.getDb("db.password", "DB_PASSWORD");

        // Validation explicite des paramètres obligatoires
        AppConfig.required(url, "URL de la base de données (db.url/DB_URL)");
        AppConfig.required(username, "Nom d'utilisateur (db.username/DB_USERNAME)");
        // Le mot de passe peut être vide, pas de required

        return DriverManager.getConnection(url, username, password);
    }
}