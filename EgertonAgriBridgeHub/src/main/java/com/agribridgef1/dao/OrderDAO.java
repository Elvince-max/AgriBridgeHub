package com.agribridgef1.dao;

import com.agribridgef1.model.Order;
import com.agribridgef1.model.OrderItem;
import com.agribridgef1.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {

    public int createOrder(Order order, List<OrderItem> items) {
        int orderId = 0;

        String orderSql =
                "INSERT INTO orders (user_id, delivery_address, delivery_time, order_status, total_amount) " +
                "VALUES (?, ?, ?, ?, ?)";

        String itemSql =
                "INSERT INTO order_items (order_id, product_id, quantity, price) " +
                "VALUES (?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);

            try (PreparedStatement orderPs = conn.prepareStatement(orderSql, Statement.RETURN_GENERATED_KEYS)) {
                orderPs.setInt(1, order.getUserId());
                orderPs.setString(2, order.getDeliveryAddress());
                orderPs.setString(3, order.getDeliveryTime());
                orderPs.setString(4, order.getOrderStatus());
                orderPs.setDouble(5, order.getTotalAmount());

                orderPs.executeUpdate();

                try (ResultSet rs = orderPs.getGeneratedKeys()) {
                    if (rs.next()) {
                        orderId = rs.getInt(1);
                    }
                }
            }

            if (orderId == 0) {
                conn.rollback();
                return 0;
            }

            try (PreparedStatement itemPs = conn.prepareStatement(itemSql)) {
                for (OrderItem item : items) {
                    itemPs.setInt(1, orderId);
                    itemPs.setInt(2, item.getProductId());
                    itemPs.setInt(3, item.getQuantity());
                    itemPs.setDouble(4, item.getPrice());
                    itemPs.addBatch();
                }

                itemPs.executeBatch();
            }

            /*
                IMPORTANT:
                Do not reduce stock here.
                Stock should only reduce after payment is confirmed as PAID.
            */

            conn.commit();

        } catch (Exception e) {
            e.printStackTrace();
            orderId = 0;
        }

        return orderId;
    }

    public List<Order> getOrdersByUser(int userId) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE user_id = ? ORDER BY order_date DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Order o = new Order();
                    o.setOrderId(rs.getInt("order_id"));
                    o.setUserId(rs.getInt("user_id"));
                    o.setDeliveryAddress(rs.getString("delivery_address"));
                    o.setDeliveryTime(rs.getString("delivery_time"));
                    o.setOrderStatus(rs.getString("order_status"));
                    o.setTotalAmount(rs.getDouble("total_amount"));

                    list.add(o);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<OrderItem> getOrderItems(int orderId) {
        List<OrderItem> list = new ArrayList<>();
        String sql = "SELECT * FROM order_items WHERE order_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, orderId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OrderItem item = new OrderItem();
                    item.setProductId(rs.getInt("product_id"));
                    item.setQuantity(rs.getInt("quantity"));
                    item.setPrice(rs.getDouble("price"));

                    list.add(item);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<Order> getAllOrders() {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM orders ORDER BY order_date DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Order o = new Order();
                o.setOrderId(rs.getInt("order_id"));
                o.setUserId(rs.getInt("user_id"));
                o.setDeliveryAddress(rs.getString("delivery_address"));
                o.setDeliveryTime(rs.getString("delivery_time"));
                o.setOrderStatus(rs.getString("order_status"));
                o.setTotalAmount(rs.getDouble("total_amount"));

                list.add(o);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public boolean updateOrderStatus(int orderId, String status) {
        String sql = "UPDATE orders SET order_status = ? WHERE order_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setInt(2, orderId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean assignDelivery(int orderId, int agentId) {
        String sql =
                "INSERT INTO deliveries (order_id, delivery_agent_id, delivery_status, assigned_date) " +
                "VALUES (?, ?, 'ASSIGNED', NOW())";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, orderId);
            ps.setInt(2, agentId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public List<Order> getDeliveriesByAgent(int agentId) {
        List<Order> list = new ArrayList<>();

        String sql =
                "SELECT o.*, d.delivery_status " +
                "FROM orders o " +
                "JOIN deliveries d ON o.order_id = d.order_id " +
                "WHERE d.delivery_agent_id = ? " +
                "ORDER BY o.order_date DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, agentId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Order o = new Order();
                    o.setOrderId(rs.getInt("order_id"));
                    o.setUserId(rs.getInt("user_id"));
                    o.setDeliveryAddress(rs.getString("delivery_address"));
                    o.setDeliveryTime(rs.getString("delivery_time"));
                    o.setOrderStatus(rs.getString("delivery_status"));
                    o.setTotalAmount(rs.getDouble("total_amount"));

                    list.add(o);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public boolean updateDeliveryStatus(int orderId, int agentId, String deliveryStatus) {
        String deliverySql =
                "UPDATE deliveries " +
                "SET delivery_status = ?, " +
                "delivered_date = CASE WHEN ? = 'DELIVERED' THEN NOW() ELSE delivered_date END " +
                "WHERE order_id = ? AND delivery_agent_id = ?";

        String orderSql = "UPDATE orders SET order_status = ? WHERE order_id = ?";

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);

            try (PreparedStatement deliveryPs = conn.prepareStatement(deliverySql)) {
                deliveryPs.setString(1, deliveryStatus);
                deliveryPs.setString(2, deliveryStatus);
                deliveryPs.setInt(3, orderId);
                deliveryPs.setInt(4, agentId);

                deliveryPs.executeUpdate();
            }

            String orderStatus;

            if ("PICKED_UP".equals(deliveryStatus)) {
                orderStatus = "PROCESSING";
            } else if ("IN_TRANSIT".equals(deliveryStatus)) {
                orderStatus = "OUT_FOR_DELIVERY";
            } else if ("DELIVERED".equals(deliveryStatus)) {
                orderStatus = "DELIVERED";
            } else if ("FAILED".equals(deliveryStatus)) {
                orderStatus = "CONFIRMED";
            } else {
                orderStatus = "CONFIRMED";
            }

            try (PreparedStatement orderPs = conn.prepareStatement(orderSql)) {
                orderPs.setString(1, orderStatus);
                orderPs.setInt(2, orderId);

                orderPs.executeUpdate();
            }

            conn.commit();
            return true;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
}