package com.supermarche.util;

import at.favre.lib.crypto.bcrypt.BCrypt;

public final class BCryptUtil {

    private BCryptUtil() {
    }

    public static String hash(String plainText) {
        return BCrypt.withDefaults().hashToString(12, plainText.toCharArray());
    }

    public static boolean verify(String plainText, String hash) {
        BCrypt.Result result = BCrypt.verifyer().verify(plainText.toCharArray(), hash);
        return result.verified;
    }
}
