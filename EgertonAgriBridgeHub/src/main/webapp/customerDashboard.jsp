<%@ page import="java.sql.*, com.agribridgef1.util.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String userType = (String) session.getAttribute("userType");

    if (userType == null || !"CUSTOMER".equals(userType.trim().toUpperCase())) {
        response.sendRedirect("login.jsp");
        return;
    }

    int userId = (int) session.getAttribute("userId");

    String customerName = "Customer";
    String customerEmail = "Not provided";
    String customerPhone = "Not provided";

    int totalOrders = 0;
    int pendingOrders = 0;
    int deliveredOrders = 0;
    int pendingPayments = 0;

    double totalSpent = 0;

    String lastDeliveryZone = "Not selected";
    String lastDeliveryAddress = "No recent fulfilment location";

    Connection conn = null;

    try {
        conn = DBConnection.getConnection();

        // CUSTOMER DETAILS
        try {
            String userSql = "SELECT * FROM users WHERE user_id = ?";
            PreparedStatement ps = conn.prepareStatement(userSql);
            ps.setInt(1, userId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                try { customerName = rs.getString("full_name"); } catch (Exception e) {}
                try { customerEmail = rs.getString("email"); } catch (Exception e) {}
                try { customerPhone = rs.getString("phone"); } catch (Exception e) {}
            }

            rs.close();
            ps.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        if (customerName == null || customerName.trim().isEmpty()) {
            customerName = "Customer";
        }

        if (customerEmail == null || customerEmail.trim().isEmpty()) {
            customerEmail = "Not provided";
        }

        if (customerPhone == null || customerPhone.trim().isEmpty()) {
            customerPhone = "Not provided";
        }

        // TOTAL ORDERS + TOTAL SPENT
        try {
            String sql =
                "SELECT COUNT(*) AS total_orders, COALESCE(SUM(total_amount), 0) AS total_spent " +
                "FROM orders WHERE user_id = ?";

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                totalOrders = rs.getInt("total_orders");
                totalSpent = rs.getDouble("total_spent");
            }

            rs.close();
            ps.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        // ORDER STATUS COUNTS
        try {
            String sql =
                "SELECT order_status, COUNT(*) AS total " +
                "FROM orders WHERE user_id = ? GROUP BY order_status";

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                String status = rs.getString("order_status");
                int count = rs.getInt("total");

                if ("PENDING".equalsIgnoreCase(status)) {
                    pendingOrders += count;
                } else if ("DELIVERED".equalsIgnoreCase(status)) {
                    deliveredOrders += count;
                }
            }

            rs.close();
            ps.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        // PENDING PAYMENTS
        try {
            String sql =
                "SELECT COUNT(*) AS pending_payments " +
                "FROM payments p " +
                "JOIN orders o ON p.order_id = o.order_id " +
                "WHERE o.user_id = ? " +
                "AND p.payment_status IN ('PENDING', 'NOT PAID')";

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                pendingPayments = rs.getInt("pending_payments");
            }

            rs.close();
            ps.close();

        } catch (Exception e) {
            pendingPayments = 0;
        }

        // LAST DELIVERY / PICKUP LOCATION
        try {
            String sql =
                "SELECT delivery_zone, delivery_address " +
                "FROM orders WHERE user_id = ? " +
                "ORDER BY order_id DESC LIMIT 1";

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                try { lastDeliveryZone = rs.getString("delivery_zone"); } catch (Exception e) {}
                try { lastDeliveryAddress = rs.getString("delivery_address"); } catch (Exception e) {}
            }

            rs.close();
            ps.close();

        } catch (Exception e) {
            // keep fallback values
        }

        if (lastDeliveryZone == null || lastDeliveryZone.trim().isEmpty()) {
            lastDeliveryZone = "Not selected";
        }

        if (lastDeliveryAddress == null || lastDeliveryAddress.trim().isEmpty()) {
            lastDeliveryAddress = "No recent fulfilment location";
        }

    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Customer Dashboard - Egerton AgriBridge Hub</title>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/style.css?v=7">
</head>

<body class="customer-dash-body">

