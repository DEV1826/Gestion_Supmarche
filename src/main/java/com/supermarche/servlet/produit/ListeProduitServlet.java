package com.supermarche.servlet.produit;

import com.supermarche.dao.FournisseurDAO;
import com.supermarche.dao.ProduitDAO;
import com.supermarche.util.CSVUtil;
import com.supermarche.util.FlashUtil;
import com.supermarche.util.PaginationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;

public class ListeProduitServlet extends HttpServlet {

    private final ProduitDAO produitDAO = new ProduitDAO();
    private final FournisseurDAO fournisseurDAO = new FournisseurDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        try {
            String export = request.getParameter("export");
            String search = request.getParameter("search");
            String categorie = request.getParameter("categorie");
            String stock = request.getParameter("stock");
            String minPrix = request.getParameter("minPrix");
            String maxPrix = request.getParameter("maxPrix");
            String minStock = request.getParameter("minStock");
            String maxStock = request.getParameter("maxStock");
            String datePeremptionMin = request.getParameter("datePeremptionMin");
            String datePeremptionMax = request.getParameter("datePeremptionMax");
            String sort = request.getParameter("sort");
            int page = PaginationUtil.parsePage(request.getParameter("page"));
            int pageSize = PaginationUtil.parsePageSize(request.getParameter("size"), 10, 100);
            if ("csv".equalsIgnoreCase(export)) {
                CSVUtil.exporterProduits(response, produitDAO.findAdvancedFiltered(
                    search, categorie, stock, minPrix, maxPrix, minStock, maxStock, datePeremptionMin, datePeremptionMax, sort, 1, Integer.MAX_VALUE
                ));
                return;
            }

            int totalFiltered = produitDAO.countAdvancedFiltered(
                search, categorie, stock, minPrix, maxPrix, minStock, maxStock, datePeremptionMin, datePeremptionMax
            );
            int totalPages = PaginationUtil.totalPages(totalFiltered, pageSize);
            if (page > totalPages) {
                page = totalPages;
            }

            request.setAttribute("produits", produitDAO.findAdvancedFiltered(
                search, categorie, stock, minPrix, maxPrix, minStock, maxStock, datePeremptionMin, datePeremptionMax, sort, page, pageSize
            ));
            request.setAttribute("fournisseurs", fournisseurDAO.findAll());
            request.setAttribute("search", search == null ? "" : search);
            request.setAttribute("categorie", categorie == null ? "" : categorie);
            request.setAttribute("stock", stock == null ? "" : stock);
            request.setAttribute("minPrix", minPrix == null ? "" : minPrix);
            request.setAttribute("maxPrix", maxPrix == null ? "" : maxPrix);
            request.setAttribute("minStock", minStock == null ? "" : minStock);
            request.setAttribute("maxStock", maxStock == null ? "" : maxStock);
            request.setAttribute("datePeremptionMin", datePeremptionMin == null ? "" : datePeremptionMin);
            request.setAttribute("datePeremptionMax", datePeremptionMax == null ? "" : datePeremptionMax);
            request.setAttribute("sort", sort == null ? "designation_asc" : sort);
            request.setAttribute("page", page);
            request.setAttribute("size", pageSize);
            request.setAttribute("totalFiltered", totalFiltered);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalProduits", produitDAO.countAll());
            request.setAttribute("totalAlertes", produitDAO.countAlertesStock());
            FlashUtil.consume(request);
            request.getRequestDispatcher("/WEB-INF/views/produit/liste.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Impossible de charger les produits.", e);
        }
    }
}
