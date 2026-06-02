package com.supermarche.util;

import com.opencsv.CSVWriter;
import com.supermarche.entity.Produit;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.OutputStreamWriter;
import java.nio.charset.StandardCharsets;
import java.util.List;

public final class CSVUtil {

    private CSVUtil() {
    }

    public static void exporterProduits(HttpServletResponse response, List<Produit> produits) throws IOException {
        response.setContentType("text/csv");
        response.setCharacterEncoding(StandardCharsets.UTF_8.name());
        response.setHeader("Content-Disposition", "attachment; filename=produits.csv");

        try (CSVWriter writer = new CSVWriter(new OutputStreamWriter(response.getOutputStream(), StandardCharsets.UTF_8))) {
            writer.writeNext(new String[]{"ID", "Code barre", "Designation", "Categorie", "Prix vente", "Stock"});
            for (Produit produit : produits) {
                writer.writeNext(new String[]{
                    String.valueOf(produit.getId()),
                    produit.getCodeBarre(),
                    produit.getDesignation(),
                    produit.getCategorie(),
                    produit.getPrixVente() == null ? "" : produit.getPrixVente().toPlainString(),
                    String.valueOf(produit.getStockActuel())
                });
            }
        }
    }
}
