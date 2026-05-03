package com.agribridgef1.controller;

import com.agribridgef1.dao.PaymentDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import org.json.JSONArray;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.IOException;

@WebServlet("/mpesaCallback")
public class MpesaCallbackServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        StringBuilder sb = new StringBuilder();
        String line;

        try (BufferedReader reader = request.getReader()) {
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
        }

        String callbackBody = sb.toString();
        System.out.println("M-Pesa Callback: " + callbackBody);

        try {
            JSONObject json = new JSONObject(callbackBody);

            JSONObject stkCallback = json
                    .getJSONObject("Body")
                    .getJSONObject("stkCallback");

            int resultCode = stkCallback.getInt("ResultCode");
            String checkoutRequestId = stkCallback.getString("CheckoutRequestID");

            String transactionCode = "N/A";
            String paymentStatus;

            if (resultCode == 0) {
                paymentStatus = "PAID";

                JSONArray items = stkCallback
                        .getJSONObject("CallbackMetadata")
                        .getJSONArray("Item");

                for (int i = 0; i < items.length(); i++) {
                    JSONObject item = items.getJSONObject(i);
                    String name = item.getString("Name");

                    if ("MpesaReceiptNumber".equals(name)) {
                        transactionCode = item.getString("Value");
                    }
                }

                System.out.println("M-Pesa payment successful. Receipt: " + transactionCode);

            } else {
                paymentStatus = "FAILED";
                transactionCode = "N/A";

                String resultDesc = stkCallback.optString("ResultDesc", "Payment failed or cancelled");
                System.out.println("M-Pesa payment failed. Reason: " + resultDesc);
            }

            PaymentDAO paymentDAO = new PaymentDAO();
            boolean updated = paymentDAO.updateMpesaPaymentStatus(
                    checkoutRequestId,
                    transactionCode,
                    paymentStatus
            );

            if (updated) {
                System.out.println("Payment table updated successfully for CheckoutRequestID: " + checkoutRequestId);
            } else {
                System.out.println("No payment record found for CheckoutRequestID: " + checkoutRequestId);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        response.setContentType("application/json");
        response.getWriter().write("{\"ResultCode\":0,\"ResultDesc\":\"Accepted\"}");
    }
}