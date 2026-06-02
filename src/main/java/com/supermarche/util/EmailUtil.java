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

import java.util.Properties;

public final class EmailUtil {

    private static final Logger LOGGER = LoggerFactory.getLogger(EmailUtil.class);

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

            Multipart multipart = new MimeMultipart();

            MimeBodyPart bodyPart = new MimeBodyPart();
            bodyPart.setText(body, "UTF-8");
            multipart.addBodyPart(bodyPart);

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
}
