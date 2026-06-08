package com.supermarche.servlet.auth;

import com.supermarche.dao.UtilisateurDAO;
import com.supermarche.entity.Utilisateur;
import com.supermarche.util.BCryptUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;

public class LoginServlet extends HttpServlet {

    private final UtilisateurDAO utilisateurDAO = new UtilisateurDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        String login = request.getParameter("login");
        String motDePasse = request.getParameter("motDePasse");

        try {
            Utilisateur utilisateur = utilisateurDAO.findByLogin(login);
            if (utilisateur != null && BCryptUtil.verify(motDePasse, utilisateur.getMotDePasse())) {
                HttpSession session = request.getSession();
                session.setAttribute("utilisateurConnecte", utilisateur);
                response.sendRedirect(request.getContextPath() + "/dashboard");
                return;
            }
        } catch (SQLException e) {
            throw new ServletException("Erreur de connexion a la base.", e);
        } catch (RuntimeException e) {
            request.setAttribute("erreur", "Compte invalide ou mot de passe non compatible. Recharge les utilisateurs par defaut.");
            request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
            return;
        }

        request.setAttribute("erreur", "Login ou mot de passe invalide.");
        request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
    }
}
