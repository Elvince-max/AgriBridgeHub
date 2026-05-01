package com.agribridge.controller;

import com.agribridge.dao.PaymentDAO;
import com.agribridge.model.Payment;
import com.agribridge.services.MpesaConfig;
import com.agribridge.services.MpesaService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

// Handles the payment page and M-Pesa STK Push initiation
@WebServlet("/pay")
public class PaymentServlet extends HttpServlet {

    private MpesaService mpesaService;
    private PaymentDAO paymentDAO;

    @Override
    public void init() throws ServletException {
        mpesaService = new MpesaService();
        paymentDAO   = new PaymentDAO();
    }

    // GET /pay?orderId=X — loads the payment page with order details
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String orderIdParam = req.getParameter("orderId");
        if (orderIdParam == null || orderIdParam.isBlank()) {
            resp.sendRedirect(req.getContextPath() + "/products.jsp");
            return;
        }

        try {
            int orderId = Integer.parseInt(orderIdParam);
            double amount = paymentDAO.getOrderAmount(orderId);
            if (amount <= 0) amount = 1.00;

            Payment payment = new Payment();
            payment.setOrderId(orderId);
            payment.setAmount(amount);
            payment.setPaymentMethod("M-Pesa");
            payment.setPaymentStatus("Pending");

            double deliveryFee = 150.00;
            double subtotal    = amount - deliveryFee;
            if (subtotal < 0) subtotal = amount;

            req.setAttribute("payment",     payment);
            req.setAttribute("deliveryFee", deliveryFee);
            req.setAttribute("subtotal",    subtotal);

            req.getRequestDispatcher("/payment.jsp").forward(req, resp);

        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/products.jsp");
        } catch (java.sql.SQLException e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/products.jsp");
        }
    }

    // POST /pay — validates the form and initiates M-Pesa STK Push
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(true);

        String orderIdParam = req.getParameter("orderId");
        String phoneParam   = req.getParameter("phone");
        String amountParam  = req.getParameter("amount");

        if (orderIdParam == null || phoneParam == null || amountParam == null
                || orderIdParam.isBlank() || phoneParam.isBlank() || amountParam.isBlank()) {
            req.setAttribute("errorMessage", "All fields are required.");
            req.getRequestDispatcher("/payment.jsp").forward(req, resp);
            return;
        }

        int    orderId = Integer.parseInt(orderIdParam);
        double amount  = Double.parseDouble(amountParam);
        String phone   = mpesaService.normalizePhone(phoneParam);

        if (!phone.matches("^254\\d{9}$")) {
            Payment payment = new Payment();
            payment.setOrderId(orderId);
            payment.setAmount(amount);
            double deliveryFee = 150.00;
            req.setAttribute("payment",      payment);
            req.setAttribute("deliveryFee",  deliveryFee);
            req.setAttribute("subtotal",     amount - deliveryFee);
            req.setAttribute("errorMessage", "Invalid phone number. Enter a valid Safaricom number e.g. 0712345678.");
            req.getRequestDispatcher("/payment.jsp").forward(req, resp);
            return;
        }

        try {
            String checkoutRequestId;

            if (MpesaConfig.SIMULATE) {
                checkoutRequestId = "SIM-" + System.currentTimeMillis();

                Payment payment = new Payment(orderId, amount, "M-Pesa (Simulated)", checkoutRequestId, "Completed");
                paymentDAO.insertPayment(payment);
                paymentDAO.updateOrderStatus(orderId, "confirmed");

                session.setAttribute("paymentStatus",   "Completed");
                session.setAttribute("transactionCode", checkoutRequestId);
                session.setAttribute("paymentOrderId",  orderId);
                session.setAttribute("paymentAmount",   amount);
                resp.sendRedirect(req.getContextPath() + "/Paymentstatus.jsp");
                return;
            }

            checkoutRequestId = mpesaService.initiateStkPush(phone, (int) Math.ceil(amount), orderId);

            if (checkoutRequestId == null) {
                Payment payment = new Payment();
                payment.setOrderId(orderId);
                payment.setAmount(amount);
                double deliveryFee = 150.00;
                req.setAttribute("payment",      payment);
                req.setAttribute("deliveryFee",  deliveryFee);
                req.setAttribute("subtotal",     amount - deliveryFee);
                req.setAttribute("errorMessage", "M-Pesa request failed. Check your credentials or network and try again.");
                req.getRequestDispatcher("/payment.jsp").forward(req, resp);
                return;
            }

            Payment payment = new Payment(orderId, amount, "M-Pesa", checkoutRequestId, "Pending");
            paymentDAO.insertPayment(payment);

            session.setAttribute("paymentStatus",  "Pending");
            session.setAttribute("transactionCode", checkoutRequestId);
            session.setAttribute("paymentOrderId",  orderId);
            session.setAttribute("paymentPhone",    phone);

            resp.sendRedirect(req.getContextPath() + "/Paymentstatus.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("errorMessage", "Unexpected error: " + e.getMessage());
            req.getRequestDispatcher("/payment.jsp").forward(req, resp);
        }
    }
}
