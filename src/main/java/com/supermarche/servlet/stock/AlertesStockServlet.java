package com.supermarche.servlet.stock;

import com.supermarche.dao.FournisseurDAO;
import com.supermarche.dao.ProduitDAO;
import com.supermarche.entity.Fournisseur;
import com.supermarche.entity.Produit;
import com.supermarche.util.EmailUtil;
import com.supermarche.util.FlashUtil;
import com.supermarche.util.FormUtil;
import com.supermarche.util.MoneyUtil;
import com.supermarche.util.PaginationUtil;
import com.supermarche.util.PDFUtil;
import com.supermarche.util.SMSUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

public class AlertesStockServlet extends HttpServlet {

    private final ProduitDAO produitDAO = new ProduitDAO();
    private final FournisseurDAO fournisseurDAO = new FournisseurDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        try {
            String search = request.getParameter("search");
            String categorie = request.getParameter("categorie");
            String stockMaxValue = request.getParameter("stockMax");
            String sort = request.getParameter("sort");
            Integer stockMax = stockMaxValue == null || stockMaxValue.isBlank() ? null : FormUtil.parseInt(stockMaxValue, 0);
            int page = PaginationUtil.parsePage(request.getParameter("page"));
            int pageSize = PaginationUtil.parsePageSize(request.getParameter("size"), 10, 100);

            int totalFiltered = produitDAO.countAlertesStockFiltered(search, stockMax, categorie);
            int totalPages = PaginationUtil.totalPages(totalFiltered, pageSize);
            if (page > totalPages) {
                page = totalPages;
            }

            List<Produit> alertes = produitDAO.findAlertesStockFiltered(search, stockMax, categorie, sort, page, pageSize);
            request.setAttribute("alertes", alertes);
            request.setAttribute("groupesFournisseurs", groupBySupplier(alertes));
            request.setAttribute("search", search == null ? "" : search);
            request.setAttribute("categorie", categorie == null ? "" : categorie);
            request.setAttribute("stockMax", stockMaxValue == null ? "" : stockMaxValue);
            request.setAttribute("sort", sort == null ? "stock_asc" : sort);
            request.setAttribute("page", page);
            request.setAttribute("size", pageSize);
            request.setAttribute("totalFiltered", totalFiltered);
            request.setAttribute("totalPages", totalPages);
            FlashUtil.consume(request);
            request.getRequestDispatcher("/WEB-INF/views/stock/alertes.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Impossible de charger les alertes stock.", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        String action = request.getParameter("bulkAction");
        String[] selectedIds = request.getParameterValues("produitIds");
        String redirectUrl = request.getContextPath() + "/stock/alertes" + buildQueryString(request);
        if (selectedIds == null || selectedIds.length == 0) {
            FlashUtil.error(request, "Aucun produit critique selectionne.");
            response.sendRedirect(redirectUrl);
            return;
        }

        try {
            List<Produit> selectedProduits = new ArrayList<>();
            Set<Long> fournisseurIds = new LinkedHashSet<>();
            Map<Long, List<Produit>> produitsParFournisseur = new LinkedHashMap<>();
            for (String id : selectedIds) {
                Produit produit = produitDAO.findById(Long.parseLong(id));
                if (produit != null) {
                    selectedProduits.add(produit);
                    if (produit.getFournisseur() != null) {
                        fournisseurIds.add(produit.getFournisseur().getId());
                        produitsParFournisseur.computeIfAbsent(produit.getFournisseur().getId(), ignored -> new ArrayList<>()).add(produit);
                    }
                }
            }

            if ("notify".equalsIgnoreCase(action)) {
                for (Long fournisseurId : fournisseurIds) {
                    Fournisseur fournisseur = fournisseurDAO.findById(fournisseurId);
                    List<Produit> produitsFournisseur = produitsParFournisseur.getOrDefault(fournisseurId, java.util.Collections.emptyList());
                    if (fournisseur != null) {
                        if (fournisseur.getEmail() != null && !fournisseur.getEmail().isBlank()) {
                            EmailUtil.envoyerEmailAvecPieceJointe(
                                fournisseur.getEmail(),
                                "Bon de commande - " + fournisseur.getRaisonSociale(),
                                "Bonjour " + fournisseur.getRaisonSociale()
                                    + ",\n\nVeuillez trouver le bon de commande PDF des produits a reapprovisionner.\n\nCordialement,\nGestion Supermarche",
                                PDFUtil.genererBonCommandeBytes(fournisseur, produitsFournisseur),
                                "bon-commande-fournisseur-" + fournisseur.getId() + ".pdf",
                                "application/pdf"
                            );
                        }
                        if (fournisseur.getTelephone() != null && !fournisseur.getTelephone().isBlank()) {
                            SMSUtil.envoyerSMS(fournisseur.getTelephone(), buildSmsFournisseur(fournisseur, produitsFournisseur));
                        }
                    }
                }
                FlashUtil.success(request, "Notifications fournisseurs envoyees par email et/ou SMS selon les contacts disponibles.");
                response.sendRedirect(redirectUrl);
                return;
            }

            if ("pdf".equalsIgnoreCase(action)) {
                PDFUtil.genererRapportAlertesStock(response, selectedProduits);
                return;
            }

            FlashUtil.error(request, "Action bulk inconnue.");
            response.sendRedirect(redirectUrl);
        } catch (SQLException e) {
            throw new ServletException("Impossible de traiter l'action bulk sur les alertes stock.", e);
        } catch (RuntimeException e) {
            FlashUtil.error(request, e.getMessage());
            response.sendRedirect(redirectUrl);
        }
    }

    private String buildQueryString(HttpServletRequest request) {
        StringBuilder query = new StringBuilder();
        appendQueryParam(query, "search", request.getParameter("search"));
        appendQueryParam(query, "categorie", request.getParameter("categorie"));
        appendQueryParam(query, "stockMax", request.getParameter("stockMax"));
        appendQueryParam(query, "sort", request.getParameter("sort"));
        appendQueryParam(query, "size", request.getParameter("size"));
        appendQueryParam(query, "page", request.getParameter("page"));
        return query.isEmpty() ? "" : "?" + query;
    }

    private void appendQueryParam(StringBuilder query, String name, String value) {
        if (value == null || value.isBlank()) {
            return;
        }
        if (!query.isEmpty()) {
            query.append("&");
        }
        query.append(name)
            .append("=")
            .append(URLEncoder.encode(value, StandardCharsets.UTF_8));
    }

    private Map<Long, List<Produit>> groupBySupplier(List<Produit> alertes) {
        Map<Long, List<Produit>> grouped = new LinkedHashMap<>();
        for (Produit produit : alertes) {
            Long key = produit.getFournisseur() != null ? produit.getFournisseur().getId() : -1L;
            grouped.computeIfAbsent(key, ignored -> new ArrayList<>()).add(produit);
        }
        return grouped;
    }

    private String buildSmsFournisseur(Fournisseur fournisseur, List<Produit> produits) {
        java.math.BigDecimal total = java.math.BigDecimal.ZERO;
        for (Produit produit : produits) {
            int qte = FormUtil.quantiteACommander(produit);
            total = total.add(produit.getPrixAchat().multiply(java.math.BigDecimal.valueOf(qte)));
        }
        return "Alerte stock " + fournisseur.getRaisonSociale()
            + ": bon de commande pret pour " + produits.size() + " article(s), montant estime "
            + MoneyUtil.formatFcfa(total) + ". Verifiez votre email pour le PDF.";
    }
}