<div class="customer-dash-layout">

    <!-- SIDEBAR -->
    <aside class="customer-sidebar">
        <div class="customer-brand">
            <h2>AgriBridge</h2>
            <p>Customer Portal</p>
        </div>

        <nav class="customer-menu">
            <a href="customerDashboard.jsp" class="active">
                <span>▦</span>
                Dashboard
            </a>

            <a href="index.jsp">
                <span>⌂</span>
                Home
            </a>

            <a href="products.jsp">
                <span>🛒</span>
                Marketplace
            </a>

            <a href="cart.jsp">
                <span>🧺</span>
                Cart
            </a>

            <a href="myOrders.jsp">
                <span>▤</span>
                My Orders
            </a>

            <a href="profile.jsp">
                <span>👤</span>
                Profile
            </a>

            <a href="products.jsp">
                <span>🥛</span>
                Continue Shopping
            </a>
        </nav>

        <div class="customer-sidebar-bottom">
            <a class="customer-shop-btn" href="products.jsp">
                ＋ Shop Products
            </a>

            <a href="index.jsp" class="customer-logout">
                ⌂ Visit Home Page
            </a>

            <a href="logout" class="customer-logout">
                ⎋ Logout
            </a>
        </div>
    </aside>

    <!-- MAIN -->
    <main class="customer-main">

        <!-- TOP BAR -->
        <header class="customer-topbar">
                        <div>
                            <h1>Customer Dashboard</h1>
                            <p>Welcome back, <strong><%= customerName %></strong>.</p>
                        </div>

                       <div class="customer-top-actions">
                <form action="products.jsp" method="get" class="customer-search">
                    <span>⌕</span>
                    <input type="text" name="search" placeholder="Search dairy products...">
                </form>

                <a href="index.jsp"
                   class="customer-icon-btn"
                   title="Home">
                    ⌂
                </a>

                <a href="cart.jsp"
                   class="customer-icon-btn"
                   title="Cart">
                    🧺
                </a>

                <a href="profile.jsp"
                   class="customer-profile"
                   title="Profile">
                    👤
                </a>

                <a href="logout"
                   class="dashboard-logout-btn"
                   onclick="return confirm('Are you sure you want to logout?');">
                    Logout
                </a>
            </div>
        </header>

        <div class="customer-content">

            <!-- HERO -->
            <section class="customer-welcome-card">
                <div>
                    <p class="eyebrow">ACCOUNT OVERVIEW</p>
                    <h2>Hello, <%= customerName %></h2>
                    <p>
                        Track your orders, continue shopping fresh dairy products,
                        manage your profile, and monitor your AgriBridge purchases from one place.
                    </p>

                    <div class="customer-welcome-actions">
                        <a href="products.jsp">Shop Now</a>
                        <a href="myOrders.jsp" class="light">Track Orders</a>
                        <a href="profile.jsp" class="light">My Profile</a>
                        <a href="index.jsp" class="light">Visit Home</a>
                    </div>
                </div>

                <div class="customer-spend-box">
                    <span>Total Spend</span>
                    <strong>KES <%= String.format("%,.2f", totalSpent) %></strong>
                    <small>Across all recorded orders</small>
                </div>
            </section>

            <!-- STATS -->
            <section class="customer-stats-grid">

                <div class="customer-stat-card">
                    <div>🧾</div>
                    <span>Total Orders</span>
                    <h3><%= totalOrders %></h3>
                    <p>All orders placed</p>
                </div>

                <div class="customer-stat-card">
                    <div>⏳</div>
                    <span>Pending Orders</span>
                    <h3><%= pendingOrders %></h3>
                    <p>Awaiting processing</p>
                </div>

                <div class="customer-stat-card">
                    <div>✅</div>
                    <span>Delivered</span>
                    <h3><%= deliveredOrders %></h3>
                    <p>Completed deliveries</p>
                </div>

                <div class="customer-stat-card warning">
                    <div>💳</div>
                    <span>Pending Payments</span>
                    <h3><%= pendingPayments %></h3>
                    <p>Payments awaiting confirmation</p>
                </div>

            </section>

            <section class="customer-dashboard-grid">

                <!-- RECENT ORDERS -->
                <div class="customer-panel">
                    <div class="customer-panel-header">
                        <div>
                            <h2>Recent Orders</h2>
                            <p>Your latest AgriBridge purchases.</p>
                        </div>

                        <a href="myOrders.jsp">View All</a>
                    </div>

                    <div class="customer-orders-list">

                        <%
                            PreparedStatement orderPs = null;
                            ResultSet orderRs = null;
                            boolean hasRecentOrders = false;

                            try {
                                if (conn == null || conn.isClosed()) {
                                    conn = DBConnection.getConnection();
                                }

                                String recentSql =
                                    "SELECT o.order_id, o.total_amount, o.order_status, o.delivery_zone, " +
                                    "(SELECT p.payment_status FROM payments p " +
                                    " WHERE p.order_id = o.order_id " +
                                    " ORDER BY p.payment_id DESC LIMIT 1) AS payment_status " +
                                    "FROM orders o " +
                                    "WHERE o.user_id = ? " +
                                    "ORDER BY o.order_id DESC LIMIT 5";

                                orderPs = conn.prepareStatement(recentSql);
                                orderPs.setInt(1, userId);

                                orderRs = orderPs.executeQuery();

                                while (orderRs.next()) {
                                    hasRecentOrders = true;

                                    int recentOrderId = orderRs.getInt("order_id");
                                    double orderAmount = orderRs.getDouble("total_amount");

                                    String recentOrderStatus = orderRs.getString("order_status");
                                    String paymentStatus = orderRs.getString("payment_status");
                                    String zone = orderRs.getString("delivery_zone");

                                    if (recentOrderStatus == null || recentOrderStatus.trim().isEmpty()) {
                                        recentOrderStatus = "PENDING";
                                    }

                                    if (paymentStatus == null || paymentStatus.trim().isEmpty()) {
                                        paymentStatus = "PENDING";
                                    }

                                    if (zone == null || zone.trim().isEmpty()) {
                                        zone = "Not selected";
                                    }

                                    String orderStatusClass = recentOrderStatus.toLowerCase();
                                    String paymentStatusClass = paymentStatus.toLowerCase();
                        %>

                            <div class="customer-order-row">
                                <div>
                                    <strong>Order #<%= recentOrderId %></strong>
                                    <small><%= zone %></small>
                                </div>

                                <div>
                                    <span>KES <%= String.format("%,.2f", orderAmount) %></span>
                                </div>

                                <div>
                                    <em class="customer-status <%= orderStatusClass %>">
                                        <%= recentOrderStatus.replace("_", " ") %>
                                    </em>
                                </div>

                                <div>
                                    <em class="customer-payment <%= paymentStatusClass %>">
                                        <%= paymentStatus %>
                                    </em>
                                </div>

                                <a href="orderDetails.jsp?orderId=<%= recentOrderId %>">
                                    Details
                                </a>
                            </div>

                        <%
                                }

                            } catch (Exception e) {
                                e.printStackTrace();
                        %>

                            <div class="customer-empty-small">
                                Could not load recent orders.
                            </div>

                        <%
                            } finally {
                                if (orderRs != null) try { orderRs.close(); } catch (Exception e) {}
                                if (orderPs != null) try { orderPs.close(); } catch (Exception e) {}
                            }

                            if (!hasRecentOrders) {
                        %>

                            <div class="customer-empty-small">
                                No orders yet. Start shopping to place your first order.
                            </div>

                        <%
                            }
                        %>

                    </div>
                </div>

                <!-- SIDE INFO -->
                <aside class="customer-side-panel">

                    <div class="customer-profile-card">
                        <p class="eyebrow">CUSTOMER DETAILS</p>

                        <div class="customer-profile-row">
                            <div class="customer-avatar">👤</div>

                            <div>
                                <h3><%= customerName %></h3>
                                <p><%= customerEmail %></p>
                            </div>
                        </div>

                        <div class="customer-detail-list">
                            <div>
                                <span>Phone</span>
                                <strong><%= customerPhone %></strong>
                            </div>

                            <div>
                                <span>Customer ID</span>
                                <strong>#<%= userId %></strong>
                            </div>
                        </div>

                        <a href="profile.jsp" class="customer-profile-edit-link">
                            Manage Profile & Security
                        </a>
                    </div>

                    <div class="customer-location-card">
                        <h3>Recent Fulfilment</h3>

                        <div>
                            <span>Zone / Method</span>
                            <strong><%= lastDeliveryZone %></strong>
                        </div>

                        <div>
                            <span>Address / Pickup</span>
                            <strong><%= lastDeliveryAddress %></strong>
                        </div>
                    </div>

                    <div class="customer-quick-card">
                        <h3>Quick Actions</h3>

                        <a href="index.jsp">Visit Home Page</a>
                        <a href="products.jsp">Browse Products</a>
                        <a href="cart.jsp">View Cart</a>
                        <a href="myOrders.jsp">Track My Orders</a>
                        <a href="profile.jsp">Profile & Security</a>
                    </div>

                </aside>

            </section>

        </div>

    </main>

</div>

<%
    if (conn != null) {
        try { conn.close(); } catch (Exception e) {}
    }
%>

</body>
</html>