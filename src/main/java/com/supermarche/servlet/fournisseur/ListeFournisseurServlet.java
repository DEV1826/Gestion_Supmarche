package com.supermarche.servlet.fournisseur;

import com.supermarche.dao.FournisseurDAO;
import com.supermarche.dao.ProduitDAO;
import com.supermarche.util.FlashUtil;
import com.supermarche.util.PaginationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;

public class ListeFournisseurServlet extends HttpServlet {

    private final FournisseurDAO fournisseurDAO = new FournisseurDAO();
    private final ProduitDAO produitDAO = new ProduitDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        try {
            String search = request.getParameter("search");
            String delai = request.getParameter("delai");
            String sort = request.getParameter("sort");
            int page = PaginationUtil.parsePage(request.getParameter("page"));
            int pageSize = PaginationUtil.parsePageSize(request.getParameter("size"), 10, 100);
            int totalFiltered = fournisseurDAO.countFiltered(search, delai);
            int totalPages = PaginationUtil.totalPages(totalFiltered, pageSize);
            if (page > totalPages) {
                page = totalPages;
            }

            request.setAttribute("fournisseurs", fournisseurDAO.findFiltered(search, delai, sort, page, pageSize));
            request.setAttribute("produitsEnAlerte", produitDAO.findAlertesStock());
            request.setAttribute("search", search == null ? "" : search);
            request.setAttribute("delai", delai == null ? "" : delai);
            request.setAttribute("sort", sort == null ? "raison_asc" : sort);
            request.setAttribute("page", page);
            request.setAttribute("size", pageSize);
            request.setAttribute("totalFiltered", totalFiltered);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalFournisseurs", fournisseurDAO.countAll());
            FlashUtil.consume(request);
            request.getRequestDispatcher("/WEB-INF/views/fournisseur/liste.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Impossible de charger les fournisseurs.", e);
        }
    }
}
