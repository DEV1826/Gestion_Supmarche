package com.supermarche.servlet.produit;

import com.supermarche.dao.ProduitDAO;
import com.supermarche.entity.Produit;
import com.supermarche.util.FlashUtil;
import com.supermarche.util.FormUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/produits/update")
public class ModifierProduitServlet extends HttpServlet {

    private final ProduitDAO produitDAO = new ProduitDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        Produit produit = new Produit();
        produit.setId(FormUtil.parseLong(request.getParameter("id")));
        produit.setCodeBarre(request.getParameter("codeBarre"));
        produit.setDesignation(request.getParameter("designation"));
        produit.setCategorie(request.getParameter("categorie"));
        produit.setPrixAchat(FormUtil.parseDecimal(request.getParameter("prixAchat")));
        produit.setPrixVente(FormUtil.parseDecimal(request.getParameter("prixVente")));
        produit.setStockActuel(FormUtil.parseInt(request.getParameter("stockActuel"), 0));
        produit.setStockMinimum(FormUtil.parseInt(request.getParameter("stockMinimum"), 5));
        produit.setDatePeremption(FormUtil.parseDate(request.getParameter("datePeremption")));
        produit.setFournisseurId(FormUtil.parseLong(request.getParameter("fournisseurId")));

        try {
            produitDAO.update(produit);
            FlashUtil.success(request, "Produit modifie avec succes.");
            response.sendRedirect(request.getContextPath() + "/produits");
        } catch (SQLException e) {
            throw new ServletException("Impossible de modifier le produit.", e);
        }
    }
}
