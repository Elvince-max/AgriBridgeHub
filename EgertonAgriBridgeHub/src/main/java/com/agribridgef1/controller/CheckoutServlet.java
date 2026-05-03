package com.agribridgef1.controller;

import com.agribridgef1.dao.ProductDAO;
import com.agribridgef1.model.Product;
import com.agribridgef1.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.*;
import java.util.Map;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute("cart");

        if (cart == null || cart.isEmpty()) {
            response.sendRedirect("cart.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");

        String deliveryZone = request.getParameter("deliveryZone");
        String phone = request.getParameter("phone");
        String deliveryAddress = request.getParameter("deliveryAddress");
        String notes = request.getParameter("notes");

        if ("Campus pickup".equals(deliveryZone)) {
            deliveryAddress = "Campus pickup";
        }

        if (notes == null) {
            notes = "";
        }

        double deliveryFee = Double.parseDouble(request.getParameter("deliveryFee"));

        ProductDAO productDAO = new ProductDAO();

        double subtotal = 0;

        for (Map.Entry<Integer, Integer> entry : cart.entrySet()) {
            Product product = productDAO.getProductById(entry.getKey());

            if (product != null) {
                int quantity = entry.getValue();
                subtotal += product.getPrice() * quantity;
            }
        }

        double totalAmount = subtotal + deliveryFee;

        Connection conn = null;

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            String orderSql =
                    "INSERT INTO orders " +
                    "(user_id, total_amount, order_status, delivery_zone, delivery_fee, phone, delivery_address, notes) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

            int orderId;

            try (PreparedStatement ps = conn.prepareStatement(orderSql, Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, userId);
                ps.setDouble(2, totalAmount);
                ps.setString(3, "PENDING");
                ps.setString(4, deliveryZone);
                ps.setDouble(5, deliveryFee);
                ps.setString(6, phone);
                ps.setString(7, deliveryAddress);
                ps.setString(8, notes);

                ps.executeUpdate();

                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        orderId = rs.getInt(1);
                    } else {
                        throw new SQLException("Failed to create order.");
                    }
                }
            }

            String itemSql =
                    "INSERT INTO order_items (order_id, product_id, quantity, price) " +
                    "VALUES (?, ?, ?, ?)";

            try (PreparedStatement ps = conn.prepareStatement(itemSql)) {
                for (Map.Entry<Integer, Integer> entry : cart.entrySet()) {
                    int productId = entry.getKey();
                    int quantity = entry.getValue();

                    Product product = productDAO.getProductById(productId);

                    if (product != null) {
                        ps.setInt(1, orderId);
                        ps.setInt(2, productId);
                        ps.setInt(3, quantity);
                        ps.setDouble(4, product.getPrice());
                        ps.addBatch();
                    }
                }

                ps.executeBatch();
            }

            conn.commit();

            cart.clear();

            response.sendRedirect("orderConfirmation.jsp?orderId=" + orderId);

        } catch (Exception e) {
            e.printStackTrace();

            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }

            response.sendRedirect("checkout.jsp?error=1");

        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
}