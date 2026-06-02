package com.supermarche.listener;

import com.supermarche.dao.ProduitDAO;
import com.supermarche.entity.Produit;
import com.supermarche.util.SMSUtil;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.SQLException;
import java.util.List;

@WebListener
public class StockAlertListener implements ServletContextListener {

    private static final Logger LOGGER = LoggerFactory.getLogger(StockAlertListener.class);

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        ProduitDAO produitDAO = new ProduitDAO();
        try {
            List<Produit> alertes = produitDAO.findAlertesStock();
            for (Produit produit : alertes) {
                if (produit.getFournisseur() != null && produit.getFournisseur().getTelephone() != null
                    && !produit.getFournisseur().getTelephone().isBlank()) {
                    SMSUtil.envoyerSMS(produit.getFournisseur().getTelephone(),
                        "RUPTURE IMMINENTE : " + produit.getDesignation() + " - stock : "
                            + produit.getStockActuel() + " unites");
                }
            }
            LOGGER.info("{} produits sous seuil de stock au demarrage.", alertes.size());
        } catch (SQLException e) {
            LOGGER.warn("Impossible de verifier les alertes de stock au demarrage.", e);
        } catch (RuntimeException e) {
            LOGGER.warn("Alerte SMS non envoyee : {}", e.getMessage());
        }
    }
}
