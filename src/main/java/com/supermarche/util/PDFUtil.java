package com.supermarche.util;

import com.itextpdf.kernel.colors.ColorConstants;
import com.itextpdf.kernel.geom.PageSize;
import com.itextpdf.kernel.pdf.PdfWriter;
import com.itextpdf.layout.Document;
import com.itextpdf.layout.borders.SolidBorder;
import com.itextpdf.layout.element.Cell;
import com.itextpdf.layout.element.Paragraph;
import com.itextpdf.layout.element.Table;
import com.itextpdf.layout.properties.TextAlignment;
import com.supermarche.entity.LigneVente;
import com.supermarche.entity.Fournisseur;
import com.supermarche.entity.Produit;
import com.supermarche.entity.Vente;
import jakarta.servlet.http.HttpServletResponse;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public final class PDFUtil {

    private PDFUtil() {
    }

    public static void genererTicket(HttpServletResponse response, Vente vente) throws IOException {
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=facture-" + vente.getNumeroTicket() + ".pdf");

        try (Document document = new Document(new com.itextpdf.kernel.pdf.PdfDocument(new PdfWriter(response.getOutputStream())), PageSize.A4)) {
            document.add(new Paragraph("SUPERMARCHE")
                .setBold()
                .setFontSize(22)
                .setFontColor(ColorConstants.BLACK));
            document.add(new Paragraph("Facture / Ticket de caisse")
                .setFontSize(16)
                .setFontColor(ColorConstants.DARK_GRAY)
                .setMarginBottom(10));
            document.add(new Paragraph("Numero: " + vente.getNumeroTicket()));
            document.add(new Paragraph("Date: " + vente.getDateHeure()));
            document.add(new Paragraph("Mode paiement: " + vente.getModePaiement()).setMarginBottom(16));

            Table table = new Table(new float[]{4f, 2f, 2f, 2f});
            table.useAllAvailableWidth();
            addHeader(table, "Produit");
            addHeader(table, "Quantite");
            addHeader(table, "PU");
            addHeader(table, "Sous-total");

            for (LigneVente ligne : vente.getLignes()) {
                String designation = ligne.getProduit() != null ? ligne.getProduit().getDesignation() : String.valueOf(ligne.getProduitId());
                table.addCell(cell(designation));
                table.addCell(cell(String.valueOf(ligne.getQuantite())));
                table.addCell(cell(MoneyUtil.formatFcfa(ligne.getPrixUnitaire())));
                table.addCell(cell(MoneyUtil.formatFcfa(ligne.getSousTotal())));
            }

            document.add(table);
            document.add(new Paragraph("Total TTC: " + MoneyUtil.formatFcfa(vente.getTotalTtc()))
                .setBold()
                .setTextAlignment(TextAlignment.RIGHT)
                .setMarginTop(18));
            document.add(new Paragraph("Merci pour votre achat.")
                .setItalic()
                .setTextAlignment(TextAlignment.CENTER)
                .setMarginTop(12));
        }
    }

    public static void genererBonCommande(HttpServletResponse response, Fournisseur fournisseur, List<Produit> produits)
        throws IOException {
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=bon-commande-fournisseur-" + fournisseur.getId() + ".pdf");
        response.getOutputStream().write(genererBonCommandeBytes(fournisseur, produits));
    }

    public static byte[] genererBonCommandeBytes(Fournisseur fournisseur, List<Produit> produits) throws IOException {
        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
        try (Document document = new Document(new com.itextpdf.kernel.pdf.PdfDocument(new PdfWriter(outputStream)), PageSize.A4)) {
            document.add(new Paragraph("Bon de commande fournisseur")
                .setFontSize(22)
                .setBold()
                .setFontColor(ColorConstants.BLACK));

            document.add(new Paragraph("Fournisseur: " + fournisseur.getRaisonSociale()).setBold());
            document.add(new Paragraph("Telephone: " + valueOrDash(fournisseur.getTelephone())));
            document.add(new Paragraph("Email: " + valueOrDash(fournisseur.getEmail())));
            document.add(new Paragraph("Conditions de paiement: " + valueOrDash(fournisseur.getConditionsPaiement())));
            document.add(new Paragraph("Delai de livraison: " + fournisseur.getDelaiLivraisonJours() + " jours").setMarginBottom(16));

            Table table = new Table(new float[]{4f, 2f, 2f, 2f, 2f});
            table.useAllAvailableWidth();
            addHeader(table, "Produit");
            addHeader(table, "Stock");
            addHeader(table, "Stock min");
            addHeader(table, "Qte a commander");
            addHeader(table, "Prix achat");

            BigDecimal totalEstime = BigDecimal.ZERO;
            for (Produit produit : produits) {
                int qte = FormUtil.quantiteACommander(produit);
                BigDecimal ligneTotal = produit.getPrixAchat().multiply(BigDecimal.valueOf(qte));
                totalEstime = totalEstime.add(ligneTotal);

                table.addCell(cell(produit.getDesignation()));
                table.addCell(cell(String.valueOf(produit.getStockActuel())));
                table.addCell(cell(String.valueOf(produit.getStockMinimum())));
                table.addCell(cell(String.valueOf(qte)));
                table.addCell(cell(MoneyUtil.formatFcfa(produit.getPrixAchat())));
            }

            document.add(table);
            document.add(new Paragraph("Montant estime achat: " + MoneyUtil.formatFcfa(totalEstime))
                .setBold()
                .setTextAlignment(TextAlignment.RIGHT)
                .setMarginTop(18));
        }
        return outputStream.toByteArray();
    }

    public static void genererRapportAlertesStock(HttpServletResponse response, List<Produit> produits) throws IOException {
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=alertes-stock-selection.pdf");

        try (Document document = new Document(new com.itextpdf.kernel.pdf.PdfDocument(new PdfWriter(response.getOutputStream())), PageSize.A4)) {
            document.add(new Paragraph("Rapport des alertes stock").setFontSize(22).setBold());
            document.add(new Paragraph("Synthese des produits critiques selectionnes").setMarginBottom(16));

            Map<Long, List<Produit>> grouped = new LinkedHashMap<>();
            for (Produit produit : produits) {
                Long key = produit.getFournisseur() != null ? produit.getFournisseur().getId() : -1L;
                grouped.computeIfAbsent(key, ignored -> new java.util.ArrayList<>()).add(produit);
            }

            for (List<Produit> groupe : grouped.values()) {
                Produit first = groupe.get(0);
                String fournisseur = first.getFournisseur() != null ? first.getFournisseur().getRaisonSociale() : "Sans fournisseur";
                document.add(new Paragraph("Fournisseur: " + fournisseur).setBold().setMarginTop(12));

                Table table = new Table(new float[]{4f, 2f, 2f, 2f});
                table.useAllAvailableWidth();
                addHeader(table, "Produit");
                addHeader(table, "Categorie");
                addHeader(table, "Stock");
                addHeader(table, "Stock min");

                for (Produit produit : groupe) {
                    table.addCell(cell(produit.getDesignation()));
                    table.addCell(cell(produit.getCategorie()));
                    table.addCell(cell(String.valueOf(produit.getStockActuel())));
                    table.addCell(cell(String.valueOf(produit.getStockMinimum())));
                }
                document.add(table);
            }
        }
    }

    private static void addHeader(Table table, String text) {
        table.addCell(new Cell()
            .add(new Paragraph(text).setBold().setFontColor(ColorConstants.WHITE))
            .setBackgroundColor(ColorConstants.DARK_GRAY)
            .setBorder(new SolidBorder(ColorConstants.DARK_GRAY, 0.5f)));
    }

    private static Cell cell(String text) {
        return new Cell()
            .add(new Paragraph(text))
            .setBorder(new SolidBorder(ColorConstants.LIGHT_GRAY, 0.5f));
    }

    private static String valueOrDash(String value) {
        return value == null || value.isBlank() ? "-" : value;
    }
}
