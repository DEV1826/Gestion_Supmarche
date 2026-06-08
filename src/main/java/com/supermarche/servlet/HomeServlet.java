package com.supermarche.servlet;

import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

public class HomeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        boolean connected = session != null && session.getAttribute("utilisateurConnecte") != null;
        response.sendRedirect(request.getContextPath() + (connected ? "/dashboard" : "/login"));
    }
}
