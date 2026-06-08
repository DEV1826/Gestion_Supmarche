package com.supermarche.servlet.fournisseur;

import com.supermarche.dao.FournisseurDAO;
import com.supermarche.dao.ProduitDAO;
import com.supermarche.entity.Fournisseur;
import com.supermarche.entity.Produit;
import com.supermarche.util.EmailUtil;
import com.supermarche.util.MoneyUtil;
import com.supermarche.util.PDFUtil;
import com.supermarche.util.SMSUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

public class BonCommandeFournisseurServlet extends HttpServlet {

    private final FournisseurDAO fournisseurDAO = new FournisseurDAO();
    private final ProduitDAO produitDAO = new ProduitDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        String fournisseurId = request.getParameter("fournisseurId");
        if (fournisseurId == null || fournisseurId.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/fournisseurs");
            return;
        }

        try {
            Fournisseur fournisseur = fournisseurDAO.findById(Long.parseLong(fournisseurId));
            if (fournisseur == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }

            List<Produit> produits = produitDAO.findProduitsACommanderParFournisseur(fournisseur.getId());
            if (produits.isEmpty()) {
                produits = produitDAO.findByFournisseurId(fournisseur.getId());
            }

            String channel = request.getParameter("channel");
            if (request.getParameter("notify") != null && (channel == null || channel.isBlank())) {
                channel = "sms";
            }

            byte[] pdf = PDFUtil.genererBonCommandeBytes(fournisseur, produits);
            if ("email".equalsIgnoreCase(channel) || "both".equalsIgnoreCase(channel)) {
                EmailUtil.envoyerEmailAvecPieceJointe(
                    fournisseur.getEmail(),
                    "Bon de commande - " + fournisseur.getRaisonSociale(),
                    buildMessageFournisseur(fournisseur, produits),
                    pdf,
                    "bon-commande-fournisseur-" + fournisseur.getId() + ".pdf",
                    "application/pdf"
                );
            }
            if ("sms".equalsIgnoreCase(channel) || "both".equalsIgnoreCase(channel)) {
                SMSUtil.envoyerSMS(fournisseur.getTelephone(), buildSmsFournisseur(fournisseur, produits));
            }

            if (channel != null && !channel.isBlank()) {
                response.sendRedirect(request.getContextPath() + "/fournisseurs");
                return;
            }

            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", "attachment; filename=bon-commande-fournisseur-" + fournisseur.getId() + ".pdf");
            response.getOutputStream().write(pdf);
        } catch (SQLException e) {
            throw new ServletException("Impossible de generer le bon de commande.", e);
        }
    }

    private String buildMessageFournisseur(Fournisseur fournisseur, List<Produit> produits) {
        return "Bonjour " + fournisseur.getRaisonSociale() + ",\n\n"
            + "Veuillez trouver en piece jointe le bon de commande correspondant aux articles en attente de reapprovisionnement.\n"
            + "Nombre d'articles: " + produits.size() + "\n\n"
            + "Cordialement,\nGestion Supermarche";
    }

    private String buildSmsFournisseur(Fournisseur fournisseur, List<Produit> produits) {
        java.math.BigDecimal total = java.math.BigDecimal.ZERO;
        for (Produit produit : produits) {
            int qte = com.supermarche.util.FormUtil.quantiteACommander(produit);
            total = total.add(produit.getPrixAchat().multiply(java.math.BigDecimal.valueOf(qte)));
        }
        return "Commande fournisseur " + fournisseur.getRaisonSociale()
            + ": " + produits.size() + " article(s), montant estime "
            + MoneyUtil.formatFcfa(total) + ". Consultez votre email pour le PDF.";
    }
}
