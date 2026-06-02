package com.supermarche.servlet.produit;

import com.supermarche.dao.ProduitDAO;
import com.supermarche.util.FlashUtil;
import com.supermarche.util.FormUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/produits/supprimer")
public class SupprimerProduitServlet extends HttpServlet {

    private final ProduitDAO produitDAO = new ProduitDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        Long id = FormUtil.parseLong(request.getParameter("id"));
        if (id == null) {
            FlashUtil.error(request, "Produit introuvable pour la suppression.");
            response.sendRedirect(request.getContextPath() + "/produits");
            return;
        }

        try {
            produitDAO.delete(id);
            FlashUtil.success(request, "Produit supprime avec succes.");
            response.sendRedirect(request.getContextPath() + "/produits");
        } catch (SQLException e) {
            throw new ServletException("Impossible de supprimer le produit.", e);
        }
    }
}
