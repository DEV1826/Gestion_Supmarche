package com.supermarche.filter;

import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

public class AuthFilter implements Filter {

    // Chemins accessibles sans authentification
    private static final List<String> PUBLIC_PATHS = List.of(
        "/login",
        "/css/",
        "/js/",
        "/images/",
        "/WEB-INF/views/auth/"
    );

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;
        HttpSession session = request.getSession(false);

        String uri = request.getRequestURI();
        String contextPath = request.getContextPath();
        String path = uri.substring(contextPath.length());

        // Vérifier si l'URI demandée est publique
        boolean isPublic = PUBLIC_PATHS.stream().anyMatch(path::startsWith);

        if (isPublic) {
            chain.doFilter(req, res); // Accès libre
            return;
        }

        // Vérifier l'authentification pour les autres chemins
        if (session != null && session.getAttribute("utilisateurConnecte") != null) {
            chain.doFilter(req, res);
        } else {
            response.sendRedirect(contextPath + "/login");
        }
    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void destroy() {}
}