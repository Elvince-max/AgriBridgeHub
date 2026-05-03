package com.agribridgef1.controller;

import com.agribridgef1.dao.PaymentDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/paymentStatus")
public class PaymentStatusServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        int orderId = Integer.parseInt(request.getParameter("orderId"));

        PaymentDAO paymentDAO = new PaymentDAO();
        String status = paymentDAO.getPaymentStatusByOrderId(orderId);

        response.setContentType("application/json");
        response.getWriter().write("{\"status\":\"" + status + "\"}");
    }
}