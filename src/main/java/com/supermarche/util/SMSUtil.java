package com.supermarche.util;

import com.twilio.Twilio;
import com.twilio.exception.ApiException;
import com.twilio.rest.api.v2010.account.Message;
import com.twilio.type.PhoneNumber;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public final class SMSUtil {

    private static final Logger LOGGER = LoggerFactory.getLogger(SMSUtil.class);
    private static volatile boolean initialized;

    private SMSUtil() {
    }

    public static void envoyerSMS(String numero, String message) {
        if (!AppConfig.getBoolean("sms.enabled", "SMS_ENABLED", false)) {
            LOGGER.info("SMS desactive. Message non envoye vers {} : {}", numero, message);
            return;
        }

        initializeTwilioIfNeeded();
        String from = AppConfig.required(
            AppConfig.getApp("twilio.from.number", "TWILIO_FROM_NUMBER", null),
            "TWILIO_FROM_NUMBER / twilio.from.number"
        );
        String to = AppConfig.normalizePhone(numero);
        if (to.isBlank()) {
            throw new IllegalArgumentException("Numero destinataire SMS manquant.");
        }

        try {
            Message sms = Message.creator(new PhoneNumber(to), new PhoneNumber(from), message).create();
            LOGGER.info("SMS envoye vers {} avec SID {}", to, sms.getSid());
        } catch (ApiException e) {
            throw new IllegalStateException("Echec d'envoi SMS via Twilio : " + e.getMessage(), e);
        }
    }

    private static void initializeTwilioIfNeeded() {
        if (initialized) {
            return;
        }
        synchronized (SMSUtil.class) {
            if (initialized) {
                return;
            }
            String accountSid = AppConfig.required(
                AppConfig.getApp("twilio.account.sid", "TWILIO_ACCOUNT_SID", null),
                "TWILIO_ACCOUNT_SID / twilio.account.sid"
            );
            String authToken = AppConfig.required(
                AppConfig.getApp("twilio.auth.token", "TWILIO_AUTH_TOKEN", null),
                "TWILIO_AUTH_TOKEN / twilio.auth.token"
            );
            Twilio.init(accountSid, authToken);
            initialized = true;
        }
    }
}
