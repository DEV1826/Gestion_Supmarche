package com.supermarche.util;

import com.itextpdf.kernel.colors.Color;
import com.itextpdf.kernel.colors.DeviceRgb;
import com.itextpdf.kernel.geom.PageSize;
import com.itextpdf.kernel.pdf.PdfWriter;
import com.itextpdf.layout.Document;
import com.itextpdf.layout.borders.Border;
import com.itextpdf.layout.borders.SolidBorder;
import com.itextpdf.layout.element.Cell;
import com.itextpdf.layout.element.Div;
import com.itextpdf.layout.element.LineSeparator;
import com.itextpdf.layout.element.Paragraph;
import com.itextpdf.layout.element.Table;
import com.itextpdf.layout.properties.TextAlignment;
import com.itextpdf.layout.properties.UnitValue;
import com.supermarche.entity.Fournisseur;
import com.supermarche.entity.LigneVente;
import com.supermarche.entity.Produit;
import com.supermarche.entity.Vente;
import jakarta.servlet.http.HttpServletResponse;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public final class PDFUtil {

    private static final Color PINE = new DeviceRgb(31, 63, 183);
    private static final Color MOSS = new DeviceRgb(36, 72, 216);
    private static final Color GOLD = new DeviceRgb(245, 160, 0);
    private static final Color EMBER = new DeviceRgb(255, 77, 79);
    private static final Color INK = new DeviceRgb(23, 29, 45);
    private static final Color SLATE = new DeviceRgb(93, 105, 126);
    private static final Color LINE = new DeviceRgb(215, 228, 255);
    private static final Color MINT = new DeviceRgb(215, 230, 255);
    private static final Color SHELL = new DeviceRgb(251, 253, 255);
    private static final Color SOFT = new DeviceRgb(244, 248, 255);
    private static final Color WHITE = new DeviceRgb(255, 255, 255);
    private static final DateTimeFormatter DATE_TIME_FORMAT = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
    private static final DateTimeFormatter DATE_FORMAT = DateTimeFormatter.ofPattern("dd/MM/yyyy");

    private PDFUtil() {
    }

    public static void genererTicket(HttpServletResponse response, Vente vente) throws IOException {
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=facture-" + vente.getNumeroTicket() + ".pdf");

        try (Document document = createDocument(response.getOutputStream())) {
            addHero(document, "Facture / Ticket de caisse", "Vente encaissee", "Ticket " + valueOrDash(vente.getNumeroTicket()));

            Table meta = infoGrid(new String[][]{
                {"Numero", valueOrDash(vente.getNumeroTicket())},
                {"Date", formatDateTime(vente.getDateHeure())},
                {"Mode paiement", valueOrDash(vente.getModePaiement())},
                {"Articles", String.valueOf(vente.getLignes().size())}
            });
            document.add(meta);

            document.add(sectionTitle("Details des articles"));
            Table table = documentTable(new float[]{4.2f, 1.3f, 1.8f, 2f});
            addHeader(table, "Produit");
            addHeader(table, "Qte");
            addHeader(table, "Prix unitaire");
            addHeader(table, "Sous-total");

            int index = 0;
            for (LigneVente ligne : vente.getLignes()) {
                boolean shaded = index++ % 2 == 1;
                String designation = ligne.getProduit() != null ? ligne.getProduit().getDesignation() : String.valueOf(ligne.getProduitId());
                table.addCell(dataCell(designation, shaded, TextAlignment.LEFT, true));
                table.addCell(dataCell(String.valueOf(ligne.getQuantite()), shaded, TextAlignment.CENTER, false));
                table.addCell(dataCell(MoneyUtil.formatFcfa(nullToZero(ligne.getPrixUnitaire())), shaded, TextAlignment.RIGHT, false));
                table.addCell(dataCell(MoneyUtil.formatFcfa(nullToZero(ligne.getSousTotal())), shaded, TextAlignment.RIGHT, true));
            }

            document.add(table);
            addTotalBlock(document, "Total TTC", nullToZero(vente.getTotalTtc()), "Paiement confirme - merci pour votre achat.");
            addFooter(document, "Document genere automatiquement par Gestion Supermarche.");
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
        try (Document document = createDocument(outputStream)) {
            addHero(document, "Bon de commande fournisseur", "Reapprovisionnement", "BC-" + valueOrDash(fournisseur.getId()));

            BigDecimal totalEstime = totalCommande(produits);
            Table meta = infoGrid(new String[][]{
                {"Fournisseur", valueOrDash(fournisseur.getRaisonSociale())},
                {"Telephone", valueOrDash(fournisseur.getTelephone())},
                {"Email", valueOrDash(fournisseur.getEmail())},
                {"Paiement", valueOrDash(fournisseur.getConditionsPaiement())},
                {"Delai livraison", fournisseur.getDelaiLivraisonJours() + " jours"},
                {"Montant estime", MoneyUtil.formatFcfa(totalEstime)}
            });
            document.add(meta);

            document.add(sectionTitle("Articles a commander"));
            Table table = documentTable(new float[]{3.4f, 1.2f, 1.2f, 1.6f, 1.8f, 1.8f});
            addHeader(table, "Produit");
            addHeader(table, "Stock");
            addHeader(table, "Min.");
            addHeader(table, "Qte");
            addHeader(table, "Prix achat");
            addHeader(table, "Total ligne");

            int index = 0;
            for (Produit produit : produits) {
                int qte = FormUtil.quantiteACommander(produit);
                BigDecimal prixAchat = nullToZero(produit.getPrixAchat());
                BigDecimal ligneTotal = prixAchat.multiply(BigDecimal.valueOf(qte));
                boolean shaded = index++ % 2 == 1;

                table.addCell(dataCell(valueOrDash(produit.getDesignation()), shaded, TextAlignment.LEFT, true));
                table.addCell(dataCell(String.valueOf(produit.getStockActuel()), shaded, TextAlignment.CENTER, false));
                table.addCell(dataCell(String.valueOf(produit.getStockMinimum()), shaded, TextAlignment.CENTER, false));
                table.addCell(dataCell(String.valueOf(qte), shaded, TextAlignment.CENTER, true));
                table.addCell(dataCell(MoneyUtil.formatFcfa(prixAchat), shaded, TextAlignment.RIGHT, false));
                table.addCell(dataCell(MoneyUtil.formatFcfa(ligneTotal), shaded, TextAlignment.RIGHT, true));
            }

            document.add(table);
            addTotalBlock(document, "Montant estime achat", totalEstime, "Commande preparee selon les niveaux de stock critiques.");
            addFooter(document, "Merci de confirmer disponibilite, delai et conditions avant expedition.");
        }
        return outputStream.toByteArray();
    }

    public static void genererRapportAlertesStock(HttpServletResponse response, List<Produit> produits) throws IOException {
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=alertes-stock-selection.pdf");

        try (Document document = createDocument(response.getOutputStream())) {
            addHero(document, "Rapport des alertes stock", "Synthese operationnelle", produits.size() + " produit(s)");

            int ruptures = 0;
            int critiques = 0;
            for (Produit produit : produits) {
                if (produit.getStockActuel() <= 0) {
                    ruptures++;
                } else if (produit.getStockActuel() <= produit.getStockMinimum()) {
                    critiques++;
                }
            }

            Table meta = infoGrid(new String[][]{
                {"Selection", produits.size() + " produit(s)"},
                {"Ruptures", String.valueOf(ruptures)},
                {"Critiques", String.valueOf(critiques)},
                {"Date rapport", DATE_FORMAT.format(LocalDateTime.now())}
            });
            document.add(meta);

            Map<Long, List<Produit>> grouped = new LinkedHashMap<>();
            for (Produit produit : produits) {
                Long key = produit.getFournisseur() != null ? produit.getFournisseur().getId() : -1L;
                grouped.computeIfAbsent(key, ignored -> new java.util.ArrayList<>()).add(produit);
            }

            for (List<Produit> groupe : grouped.values()) {
                Produit first = groupe.get(0);
                String fournisseur = first.getFournisseur() != null ? first.getFournisseur().getRaisonSociale() : "Sans fournisseur";
                document.add(sectionTitle("Fournisseur - " + fournisseur));

                Table table = documentTable(new float[]{3.5f, 2f, 1.2f, 1.2f, 1.8f});
                addHeader(table, "Produit");
                addHeader(table, "Categorie");
                addHeader(table, "Stock");
                addHeader(table, "Min.");
                addHeader(table, "Statut");

                int index = 0;
                for (Produit produit : groupe) {
                    boolean shaded = index++ % 2 == 1;
                    table.addCell(dataCell(valueOrDash(produit.getDesignation()), shaded, TextAlignment.LEFT, true));
                    table.addCell(dataCell(valueOrDash(produit.getCategorie()), shaded, TextAlignment.LEFT, false));
                    table.addCell(dataCell(String.valueOf(produit.getStockActuel()), shaded, TextAlignment.CENTER, true));
                    table.addCell(dataCell(String.valueOf(produit.getStockMinimum()), shaded, TextAlignment.CENTER, false));
                    table.addCell(statusCell(stockStatus(produit), produit.getStockActuel() <= 0, shaded));
                }
                document.add(table);
            }
            addFooter(document, "Priorisez les ruptures, puis les references sous stock minimum.");
        }
    }

    private static Document createDocument(java.io.OutputStream outputStream) {
        Document document = new Document(new com.itextpdf.kernel.pdf.PdfDocument(new PdfWriter(outputStream)), PageSize.A4);
        document.setMargins(30, 30, 30, 30);
        return document;
    }

    private static void addHero(Document document, String title, String badge, String reference) {
        Table hero = new Table(UnitValue.createPercentArray(new float[]{1.2f, 4.8f, 2.1f}));
        hero.useAllAvailableWidth();
        hero.setMarginBottom(14);

        Cell mark = new Cell()
            .setBorder(Border.NO_BORDER)
            .setBackgroundColor(PINE)
            .setPadding(13)
            .add(new Paragraph("MP")
                .setBold()
                .setFontSize(18)
                .setFontColor(WHITE)
                .setTextAlignment(TextAlignment.CENTER))
            .add(new Paragraph("UI")
                .setFontSize(8)
                .setFontColor(MINT)
                .setTextAlignment(TextAlignment.CENTER));
        hero.addCell(mark);

        Cell identity = new Cell()
            .setBorder(Border.NO_BORDER)
            .setBackgroundColor(SHELL)
            .setPaddingLeft(14)
            .setPaddingRight(14)
            .setPaddingTop(10)
            .setPaddingBottom(10)
            .add(new Paragraph("Gestion Supermarche")
                .setBold()
                .setFontSize(10)
                .setFontColor(GOLD)
                .setMarginBottom(3))
            .add(new Paragraph(title)
                .setBold()
                .setFontSize(21)
                .setFontColor(PINE)
                .setMargin(0))
            .add(new Paragraph("Document professionnel genere depuis le terminal d'administration.")
                .setFontSize(8.5f)
                .setFontColor(SLATE)
                .setMarginTop(4));
        hero.addCell(identity);

        Cell right = new Cell()
            .setBorder(Border.NO_BORDER)
            .setBackgroundColor(PINE)
            .setPadding(12)
            .add(new Paragraph(badge)
                .setBold()
                .setFontSize(9)
                .setFontColor(MINT)
                .setTextAlignment(TextAlignment.RIGHT)
                .setMarginBottom(8))
            .add(new Paragraph(reference)
                .setBold()
                .setFontSize(12)
                .setFontColor(WHITE)
                .setTextAlignment(TextAlignment.RIGHT))
            .add(new Paragraph(DATE_TIME_FORMAT.format(LocalDateTime.now()))
                .setFontSize(8)
                .setFontColor(MINT)
                .setTextAlignment(TextAlignment.RIGHT));
        hero.addCell(right);

        document.add(hero);
    }

    private static Table infoGrid(String[][] rows) {
        Table table = new Table(UnitValue.createPercentArray(new float[]{1f, 1f, 1f}));
        table.useAllAvailableWidth();
        table.setMarginBottom(12);
        for (String[] row : rows) {
            Cell cell = new Cell()
                .setBorder(new SolidBorder(LINE, 0.7f))
                .setBackgroundColor(SOFT)
                .setPadding(10)
                .add(new Paragraph(row[0].toUpperCase())
                    .setBold()
                    .setFontSize(7.5f)
                    .setFontColor(MOSS)
                    .setMarginBottom(4))
                .add(new Paragraph(row[1])
                    .setBold()
                    .setFontSize(10.5f)
                    .setFontColor(INK)
                    .setMargin(0));
            table.addCell(cell);
        }
        return table;
    }

    private static Paragraph sectionTitle(String text) {
        return new Paragraph(text)
            .setBold()
            .setFontSize(13)
            .setFontColor(PINE)
            .setMarginTop(10)
            .setMarginBottom(7);
    }

    private static Table documentTable(float[] widths) {
        Table table = new Table(UnitValue.createPercentArray(widths));
        table.useAllAvailableWidth();
        table.setBorder(new SolidBorder(LINE, 0.7f));
        table.setMarginBottom(12);
        return table;
    }

    private static void addHeader(Table table, String text) {
        table.addCell(new Cell()
            .add(new Paragraph(text).setBold().setFontSize(8.5f).setFontColor(WHITE))
            .setBackgroundColor(PINE)
            .setPadding(8)
            .setBorder(new SolidBorder(PINE, 0.5f))
            .setTextAlignment(TextAlignment.CENTER));
    }

    private static Cell dataCell(String text, boolean shaded, TextAlignment alignment, boolean bold) {
        Paragraph paragraph = new Paragraph(valueOrDash(text))
            .setFontSize(8.7f)
            .setFontColor(INK)
            .setMargin(0);
        if (bold) {
            paragraph.setBold();
        }
        return new Cell()
            .add(paragraph)
            .setTextAlignment(alignment)
            .setBackgroundColor(shaded ? SHELL : WHITE)
            .setBorder(new SolidBorder(LINE, 0.5f))
            .setPadding(7);
    }

    private static Cell statusCell(String text, boolean danger, boolean shaded) {
        Color color = danger ? EMBER : GOLD;
        return new Cell()
            .add(new Paragraph(text)
                .setBold()
                .setFontSize(8)
                .setFontColor(color)
                .setTextAlignment(TextAlignment.CENTER)
                .setMargin(0))
            .setBackgroundColor(shaded ? SHELL : WHITE)
            .setBorder(new SolidBorder(LINE, 0.5f))
            .setPadding(7);
    }

    private static void addTotalBlock(Document document, String label, BigDecimal amount, String note) {
        Table total = new Table(UnitValue.createPercentArray(new float[]{4.5f, 2.4f}));
        total.useAllAvailableWidth();
        total.setMarginTop(4);
        total.setMarginBottom(12);
        total.addCell(new Cell()
            .setBorder(Border.NO_BORDER)
            .setPadding(12)
            .setBackgroundColor(SHELL)
            .add(new Paragraph(note).setFontSize(9).setFontColor(SLATE).setMargin(0)));
        total.addCell(new Cell()
            .setBorder(Border.NO_BORDER)
            .setPadding(12)
            .setBackgroundColor(PINE)
            .add(new Paragraph(label).setFontSize(8.5f).setBold().setFontColor(MINT).setTextAlignment(TextAlignment.RIGHT).setMarginBottom(3))
            .add(new Paragraph(MoneyUtil.formatFcfa(amount)).setFontSize(16).setBold().setFontColor(WHITE).setTextAlignment(TextAlignment.RIGHT).setMargin(0)));
        document.add(total);
    }

   private static void addFooter(Document document, String note) {
    Div footer = new Div().setMarginTop(12);
    // Ligne horizontale via une bordure sur un paragraphe vide
    Paragraph separator = new Paragraph()
        .setBorderBottom(new SolidBorder(LINE, 1))
        .setMarginBottom(0)
        .setMarginTop(0);
    footer.add(separator);
    footer.add(new Paragraph(note)
        .setFontSize(8)
        .setFontColor(SLATE)
        .setTextAlignment(TextAlignment.CENTER)
        .setMarginTop(8));
    document.add(footer);
}

    private static BigDecimal totalCommande(List<Produit> produits) {
        BigDecimal totalEstime = BigDecimal.ZERO;
        for (Produit produit : produits) {
            int qte = FormUtil.quantiteACommander(produit);
            totalEstime = totalEstime.add(nullToZero(produit.getPrixAchat()).multiply(BigDecimal.valueOf(qte)));
        }
        return totalEstime;
    }

    private static BigDecimal nullToZero(BigDecimal value) {
        return value == null ? BigDecimal.ZERO : value;
    }

    private static String stockStatus(Produit produit) {
        if (produit.getStockActuel() <= 0) {
            return "RUPTURE";
        }
        if (produit.getStockActuel() <= produit.getStockMinimum()) {
            return "CRITIQUE";
        }
        return "A SURVEILLER";
    }

    private static String formatDateTime(LocalDateTime value) {
        return value == null ? "-" : DATE_TIME_FORMAT.format(value);
    }

    private static String valueOrDash(Object value) {
        if (value == null) {
            return "-";
        }
        String text = String.valueOf(value);
        return text.isBlank() ? "-" : text;
    }
}
