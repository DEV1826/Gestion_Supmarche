package com.supermarche.util;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

public final class FlashUtil {

    private static final String FLASH_TYPE = "flashType";
    private static final String FLASH_MESSAGE = "flashMessage";

    private FlashUtil() {
    }

    public static void success(HttpServletRequest request, String message) {
        put(request, "success", message);
    }

    public static void error(HttpServletRequest request, String message) {
        put(request, "error", message);
    }

    public static void consume(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return;
        }
        Object type = session.getAttribute(FLASH_TYPE);
        Object message = session.getAttribute(FLASH_MESSAGE);
        if (type != null) {
            request.setAttribute(FLASH_TYPE, type);
        }
        if (message != null) {
            request.setAttribute(FLASH_MESSAGE, message);
        }
        session.removeAttribute(FLASH_TYPE);
        session.removeAttribute(FLASH_MESSAGE);
    }

    private static void put(HttpServletRequest request, String type, String message) {
        HttpSession session = request.getSession();
        session.setAttribute(FLASH_TYPE, type);
        session.setAttribute(FLASH_MESSAGE, message);
    }
}
