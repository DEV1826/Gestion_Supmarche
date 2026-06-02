package com.supermarche.servlet.vente;

import com.supermarche.dao.VenteDAO;
import com.supermarche.entity.Vente;
import com.supermarche.util.PDFUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/ventes/ticket")
public class TicketServlet extends HttpServlet {

    private final VenteDAO venteDAO = new VenteDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        String id = request.getParameter("id");
        String format = request.getParameter("format");
        if (id == null || id.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/ventes/nouvelle");
            return;
        }

        try {
            Vente vente = venteDAO.findById(Long.parseLong(id));
            if (vente == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }

            if ("pdf".equalsIgnoreCase(format)) {
                PDFUtil.genererTicket(response, vente);
                return;
            }

            request.setAttribute("vente", vente);
            request.getRequestDispatcher("/views/vente/ticket.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Impossible de charger le ticket.", e);
        }
    }
}
