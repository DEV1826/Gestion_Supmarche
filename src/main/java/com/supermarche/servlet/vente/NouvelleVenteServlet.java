package com.supermarche.servlet.vente;

import com.supermarche.dao.ProduitDAO;
import com.supermarche.dao.VenteDAO;
import com.supermarche.entity.LigneVente;
import com.supermarche.entity.Produit;
import com.supermarche.entity.Utilisateur;
import com.supermarche.entity.Vente;
import com.supermarche.util.FlashUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/ventes/nouvelle")
public class NouvelleVenteServlet extends HttpServlet {

    private final ProduitDAO produitDAO = new ProduitDAO();
    private final VenteDAO venteDAO = new VenteDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        try {
            request.setAttribute("produits", produitDAO.findAll());
            FlashUtil.consume(request);
            request.getRequestDispatcher("/views/vente/caisse.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Impossible de charger la caisse.", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        Utilisateur utilisateur = (Utilisateur) request.getSession().getAttribute("utilisateurConnecte");
        String[] produitIds = request.getParameterValues("produitId");
        String[] quantites = request.getParameterValues("quantite");

        if (utilisateur == null || produitIds == null || quantites == null) {
            FlashUtil.error(request, "Session invalide ou panier vide.");
            response.sendRedirect(request.getContextPath() + "/ventes/nouvelle");
            return;
        }

        List<LigneVente> lignes = new ArrayList<>();
        try {
            for (int i = 0; i < produitIds.length; i++) {
                if (produitIds[i] == null || produitIds[i].isBlank()) {
                    continue;
                }
                Produit produit = produitDAO.findById(Long.parseLong(produitIds[i]));
                int quantite = Integer.parseInt(quantites[i]);
                if (produit != null && quantite > 0) {
                    if (quantite > produit.getStockActuel()) {
                        FlashUtil.error(request, "Stock insuffisant pour " + produit.getDesignation() + ".");
                        response.sendRedirect(request.getContextPath() + "/ventes/nouvelle");
                        return;
                    }
                    LigneVente ligne = new LigneVente(produit.getId(), quantite, produit.getPrixVente());
                    ligne.setProduit(produit);
                    lignes.add(ligne);
                }
            }

            if (lignes.isEmpty()) {
                FlashUtil.error(request, "Ajoute au moins un produit pour generer la facture.");
                response.sendRedirect(request.getContextPath() + "/ventes/nouvelle");
                return;
            }

            Vente vente = new Vente();
            vente.setCaissierId(utilisateur.getId());
            vente.setDateHeure(LocalDateTime.now());
            vente.setModePaiement(Vente.ModePaiement.valueOf(request.getParameter("modePaiement")));
            vente.setNumeroTicket(Vente.genererNumeroTicket());
            vente.setLignes(lignes);
            vente.calculerTotal();

            Long venteId = venteDAO.save(vente);
            response.sendRedirect(request.getContextPath() + "/ventes/ticket?id=" + venteId);
        } catch (SQLException e) {
            throw new ServletException("Impossible d'enregistrer la vente.", e);
        } catch (IllegalArgumentException e) {
            FlashUtil.error(request, "Mode de paiement ou quantite invalide.");
            response.sendRedirect(request.getContextPath() + "/ventes/nouvelle");
        }
    }
}
