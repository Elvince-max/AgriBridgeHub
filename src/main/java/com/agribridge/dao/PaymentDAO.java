package com.agribridge.dao;

import com.agribridge.model.Payment;
import com.agribridge.util.DBConnection;

import java.sql.*;

public class PaymentDAO {

    public int insertPayment(Payment payment) throws SQLException {
        String sql = "INSERT INTO payments (order_id, amount, payment_method, "
                   + "transaction_code, payment_status, payment_date) "
                   + "VALUES (?, ?, ?, ?, ?, NOW())";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt   (1, payment.getOrderId());
            ps.setDouble(2, payment.getAmount());
            ps.setString(3, payment.getPaymentMethod());
            ps.setString(4, payment.getTransactionCode());
            ps.setString(5, payment.getPaymentStatus());
            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) return rs.getInt(1);
        }
        return -1;
    }

    // Updates payment status once Safaricom confirms via callback
    public boolean updatePaymentStatus(String checkoutRequestId,
                                       String newStatus,
                                       String mpesaReceiptNumber) throws SQLException {
        String sql = "UPDATE payments SET payment_status = ?, transaction_code = ? "
                   + "WHERE transaction_code = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, newStatus);
            ps.setString(2, mpesaReceiptNumber != null ? mpesaReceiptNumber : checkoutRequestId);
            ps.setString(3, checkoutRequestId);

            return ps.executeUpdate() > 0;
        }
    }

    public boolean updateOrderStatus(int orderId, String status) throws SQLException {
        String sql = "UPDATE orders SET status = ? WHERE order_id = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setInt   (2, orderId);
            return ps.executeUpdate() > 0;
        }
    }

    public Payment getPaymentByOrderId(int orderId) throws SQLException {
        String sql = "SELECT * FROM payments WHERE order_id = ? ORDER BY payment_date DESC LIMIT 1";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Payment p = new Payment();
                p.setPaymentId      (rs.getInt      ("payment_id"));
                p.setOrderId        (rs.getInt      ("order_id"));
                p.setAmount         (rs.getDouble   ("amount"));
                p.setPaymentMethod  (rs.getString   ("payment_method"));
                p.setTransactionCode(rs.getString   ("transaction_code"));
                p.setPaymentStatus  (rs.getString   ("payment_status"));
                p.setPaymentDate    (rs.getTimestamp("payment_date"));
                return p;
            }
        }
        return null;
    }

    public double getOrderAmount(int orderId) throws SQLException {
        String sql = "SELECT total_amount FROM orders WHERE order_id = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getDouble("total_amount");
        }
        return 0.0;
    }

    private Connection getConnection() throws SQLException {
        Connection conn = DBConnection.getConnection();
        if (conn == null) {
            throw new SQLException("Could not get a database connection.");
        }
        return conn;
    }
}