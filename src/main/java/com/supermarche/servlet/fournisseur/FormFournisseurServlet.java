package com.supermarche.servlet.fournisseur;

import com.supermarche.dao.FournisseurDAO;
import com.supermarche.entity.Fournisseur;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/fournisseurs/modifier")
public class FormFournisseurServlet extends HttpServlet {

    private final FournisseurDAO fournisseurDAO = new FournisseurDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        String id = request.getParameter("id");
        if (id == null || id.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/fournisseurs");
            return;
        }

        try {
            Fournisseur fournisseur = fournisseurDAO.findById(Long.parseLong(id));
            if (fournisseur == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }
            request.setAttribute("fournisseur", fournisseur);
            request.getRequestDispatcher("/views/fournisseur/form.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Impossible de charger le fournisseur.", e);
        }
    }
}
