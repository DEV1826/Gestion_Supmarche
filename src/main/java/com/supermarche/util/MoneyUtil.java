package com.supermarche.util;

import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.util.Locale;

public final class MoneyUtil {

    private static final DecimalFormat FCFA_FORMAT;

    static {
        DecimalFormatSymbols symbols = new DecimalFormatSymbols(Locale.FRANCE);
        symbols.setGroupingSeparator(' ');
        FCFA_FORMAT = new DecimalFormat("#,##0", symbols);
    }

    private MoneyUtil() {
    }

    public static String formatFcfa(BigDecimal amount) {
        if (amount == null) {
            return "0 FCFA";
        }
        return FCFA_FORMAT.format(amount) + " FCFA";
    }
}
