package com.supermarche.util;

import com.supermarche.entity.Produit;

import java.math.BigDecimal;
import java.time.LocalDate;

public final class FormUtil {

    private FormUtil() {
    }

    public static int parseInt(String value, int defaultValue) {
        try {
            return Integer.parseInt(value);
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    public static Long parseLong(String value) {
        try {
            return value == null || value.isBlank() ? null : Long.parseLong(value);
        } catch (NumberFormatException e) {
            return null;
        }
    }

    public static BigDecimal parseDecimal(String value) {
        try {
            return value == null || value.isBlank() ? BigDecimal.ZERO : new BigDecimal(value);
        } catch (NumberFormatException e) {
            return BigDecimal.ZERO;
        }
    }

    public static LocalDate parseDate(String value) {
        try {
            return value == null || value.isBlank() ? null : LocalDate.parse(value);
        } catch (Exception e) {
            return null;
        }
    }

    public static int quantiteACommander(Produit produit) {
        int cible = Math.max(produit.getStockMinimum() * 2, produit.getStockMinimum() + 5);
        return Math.max(cible - produit.getStockActuel(), produit.getStockMinimum());
    }
}
