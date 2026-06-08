package com.supermarche.util;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public final class AppConfig {

    private static final Properties DB_PROPERTIES = load("db.properties");
    private static final Properties APP_PROPERTIES = load("app.properties");

    private AppConfig() {
    }

    public static String getDb(String key, String envKey) {
        return getValue(DB_PROPERTIES, key, envKey, null);
    }

    public static String getApp(String key, String envKey, String defaultValue) {
        return getValue(APP_PROPERTIES, key, envKey, defaultValue);
    }

    public static boolean getBoolean(String key, String envKey, boolean defaultValue) {
        String value = getApp(key, envKey, String.valueOf(defaultValue));
        return "true".equalsIgnoreCase(value) || "1".equals(value) || "yes".equalsIgnoreCase(value);
    }

    private static String getValue(Properties properties, String key, String envKey, String defaultValue) {
        String envValue = System.getenv(envKey);
        if (envValue != null && !envValue.isBlank()) {
            return envValue.trim();
        }

        String propertyValue = properties.getProperty(key);
        if (propertyValue != null && !propertyValue.isBlank()) {
            return propertyValue.trim();
        }

        return defaultValue;
    }

    private static Properties load(String resourceName) {
        Properties properties = new Properties();
        try (InputStream input = AppConfig.class.getClassLoader().getResourceAsStream(resourceName)) {
            if (input != null) {
                properties.load(input);
            }
        } catch (IOException e) {
            throw new ExceptionInInitializerError("Impossible de charger " + resourceName + ": " + e.getMessage());
        }
        return properties;
    }

    public static String required(String value, String label) {
        if (value == null || value.isBlank()) {
            throw new IllegalStateException("Configuration manquante pour " + label + ".");
        }
        return value;
    }

    public static String normalizePhone(String phone) {
        return phone == null ? "" : phone.trim().replace(" ", "");
    }

  
}
