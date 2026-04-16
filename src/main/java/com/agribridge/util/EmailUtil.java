package com.agribridge.util;

import jakarta.mail.*;
import jakarta.mail.internet.*;
import java.util.Properties;

public class EmailUtil {
    // Configure these with your email server (e.g., Gmail SMTP)
    private static final String FROM_EMAIL = "your-email@gmail.com";
    private static final String FROM_PASSWORD = "your-app-password";
    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final String SMTP_PORT = "587";

    public static void sendResetEmail(String toEmail, String resetLink) throws MessagingException {
        Properties props = new Properties();
        props.put("mail.smtp.host", SMTP_HOST);
        props.put("mail.smtp.port", SMTP_PORT);
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(FROM_EMAIL, FROM_PASSWORD);
            }
        });

        Message message = new MimeMessage(session);
        message.setFrom(new InternetAddress(FROM_EMAIL));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
        message.setSubject("Password Reset Request - EgertonAgriBridgeHub");
        message.setContent(
            "<h2>Password Reset</h2>" +
            "<p>Click the link below to reset your password. It expires in 1 hour.</p>" +
            "<a href='" + resetLink + "'>Reset Password</a>",
            "text/html"
        );
        Transport.send(message);
    }
}