package com.agribridge.controller;

import com.agribridge.dao.PaymentDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.*;
import java.util.concurrent.ConcurrentHashMap;
import java.util.stream.Collectors;

// Handles the Safaricom M-Pesa callback after an STK Push is initiated
@WebServlet("/mpesa/callback")
public class MpesaCallbackServlet extends HttpServlet {

    // Stores payment results keyed by CheckoutRequestID
    // Value format: "Completed:RECEIPT_NUMBER" or "Failed"
    public static final ConcurrentHashMap<String, String> paymentResults = new ConcurrentHashMap<>();

    private final PaymentDAO paymentDAO = new PaymentDAO();

    // Use this to read and remove a result in one step, avoiding memory buildup
    public static String getAndRemoveResult(String checkoutRequestId) {
        return paymentResults.remove(checkoutRequestId);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String body = req.getReader().lines().collect(Collectors.joining("\n"));
        System.out.println("[MpesaCallback] Callback received. Length: " + body.length());

        // Respond 200 immediately — Safaricom retries if we don't respond quickly
        resp.setStatus(HttpServletResponse.SC_OK);
        resp.setContentType("application/json");
        resp.getWriter().write("{\"ResultCode\":0,\"ResultDesc\":\"Accepted\"}");

        try {
            processCallback(body);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void processCallback(String json) {
        String resultCodeStr     = extractJsonValue(json, "ResultCode");
        String checkoutRequestId = extractJsonValue(json, "CheckoutRequestID");

        int resultCode = resultCodeStr != null ? Integer.parseInt(resultCodeStr.trim()) : -1;

        System.out.println("[MpesaCallback] ResultCode: " + resultCode);
        System.out.println("[MpesaCallback] CheckoutRequestID: " + checkoutRequestId);

        if (checkoutRequestId == null) {
            System.out.println("[MpesaCallback] No CheckoutRequestID in callback.");
            return;
        }

        if (resultCode == 0) {
            String mpesaReceipt = extractJsonValue(json, "MpesaReceiptNumber");
            System.out.println("[MpesaCallback] Payment successful. Receipt: " + mpesaReceipt);

            paymentResults.put(checkoutRequestId,
                    "Completed:" + (mpesaReceipt != null ? mpesaReceipt : ""));

            try {
                paymentDAO.updatePaymentStatus(checkoutRequestId, "Completed", mpesaReceipt);
            } catch (Exception e) {
                System.out.println("[MpesaCallback] DB update failed: " + e.getMessage());
            }

        } else {
            System.out.println("[MpesaCallback] Payment failed or cancelled. Code: " + resultCode);
            paymentResults.put(checkoutRequestId, "Failed");

            try {
                paymentDAO.updatePaymentStatus(checkoutRequestId, "Failed", null);
            } catch (Exception e) {
                System.out.println("[MpesaCallback] DB update failed: " + e.getMessage());
            }
        }
    }

    // Extracts a value from a JSON string (handles both string and numeric values)
    private String extractJsonValue(String json, String key) {
        String searchStr = "\"" + key + "\":\"";
        int start = json.indexOf(searchStr);
        if (start != -1) {
            start += searchStr.length();
            int end = json.indexOf("\"", start);
            return end == -1 ? null : json.substring(start, end);
        }
        String searchNum = "\"" + key + "\":";
        start = json.indexOf(searchNum);
        if (start != -1) {
            start += searchNum.length();
            while (start < json.length() && json.charAt(start) == ' ') start++;
            int end = start;
            while (end < json.length() && (Character.isDigit(json.charAt(end))
                    || json.charAt(end) == '.' || json.charAt(end) == '-')) end++;
            return json.substring(start, end);
        }
        return null;
    }
}
