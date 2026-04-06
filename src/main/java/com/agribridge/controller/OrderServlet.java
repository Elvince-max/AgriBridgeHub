package com.agribridge.controller;

import com.agribridge.dao.OrderDAO;
import com.agribridge.dao.OrderItemDAO;
import com.agribridge.model.Cart;
import com.agribridge.model.CartItem;
import com.agribridge.model.Order;
import com.agribridge.model.OrderItem;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@WebServlet("/OrderServlet")
public class OrderServlet extends HttpServlet {

    private OrderDAO orderDAO = new OrderDAO();
    private OrderItemDAO orderItemDAO = new OrderItemDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if ("placeOrder".equals(action)) {
            placeOrder(req, resp);
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect("login.jsp");
            return;
        }
        if ("myOrders".equals(action)) {
            showMyOrders(req, resp);
        } else if ("view".equals(action)) {
            viewOrderDetail(req, resp);
        }
    }

    private void placeOrder(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession();
        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null || cart.getItems().isEmpty()) {
            resp.sendRedirect("cart.jsp?error=empty");
            return;
        }

        Integer userId = (Integer) session.getAttribute("userId");
        if (userId == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        // Get form parameters
        String address = req.getParameter("address");
        if (address == null || address.trim().isEmpty()) {
            resp.sendRedirect("checkout.jsp?error=address");
            return;
        }

        // Optional fields from checkout form (you may store them later)
        String fullName = req.getParameter("fullName");
        String phone = req.getParameter("phone");
        String deliverySlot = req.getParameter("deliverySlot");
        String paymentMethod = req.getParameter("paymentMethod");

        // Calculate totals
        double subtotal = cart.getTotal();
        double deliveryFee = 150.0;  // fixed or could come from a config
        double total = subtotal + deliveryFee;
        String orderNumber = "ORD-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();

        // Create Order object
        Order order = new Order();
        order.setUserId(userId);
        order.setOrderNumber(orderNumber);
        order.setTotalAmount(total);
        order.setDeliveryFee(deliveryFee);
        order.setStatus("pending");
        order.setPaymentStatus("pending");
        order.setDeliveryAddress(address);
        // Optionally store fullName, phone, deliverySlot in extra columns if you add them later

        try {
            // 1. Insert order and get generated orderId
            int orderId = orderDAO.createOrder(order);

            // 2. Prepare order items (with price and subtotal)
            List<OrderItem> items = new ArrayList<>();
            for (CartItem cartItem : cart.getItems()) {
                double unitPrice = cartItem.getPrice();
                int quantity = cartItem.getQuantity();
                double subtotalItem = unitPrice * quantity;
                OrderItem item = new OrderItem(orderId, cartItem.getProductId(),
                        quantity, unitPrice, subtotalItem);
                items.add(item);
            }
            orderItemDAO.addOrderItems(items);

            // 3. Clear cart
            session.removeAttribute("cart");

            // 4. Store info for payment page (optional)
            session.setAttribute("lastOrderNumber", orderNumber);
            session.setAttribute("lastOrderTotal", total);

            // 5. Redirect to Samuel's PaymentServlet
            resp.sendRedirect("PaymentServlet?orderId=" + orderId + "&amount=" + total);

        } catch (SQLException e) {
            e.printStackTrace();
            resp.sendRedirect("checkout.jsp?error=db");
        }
    }

    private void showMyOrders(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        int userId = (Integer) session.getAttribute("userId");
        try {
            List<Order> orders = orderDAO.getOrdersByUserId(userId);
            req.setAttribute("orders", orders);
            req.getRequestDispatcher("orders.jsp").forward(req, resp);
        } catch (SQLException e) {
            e.printStackTrace();
            resp.sendError(500, "Database error while fetching orders");
        }
    }

    private void viewOrderDetail(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int orderId = Integer.parseInt(req.getParameter("orderId"));
        try {
            Order order = orderDAO.getOrderById(orderId);
            List<OrderItem> items = orderItemDAO.getOrderItemsByOrderId(orderId);
            req.setAttribute("order", order);
            req.setAttribute("orderItems", items);
            req.getRequestDispatcher("orderDetail.jsp").forward(req, resp);
        } catch (SQLException e) {
            e.printStackTrace();
            resp.sendError(500, "Database error while fetching order details");
        }
    }
}