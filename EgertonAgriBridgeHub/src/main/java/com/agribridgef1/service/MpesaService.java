package com.agribridgef1.service;

import com.agribridgef1.util.MpesaConfig;
import org.json.JSONObject;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.text.SimpleDateFormat;
import java.util.Base64;
import java.util.Date;

public class MpesaService {

    public String generateAccessToken() throws IOException {
        String credentials = MpesaConfig.CONSUMER_KEY + ":" + MpesaConfig.CONSUMER_SECRET;
        String encodedCredentials = Base64.getEncoder().encodeToString(credentials.getBytes());

        URL url = new URL(MpesaConfig.BASE_URL + "/oauth/v1/generate?grant_type=client_credentials");

        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        conn.setRequestProperty("Authorization", "Basic " + encodedCredentials);

        int responseCode = conn.getResponseCode();
        String response = readResponse(conn, responseCode);

        if (responseCode == 200) {
            JSONObject json = new JSONObject(response);
            return json.getString("access_token");
        }

        throw new IOException("Failed to generate M-Pesa access token: " + response);
    }

    public String stkPush(String phoneNumber, int amount, int orderId) throws IOException {
        String accessToken = generateAccessToken();

        String timestamp = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
        String passwordString = MpesaConfig.SHORTCODE + MpesaConfig.PASSKEY + timestamp;
        String password = Base64.getEncoder().encodeToString(passwordString.getBytes());

        URL url = new URL(MpesaConfig.BASE_URL + "/mpesa/stkpush/v1/processrequest");

        JSONObject payload = new JSONObject();
        payload.put("BusinessShortCode", MpesaConfig.SHORTCODE);
        payload.put("Password", password);
        payload.put("Timestamp", timestamp);
        payload.put("TransactionType", "CustomerPayBillOnline");
        payload.put("Amount", amount);
        payload.put("PartyA", phoneNumber);
        payload.put("PartyB", MpesaConfig.SHORTCODE);
        payload.put("PhoneNumber", phoneNumber);
        payload.put("CallBackURL", MpesaConfig.CALLBACK_URL);
        payload.put("AccountReference", MpesaConfig.ACCOUNT_REFERENCE + "-" + orderId);
        payload.put("TransactionDesc", MpesaConfig.TRANSACTION_DESC);

        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Authorization", "Bearer " + accessToken);
        conn.setRequestProperty("Content-Type", "application/json");
        conn.setDoOutput(true);

        try (OutputStream os = conn.getOutputStream()) {
            byte[] input = payload.toString().getBytes();
            os.write(input, 0, input.length);
        }

        int responseCode = conn.getResponseCode();
        String response = readResponse(conn, responseCode);

        if (responseCode == 200) {
            return response;
        }

        throw new IOException("STK Push failed: " + response);
    }

    private String readResponse(HttpURLConnection conn, int responseCode) throws IOException {
        InputStream stream;

        if (responseCode >= 200 && responseCode < 300) {
            stream = conn.getInputStream();
        } else {
            stream = conn.getErrorStream();
        }

        if (stream == null) {
            return "";
        }

        try (BufferedReader br = new BufferedReader(new InputStreamReader(stream))) {
            StringBuilder response = new StringBuilder();
            String line;

            while ((line = br.readLine()) != null) {
                response.append(line.trim());
            }

            return response.toString();
        }
    }
}