package com.supermarche.util;

import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.Multipart;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeBodyPart;
import jakarta.mail.internet.MimeMessage;
import jakarta.mail.internet.MimeMultipart;
import jakarta.mail.util.ByteArrayDataSource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Properties;

public final class EmailUtil {

    private static final Logger LOGGER = LoggerFactory.getLogger(EmailUtil.class);
    private static final DateTimeFormatter DATE_TIME_FORMAT = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");

    private EmailUtil() {
    }

    public static void envoyerEmailAvecPieceJointe(String to, String subject, String body,
                                                   byte[] attachment, String attachmentName, String contentType) {
        if (!AppConfig.getBoolean("mail.enabled", "MAIL_ENABLED", false)) {
            LOGGER.info("Email desactive. Message non envoye vers {} avec sujet {}", to, subject);
            return;
        }

        if (to == null || to.isBlank()) {
            throw new IllegalArgumentException("Adresse email fournisseur manquante.");
        }

        String username = AppConfig.required(
            AppConfig.getApp("mail.smtp.username", "MAIL_SMTP_USERNAME", null),
            "MAIL_SMTP_USERNAME / mail.smtp.username"
        );
        String password = AppConfig.required(
            AppConfig.getApp("mail.smtp.password", "MAIL_SMTP_PASSWORD", null),
            "MAIL_SMTP_PASSWORD / mail.smtp.password"
        );
        String from = AppConfig.required(
            AppConfig.getApp("mail.smtp.from", "MAIL_SMTP_FROM", username),
            "MAIL_SMTP_FROM / mail.smtp.from"
        );

        try {
            Session session = Session.getInstance(buildProperties(), new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(username, password);
                }
            });

            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(from));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
            message.setSubject(subject, "UTF-8");

            Multipart multipart = new MimeMultipart("mixed");

            MimeBodyPart contentPart = new MimeBodyPart();
            MimeMultipart alternative = new MimeMultipart("alternative");

            MimeBodyPart textPart = new MimeBodyPart();
            textPart.setText(buildTextBody(body, attachmentName), "UTF-8");
            alternative.addBodyPart(textPart);

            MimeBodyPart htmlPart = new MimeBodyPart();
            htmlPart.setContent(buildHtmlBody(subject, body, attachmentName), "text/html; charset=UTF-8");
            alternative.addBodyPart(htmlPart);

            contentPart.setContent(alternative);
            multipart.addBodyPart(contentPart);

            if (attachment != null && attachment.length > 0) {
                MimeBodyPart attachmentPart = new MimeBodyPart();
                attachmentPart.setDataHandler(new jakarta.activation.DataHandler(
                    new ByteArrayDataSource(attachment, contentType)
                ));
                attachmentPart.setFileName(attachmentName);
                multipart.addBodyPart(attachmentPart);
            }

            message.setContent(multipart);
            Transport.send(message);
            LOGGER.info("Email envoye vers {} avec sujet {}", to, subject);
        } catch (MessagingException e) {
            throw new IllegalStateException("Echec d'envoi email SMTP : " + e.getMessage(), e);
        }
    }

    private static Properties buildProperties() {
        Properties properties = new Properties();
        properties.put("mail.smtp.host", AppConfig.required(
            AppConfig.getApp("mail.smtp.host", "MAIL_SMTP_HOST", null),
            "MAIL_SMTP_HOST / mail.smtp.host"
        ));
        properties.put("mail.smtp.port", AppConfig.getApp("mail.smtp.port", "MAIL_SMTP_PORT", "587"));
        properties.put("mail.smtp.auth", AppConfig.getApp("mail.smtp.auth", "MAIL_SMTP_AUTH", "true"));
        properties.put("mail.smtp.starttls.enable", AppConfig.getApp("mail.smtp.starttls.enable", "MAIL_SMTP_STARTTLS_ENABLE", "true"));
        return properties;
    }

    private static String buildTextBody(String body, String attachmentName) {
        StringBuilder text = new StringBuilder();
        text.append(body == null ? "" : body.trim());
        if (attachmentName != null && !attachmentName.isBlank()) {
            text.append("\n\nPiece jointe: ").append(attachmentName);
        }
        text.append("\n\nGestion Supermarche - MarketPro UI");
        return text.toString();
    }

    private static String buildHtmlBody(String subject, String body, String attachmentName) {
        String content = looksLikeHtml(body) ? body : plainTextToHtml(body);
        String attachmentBlock = attachmentName == null || attachmentName.isBlank() ? "" : ""
            + "<tr><td style=\"padding:0 28px 24px;\">"
            + "<table role=\"presentation\" width=\"100%\" style=\"border-collapse:collapse;border:1px solid #d7e4ff;background:#f4f8ff;border-radius:14px;\">"
            + "<tr>"
            + "<td width=\"54\" style=\"padding:16px 0 16px 18px;vertical-align:top;\">" + svgAttachment() + "</td>"
            + "<td style=\"padding:16px 18px 16px 10px;vertical-align:top;\">"
            + "<div style=\"font-size:12px;font-weight:800;color:#2448d8;text-transform:uppercase;letter-spacing:.04em;\">Piece jointe</div>"
            + "<div style=\"margin-top:4px;font-size:15px;font-weight:800;color:#171d2d;\">" + escapeHtml(attachmentName) + "</div>"
            + "<div style=\"margin-top:4px;font-size:12px;color:#5d697e;\">Document PDF genere avec le theme MarketPro UI.</div>"
            + "</td></tr></table></td></tr>";

        return "<!doctype html>"
            + "<html lang=\"fr\"><head><meta charset=\"UTF-8\"><meta name=\"viewport\" content=\"width=device-width,initial-scale=1\">"
            + "<title>" + escapeHtml(subject) + "</title></head>"
            + "<body style=\"margin:0;padding:0;background:#eff5ff;font-family:Manrope,Arial,sans-serif;color:#171d2d;\">"
            + "<table role=\"presentation\" width=\"100%\" style=\"border-collapse:collapse;background:#eff5ff;padding:24px 0;\">"
            + "<tr><td align=\"center\" style=\"padding:24px 12px;\">"
            + "<table role=\"presentation\" width=\"640\" style=\"width:640px;max-width:100%;border-collapse:collapse;background:#fbfdff;border:1px solid #d7e4ff;border-radius:20px;overflow:hidden;box-shadow:0 14px 42px rgba(30,64,208,.08);\">"
            + "<tr><td style=\"padding:0;background:#1f3fb7;\">"
            + "<table role=\"presentation\" width=\"100%\" style=\"border-collapse:collapse;\"><tr>"
            + "<td width=\"86\" style=\"padding:22px;background:#163397;text-align:center;\">" + svgBrand() + "</td>"
            + "<td style=\"padding:22px 22px 20px;\">"
            + "<div style=\"font-size:12px;font-weight:800;color:#f5a000;text-transform:uppercase;letter-spacing:.05em;\">Gestion Supermarche</div>"
            + "<h1 style=\"margin:6px 0 0;font-size:24px;line-height:1.25;color:#ffffff;font-weight:900;\">" + escapeHtml(subject) + "</h1>"
            + "<div style=\"margin-top:8px;font-size:13px;color:#d7e6ff;\">Notification operationnelle - " + DATE_TIME_FORMAT.format(LocalDateTime.now()) + "</div>"
            + "</td></tr></table>"
            + "</td></tr>"
            + "<tr><td style=\"padding:26px 28px 18px;\">"
            + "<table role=\"presentation\" width=\"100%\" style=\"border-collapse:collapse;\"><tr>"
            + "<td width=\"46\" style=\"vertical-align:top;\">" + svgCheck() + "</td>"
            + "<td style=\"vertical-align:top;padding-left:12px;\">"
            + "<div style=\"font-size:13px;font-weight:800;color:#2448d8;text-transform:uppercase;letter-spacing:.04em;\">Message fournisseur</div>"
            + "<div style=\"margin-top:10px;font-size:15px;line-height:1.7;color:#262d42;\">" + content + "</div>"
            + "</td></tr></table>"
            + "</td></tr>"
            + attachmentBlock
            + "<tr><td style=\"padding:0 28px 28px;\">"
            + "<table role=\"presentation\" width=\"100%\" style=\"border-collapse:collapse;background:#ffffff;border-top:3px solid #f5a000;border-radius:14px;\">"
            + "<tr><td style=\"padding:16px 18px;font-size:13px;line-height:1.6;color:#5d697e;\">"
            + "Merci de traiter cette demande et de confirmer la disponibilite, le delai et les conditions de livraison."
            + "</td></tr></table>"
            + "</td></tr>"
            + "<tr><td style=\"padding:18px 28px;background:#f4f8ff;border-top:1px solid #d7e4ff;font-size:12px;color:#5d697e;text-align:center;\">"
            + "MarketPro UI - bleu pine, blanc shell, accent gold"
            + "</td></tr>"
            + "</table></td></tr></table></body></html>";
    }

    private static boolean looksLikeHtml(String body) {
        if (body == null) {
            return false;
        }
        String trimmed = body.trim().toLowerCase();
        return trimmed.contains("<html") || trimmed.contains("<p") || trimmed.contains("<table") || trimmed.contains("<div");
    }

    private static String plainTextToHtml(String body) {
        if (body == null || body.isBlank()) {
            return "";
        }
        String[] paragraphs = body.trim().split("\\R\\s*\\R");
        StringBuilder html = new StringBuilder();
        for (String paragraph : paragraphs) {
            String escaped = escapeHtml(paragraph).replaceAll("\\R", "<br>");
            html.append("<p style=\"margin:0 0 12px;\">").append(escaped).append("</p>");
        }
        return html.toString();
    }

    private static String escapeHtml(String value) {
        if (value == null) {
            return "";
        }
        return value
            .replace("&", "&amp;")
            .replace("<", "&lt;")
            .replace(">", "&gt;")
            .replace("\"", "&quot;")
            .replace("'", "&#39;");
    }

    private static String svgBrand() {
        return "<svg width=\"44\" height=\"44\" viewBox=\"0 0 44 44\" xmlns=\"http://www.w3.org/2000/svg\" role=\"img\" aria-label=\"MarketPro\">"
            + "<rect width=\"44\" height=\"44\" rx=\"14\" fill=\"#d7e6ff\"/>"
            + "<path d=\"M12 16h20l-2 13H15l-3-13Z\" fill=\"none\" stroke=\"#1f3fb7\" stroke-width=\"2.4\" stroke-linejoin=\"round\"/>"
            + "<path d=\"M16 16c1-5 11-5 12 0\" fill=\"none\" stroke=\"#f5a000\" stroke-width=\"2.4\" stroke-linecap=\"round\"/>"
            + "<circle cx=\"17\" cy=\"33\" r=\"2\" fill=\"#1f3fb7\"/><circle cx=\"29\" cy=\"33\" r=\"2\" fill=\"#1f3fb7\"/>"
            + "</svg>";
    }

    private static String svgCheck() {
        return "<svg width=\"42\" height=\"42\" viewBox=\"0 0 42 42\" xmlns=\"http://www.w3.org/2000/svg\" aria-hidden=\"true\">"
            + "<rect width=\"42\" height=\"42\" rx=\"14\" fill=\"#d7e6ff\"/>"
            + "<path d=\"m12 22 6 6 13-15\" fill=\"none\" stroke=\"#1f3fb7\" stroke-width=\"3\" stroke-linecap=\"round\" stroke-linejoin=\"round\"/>"
            + "</svg>";
    }

    private static String svgAttachment() {
        return "<svg width=\"38\" height=\"38\" viewBox=\"0 0 38 38\" xmlns=\"http://www.w3.org/2000/svg\" aria-hidden=\"true\">"
            + "<rect width=\"38\" height=\"38\" rx=\"12\" fill=\"#ffffff\"/>"
            + "<path d=\"M13 8h9l5 5v17H13V8Z\" fill=\"none\" stroke=\"#1f3fb7\" stroke-width=\"2\" stroke-linejoin=\"round\"/>"
            + "<path d=\"M22 8v6h6\" fill=\"none\" stroke=\"#f5a000\" stroke-width=\"2\" stroke-linejoin=\"round\"/>"
            + "<path d=\"M16 20h9M16 25h6\" stroke=\"#2448d8\" stroke-width=\"2\" stroke-linecap=\"round\"/>"
            + "</svg>";
    }
}
