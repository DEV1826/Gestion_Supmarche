package com.supermarche.servlet.dashboard;

import com.supermarche.dao.FournisseurDAO;
import com.supermarche.dao.ProduitDAO;
import com.supermarche.dao.VenteDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    private final VenteDAO venteDAO = new VenteDAO();
    private final ProduitDAO produitDAO = new ProduitDAO();
    private final FournisseurDAO fournisseurDAO = new FournisseurDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        try {
            request.setAttribute("kpis", venteDAO.kpis());
            request.setAttribute("alertesStock", produitDAO.countAlertesStock());
            request.setAttribute("totalProduits", produitDAO.countAll());
            request.setAttribute("totalFournisseurs", fournisseurDAO.countAll());
            request.setAttribute("topProduits", venteDAO.topProduits());
            request.setAttribute("alertes", produitDAO.findAlertesStock());
            request.getRequestDispatcher("/views/dashboard/index.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Impossible de charger le tableau de bord.", e);
        }
    }
}
