package com.agribridge.services;

import java.io.*;
import java.net.*;
import java.nio.charset.StandardCharsets;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Base64;

public class MpesaService {

    // Step 1: Get OAuth access token from Safaricom
    public String getOAuthToken() throws IOException {
        System.out.println("[OAuth] Requesting access token...");

        String credentials = MpesaConfig.CONSUMER_KEY + ":" + MpesaConfig.CONSUMER_SECRET;
        String encoded = Base64.getEncoder()
                               .encodeToString(credentials.getBytes(StandardCharsets.UTF_8));

        URL url = new URL(MpesaConfig.OAUTH_URL);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        conn.setRequestProperty("Authorization", "Basic " + encoded);
        conn.setRequestProperty("Content-Type", "application/json");
        conn.setConnectTimeout(30000);
        conn.setReadTimeout(30000);

        int responseCode = conn.getResponseCode();
        System.out.println("[OAuth] Response code: " + responseCode);

        if (responseCode == 200) {
            String response = readResponse(conn.getInputStream());
            System.out.println("[OAuth] Token body: " + response);
            return extractJsonValue(response, "access_token");
        } else {
            String errorBody = readResponse(conn.getErrorStream());
            System.err.println("[OAuth] FAILED (HTTP " + responseCode + "): " + errorBody);
            System.err.println("[OAuth] KEY used: " + MpesaConfig.CONSUMER_KEY);
            return null;
        }
    }

    // Step 2: Initiate STK Push (Lipa Na M-Pesa Online)
    public String initiateStkPush(String phone, int amount, int orderId) throws IOException {
        System.out.println("[STK] Initiating STK Push — Phone: " + phone + ", Amount: " + amount + ", OrderId: " + orderId);

        String token = getOAuthToken();
        if (token == null) {
            System.out.println("[STK] Stopped — could not get OAuth token.");
            return null;
        }

        String timestamp = LocalDateTime.now()
                .format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"));

        String rawPassword = MpesaConfig.SHORTCODE + MpesaConfig.PASSKEY + timestamp;
        String password = Base64.getEncoder()
                                .encodeToString(rawPassword.getBytes(StandardCharsets.UTF_8));

        phone = normalizePhone(phone);

        String jsonBody = "{"
            + "\"BusinessShortCode\": \"" + MpesaConfig.SHORTCODE         + "\","
            + "\"Password\": \""           + password                      + "\","
            + "\"Timestamp\": \""          + timestamp                     + "\","
            + "\"TransactionType\": \""    + MpesaConfig.TRANSACTION_TYPE  + "\","
            + "\"Amount\": "               + amount                        + ","
            + "\"PartyA\": \""             + phone                         + "\","
            + "\"PartyB\": \""             + MpesaConfig.SHORTCODE         + "\","
            + "\"PhoneNumber\": \""        + phone                         + "\","
            + "\"CallBackURL\": \""        + MpesaConfig.CALLBACK_URL      + "\","
            + "\"AccountReference\": \""   + MpesaConfig.ACCOUNT_REFERENCE
                                           + "-" + orderId                 + "\","
            + "\"TransactionDesc\": \""    + MpesaConfig.TRANSACTION_DESC  + "\""
            + "}";

        URL url = new URL(MpesaConfig.STK_PUSH_URL);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Authorization", "Bearer " + token);
        conn.setRequestProperty("Content-Type", "application/json");
        conn.setDoOutput(true);
        conn.setConnectTimeout(30000);
        conn.setReadTimeout(30000);

        try (OutputStream os = conn.getOutputStream()) {
            os.write(jsonBody.getBytes(StandardCharsets.UTF_8));
        }

        int responseCode = conn.getResponseCode();
        String response = responseCode == 200
                ? readResponse(conn.getInputStream())
                : readResponse(conn.getErrorStream());

        System.out.println("[STK] Response code: " + responseCode);
        System.out.println("[STK] Response body: " + response);

        if (responseCode == 200) {
            String checkoutId = extractJsonValue(response, "CheckoutRequestID");
            System.out.println("[STK] STK Push sent. CheckoutRequestID: " + checkoutId);
            return checkoutId;
        } else {
            System.err.println("[STK] FAILED (HTTP " + responseCode + "): " + response);
            return null;
        }
    }

    private String readResponse(InputStream stream) throws IOException {
        if (stream == null) return "";
        BufferedReader reader = new BufferedReader(
                new InputStreamReader(stream, StandardCharsets.UTF_8));
        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = reader.readLine()) != null) sb.append(line);
        return sb.toString();
    }

    // Parses a string or numeric value from a JSON string
    private String extractJsonValue(String json, String key) {
        String search = "\"" + key + "\":\"";
        int start = json.indexOf(search);
        if (start == -1) {
            search = "\"" + key + "\": \"";
            start = json.indexOf(search);
        }
        if (start == -1) return null;
        start += search.length();
        int end = json.indexOf("\"", start);
        return end == -1 ? null : json.substring(start, end);
    }

    // Converts phone to international format: 0712... → 254712...
    public String normalizePhone(String phone) {
        if (phone == null) return "";
        phone = phone.trim().replaceAll("\\s+", "");
        if (phone.startsWith("+")) phone = phone.substring(1);
        if (phone.startsWith("0")) phone = "254" + phone.substring(1);
        return phone;
    }
}