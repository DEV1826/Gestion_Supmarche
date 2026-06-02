package com.supermarche.servlet.produit;

import com.supermarche.dao.FournisseurDAO;
import com.supermarche.dao.ProduitDAO;
import com.supermarche.entity.Produit;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/produits/modifier")
public class FormProduitServlet extends HttpServlet {

    private final ProduitDAO produitDAO = new ProduitDAO();
    private final FournisseurDAO fournisseurDAO = new FournisseurDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        String id = request.getParameter("id");
        if (id == null || id.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/produits");
            return;
        }

        try {
            Produit produit = produitDAO.findById(Long.parseLong(id));
            if (produit == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }
            request.setAttribute("produit", produit);
            request.setAttribute("fournisseurs", fournisseurDAO.findAll());
            request.getRequestDispatcher("/views/produit/form.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Impossible de charger le produit.", e);
        }
    }
}
