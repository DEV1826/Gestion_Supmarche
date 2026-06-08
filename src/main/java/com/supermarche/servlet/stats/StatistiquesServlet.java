package com.supermarche.servlet.stats;

import com.supermarche.dao.ProduitDAO;
import com.supermarche.dao.VenteDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;

public class StatistiquesServlet extends HttpServlet {

    private final VenteDAO venteDAO = new VenteDAO();
    private final ProduitDAO produitDAO = new ProduitDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        try {
            request.setAttribute("topProduits", venteDAO.topProduits());
            request.setAttribute("caParCategorie", venteDAO.caParCategorie());
            request.setAttribute("ventesHebdo", venteDAO.ventesHebdo());
            request.setAttribute("kpis", venteDAO.kpis());
            request.setAttribute("alertesStock", produitDAO.countAlertesStock());
            request.getRequestDispatcher("/WEB-INF/views/stats/dashboard.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Impossible de charger les statistiques.", e);
        }
    }
}
