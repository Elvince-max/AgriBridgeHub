package com.agribridge.controller;

import com.agribridge.dao.OrderDAO;
import com.agribridge.model.Cart;
import com.agribridge.model.Order;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/quickOrder")
public class QuickOrderServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(true);
        Cart cart = (Cart) session.getAttribute("cart");

        if (cart == null || cart.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/products.jsp");
            return;
        }

        // Get logged-in user or fall back to test user (id = 1)
        Integer userId = (Integer) session.getAttribute("userId");
        if (userId == null) userId = 1;

        // Store userId in session so payment pages can access it
        session.setAttribute("userId", userId);

        try {
            double cartTotal   = cart.getTotal();
            double deliveryFee = 10.00;
            double totalAmount = cartTotal + deliveryFee;

            Order order = new Order();
            order.setUserId(userId);
            order.setOrderNumber("ORD-" + System.currentTimeMillis());
            order.setTotalAmount(totalAmount);
            order.setDeliveryFee(deliveryFee);
            order.setStatus("pending");
            order.setPaymentStatus("pending");
            order.setDeliveryAddress("Egerton University, Njoro");

            int orderId = orderDAO.createOrder(order);

            // Store amounts in session so PaymentServlet/JSP can display correctly
            session.setAttribute("paymentOrderId",  orderId);
            session.setAttribute("paymentAmount",   totalAmount);
            session.setAttribute("paymentSubtotal", cartTotal);
            session.setAttribute("paymentDelivery", deliveryFee);

            resp.sendRedirect(req.getContextPath() + "/pay?orderId=" + orderId);

        } catch (SQLException e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/products.jsp");
        }
    }
}
