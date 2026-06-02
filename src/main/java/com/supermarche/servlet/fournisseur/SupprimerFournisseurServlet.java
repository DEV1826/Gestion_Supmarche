package com.supermarche.servlet.fournisseur;

import com.supermarche.dao.FournisseurDAO;
import com.supermarche.util.FlashUtil;
import com.supermarche.util.FormUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/fournisseurs/supprimer")
public class SupprimerFournisseurServlet extends HttpServlet {

    private final FournisseurDAO fournisseurDAO = new FournisseurDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        Long id = FormUtil.parseLong(request.getParameter("id"));
        if (id == null) {
            FlashUtil.error(request, "Fournisseur introuvable pour la suppression.");
            response.sendRedirect(request.getContextPath() + "/fournisseurs");
            return;
        }

        try {
            fournisseurDAO.delete(id);
            FlashUtil.success(request, "Fournisseur supprime avec succes.");
            response.sendRedirect(request.getContextPath() + "/fournisseurs");
        } catch (SQLException e) {
            throw new ServletException("Impossible de supprimer le fournisseur.", e);
        }
    }
}
