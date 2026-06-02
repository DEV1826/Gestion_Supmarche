package com.supermarche.servlet.fournisseur;

import com.supermarche.dao.FournisseurDAO;
import com.supermarche.entity.Fournisseur;
import com.supermarche.util.FlashUtil;
import com.supermarche.util.FormUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/fournisseurs/update")
public class ModifierFournisseurServlet extends HttpServlet {

    private final FournisseurDAO fournisseurDAO = new FournisseurDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        Fournisseur fournisseur = new Fournisseur();
        fournisseur.setId(FormUtil.parseLong(request.getParameter("id")));
        fournisseur.setRaisonSociale(request.getParameter("raisonSociale"));
        fournisseur.setTelephone(request.getParameter("telephone"));
        fournisseur.setEmail(request.getParameter("email"));
        fournisseur.setDelaiLivraisonJours(FormUtil.parseInt(request.getParameter("delaiLivraisonJours"), 7));
        fournisseur.setConditionsPaiement(request.getParameter("conditionsPaiement"));

        try {
            fournisseurDAO.update(fournisseur);
            FlashUtil.success(request, "Fournisseur modifie avec succes.");
            response.sendRedirect(request.getContextPath() + "/fournisseurs");
        } catch (SQLException e) {
            throw new ServletException("Impossible de modifier le fournisseur.", e);
        }
    }
}
