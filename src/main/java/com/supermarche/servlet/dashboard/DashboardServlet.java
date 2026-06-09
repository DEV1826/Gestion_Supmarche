package com.supermarche.servlet.dashboard;

import com.supermarche.dao.FournisseurDAO;
import com.supermarche.dao.ProduitDAO;
import com.supermarche.dao.VenteDAO;
import com.supermarche.entity.Produit;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

public class DashboardServlet extends HttpServlet {

    private final VenteDAO venteDAO = new VenteDAO();
    private final ProduitDAO produitDAO = new ProduitDAO();
    private final FournisseurDAO fournisseurDAO = new FournisseurDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        try {
            int totalProduits = produitDAO.countAll();
            int alertesStock = produitDAO.countAlertesStock();
            List<Produit> alertes = produitDAO.findAlertesStock();

            request.setAttribute("kpis", venteDAO.kpis());
            request.setAttribute("alertesStock", alertesStock);
            request.setAttribute("totalProduits", totalProduits);
            request.setAttribute("totalFournisseurs", fournisseurDAO.countAll());
            request.setAttribute("topProduits", venteDAO.topProduits());
            request.setAttribute("caParCategorie", venteDAO.caParCategorie());
            request.setAttribute("ventesHebdo", venteDAO.ventesHebdo());
            request.setAttribute("alertes", alertes);
            request.setAttribute("stockOk", Math.max(0, totalProduits - alertesStock));
            request.setAttribute("tauxAlerte", totalProduits > 0 ? (alertesStock * 100.0) / totalProduits : 0);
            request.getRequestDispatcher("/WEB-INF/views/dashboard/index.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Impossible de charger le tableau de bord.", e);
        }
    }
}
