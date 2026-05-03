package com.agribridgef1.controller;

import com.agribridgef1.dao.PaymentDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.UUID;

@WebServlet("/payment")
public class PaymentServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            double amount = Double.parseDouble(request.getParameter("amount"));
            String method = request.getParameter("method");

            String transactionCode = UUID.randomUUID().toString().substring(0, 8).toUpperCase();

            /*
                Cash on delivery is not paid yet.
                It should remain pending until staff confirms cash was received.
            */
            String status = "PENDING";

            PaymentDAO dao = new PaymentDAO();
            boolean success = dao.savePayment(orderId, amount, method, transactionCode, status);

            if (success) {
                response.sendRedirect("orderDetails.jsp?orderId=" + orderId);
            } else {
                response.sendRedirect("payment.jsp?orderId=" + orderId + "&error=1");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("myOrders.jsp");
        }
    }
}