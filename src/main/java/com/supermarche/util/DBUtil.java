package com.supermarche.util;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public final class DBUtil {

    private static final Properties PROPERTIES = new Properties();

    static {
        try (InputStream input = DBUtil.class.getClassLoader().getResourceAsStream("db.properties")) {
            if (input == null) {
                throw new IllegalStateException("Le fichier db.properties est introuvable.");
            }
            PROPERTIES.load(input);
            Class.forName(resolve("db.driver", "DB_DRIVER"));
        } catch (IOException | ClassNotFoundException e) {
            throw new ExceptionInInitializerError(e);
        }
    }

    private DBUtil() {
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(
            resolve("db.url", "DB_URL"),
            resolve("db.username", "DB_USERNAME"),
            resolve("db.password", "DB_PASSWORD")
        );
    }

    private static String resolve(String key, String envKey) {
        String envValue = System.getenv(envKey);
        if (envValue != null && !envValue.isBlank()) {
            return envValue.trim();
        }
        return PROPERTIES.getProperty(key);
    }
}
