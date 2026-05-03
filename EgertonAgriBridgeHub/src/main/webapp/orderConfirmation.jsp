<%@ page import="java.sql.*, java.util.*, com.agribridgef1.util.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    int userId = (int) session.getAttribute("userId");

    String orderIdParam = request.getParameter("orderId");

    if (orderIdParam == null || orderIdParam.trim().isEmpty()) {
        response.sendRedirect("myOrders.jsp");
        return;
    }

    int orderId = Integer.parseInt(orderIdParam);

    String orderStatus = "";
    String deliveryZone = "";
    String deliveryAddress = "";
    String phone = "";
    String notes = "";
    double totalAmount = 0;
    double deliveryFee = 0;

    boolean orderFound = false;

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        conn = DBConnection.getConnection();

        String sql = "SELECT * FROM orders WHERE order_id = ? AND user_id = ?";
        ps = conn.prepareStatement(sql);
        ps.setInt(1, orderId);
        ps.setInt(2, userId);

        rs = ps.executeQuery();

        if (rs.next()) {
            orderFound = true;

            orderStatus = rs.getString("order_status");
            totalAmount = rs.getDouble("total_amount");

            try { deliveryZone = rs.getString("delivery_zone"); } catch (Exception e) {}
            try { deliveryFee = rs.getDouble("delivery_fee"); } catch (Exception e) {}
            try { phone = rs.getString("phone"); } catch (Exception e) {}
            try { deliveryAddress = rs.getString("delivery_address"); } catch (Exception e) {}
            try { notes = rs.getString("notes"); } catch (Exception e) {}
        }

    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception e) {}
        if (ps != null) try { ps.close(); } catch (Exception e) {}
        if (conn != null) try { conn.close(); } catch (Exception e) {}
    }

    if (!orderFound) {
        response.sendRedirect("myOrders.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Order Confirmation - Egerton AgriBridge Hub</title>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/style.css">
</head>

<body class="confirmation-body">

<div class="cart-navbar">
    <div class="cart-logo">EgertonAgriBridgeHub</div>

    <div class="cart-nav-links">
        <a href="products.jsp">Marketplace</a>
        <a href="myOrders.jsp">My Orders</a>
        <a href="index.jsp">Home</a>
    </div>

    <div class="cart-nav-right">
        <a class="cart-icon" href="cart.jsp">🛒</a>
        <a class="cart-icon" href="logout">⎋</a>
    </div>
</div>

<div class="confirmation-page">

    <div class="confirmation-card">

        <div class="success-icon">✓</div>

        <p class="eyebrow center">ORDER CREATED</p>
        <h1>Order Confirmed</h1>

        <p class="confirmation-message">
            Your order has been placed successfully. Complete payment to help us process it faster.
        </p>

        <div class="confirmation-order-number">
            Order #<%= orderId %>
        </div>

        <div class="confirmation-grid">

            <div class="confirmation-info-box">
                <span>Total Amount</span>
                <strong>KES <%= String.format("%.2f", totalAmount) %></strong>
            </div>

            <div class="confirmation-info-box">
                <span>Order Status</span>
                <strong><%= orderStatus %></strong>
            </div>

            <div class="confirmation-info-box">
                <span>Delivery Option</span>
                <strong><%= deliveryZone != null ? deliveryZone : "Not specified" %></strong>
            </div>

            <div class="confirmation-info-box">
                <span>Delivery Fee</span>
                <strong>KES <%= String.format("%.2f", deliveryFee) %></strong>
            </div>

        </div>

        <div class="confirmation-details">
            <h3>Contact & Fulfilment Details</h3>

            <p><strong>Phone:</strong> <%= phone != null ? phone : "Not provided" %></p>
            <p><strong>Location:</strong> <%= deliveryAddress != null ? deliveryAddress : "Not provided" %></p>

            <% if (notes != null && !notes.trim().isEmpty()) { %>
                <p><strong>Notes:</strong> <%= notes %></p>
            <% } %>
        </div>

        <div class="confirmation-actions">
            <a class="confirmation-pay-btn" href="payment.jsp?orderId=<%= orderId %>">
                Pay Now with M-Pesa
            </a>

            <a class="confirmation-secondary-btn" href="orderDetails.jsp?orderId=<%= orderId %>">
                View Order Details
            </a>
        </div>

        <a class="confirmation-link" href="products.jsp">
            Continue Shopping
        </a>

    </div>

</div>

</body>
</html>