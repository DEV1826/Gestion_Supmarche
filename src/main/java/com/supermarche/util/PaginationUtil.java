package com.supermarche.util;

public final class PaginationUtil {

    private PaginationUtil() {
    }

    public static int parsePage(String value) {
        return Math.max(FormUtil.parseInt(value, 1), 1);
    }

    public static int parsePageSize(String value, int defaultValue, int max) {
        int parsed = FormUtil.parseInt(value, defaultValue);
        if (parsed <= 0) {
            return defaultValue;
        }
        return Math.min(parsed, max);
    }

    public static int totalPages(int totalItems, int pageSize) {
        if (pageSize <= 0) {
            return 1;
        }
        return Math.max(1, (int) Math.ceil(totalItems / (double) pageSize));
    }
}
