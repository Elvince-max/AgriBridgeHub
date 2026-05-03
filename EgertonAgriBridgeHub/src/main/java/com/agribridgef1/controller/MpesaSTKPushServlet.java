package com.agribridgef1.controller;

import com.agribridgef1.dao.PaymentDAO;
import com.agribridgef1.service.MpesaService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import org.json.JSONObject;

import java.io.IOException;

@WebServlet("/mpesaSTKPush")
public class MpesaSTKPushServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int orderId = Integer.parseInt(request.getParameter("orderId"));
        double amountDouble = Double.parseDouble(request.getParameter("amount"));
        int amount = (int) amountDouble;

        String phone = request.getParameter("phone");
        phone = formatPhoneNumber(phone);

        if (phone == null) {
            response.sendRedirect("payment.jsp?orderId=" + orderId + "&error=phone");
            return;
        }

        try {
            MpesaService service = new MpesaService();
            String stkResponse = service.stkPush(phone, amount, orderId);

            JSONObject json = new JSONObject(stkResponse);

            String responseCode = json.optString("ResponseCode", "");
            String checkoutRequestId = json.optString("CheckoutRequestID", "");

            if ("0".equals(responseCode) && !checkoutRequestId.isEmpty()) {
                PaymentDAO paymentDAO = new PaymentDAO();

                paymentDAO.savePendingMpesaPayment(orderId, amountDouble, checkoutRequestId);

                session.setAttribute("checkoutRequestId", checkoutRequestId);

                response.sendRedirect("mpesaPending.jsp?orderId=" + orderId);
            } else {
                response.sendRedirect("payment.jsp?orderId=" + orderId + "&error=mpesa");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("payment.jsp?orderId=" + orderId + "&error=mpesa");
        }
    }

    private String formatPhoneNumber(String phone) {
        if (phone == null) {
            return null;
        }

        phone = phone.trim().replaceAll("\\s+", "");

        if (phone.matches("07[0-9]{8}") || phone.matches("01[0-9]{8}")) {
            return "254" + phone.substring(1);
        }

        if (phone.matches("2547[0-9]{8}") || phone.matches("2541[0-9]{8}")) {
            return phone;
        }

        return null;
    }
}