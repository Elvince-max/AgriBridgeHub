<%@ page import="java.sql.*, com.agribridgef1.dao.UserDAO, com.agribridgef1.model.User, com.agribridgef1.util.DBConnection" %>
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

    UserDAO userDAO = new UserDAO();
    User user = userDAO.getUserById(userId);

    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    int totalOrders = 0;
    int deliveredOrders = 0;
    int pendingPayments = 0;
    double totalSpent = 0;

    try (Connection conn = DBConnection.getConnection()) {

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

        try {
            String sql =
                "SELECT COUNT(*) AS delivered_orders " +
                "FROM orders WHERE user_id = ? AND order_status = 'DELIVERED'";

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                deliveredOrders = rs.getInt("delivered_orders");
            }

            rs.close();
            ps.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        try {
            String sql =
                "SELECT COUNT(*) AS pending_payments " +
                "FROM payments p " +
                "JOIN orders o ON p.order_id = o.order_id " +
                "WHERE o.user_id = ? AND p.payment_status = 'PENDING'";

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

    } catch (Exception e) {
        e.printStackTrace();
    }

    String profileStatus = request.getParameter("profile");
    String securityStatus = request.getParameter("security");
%>

<!DOCTYPE html>
<html>
<head>
    <title>My Profile - Egerton AgriBridge Hub</title>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/style.css?v=6">
</head>

<body class="customer-profile-body">

<div class="customer-dash-layout">

    <!-- SIDEBAR -->
    <aside class="customer-sidebar">
        <div class="customer-brand">
            <h2>AgriBridge</h2>
            <p>Customer Portal</p>
        </div>

        <nav class="customer-menu">
            <a href="customerDashboard.jsp">
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

            <a href="profile.jsp" class="active">
                <span>👤</span>
                Profile
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

        <header class="customer-topbar">
            <div>
                <h1>My Profile</h1>
                <p>Manage your personal details and account security.</p>
            </div>

            <div class="customer-top-actions">
                <form action="products.jsp" method="get" class="customer-search">
                    <span>⌕</span>
                    <input type="text" name="search" placeholder="Search dairy products...">
                </form>

                <a href="index.jsp" class="customer-icon-btn" title="Home">⌂</a>
                <a href="cart.jsp" class="customer-icon-btn" title="Cart">🧺</a>
                <a href="customerDashboard.jsp" class="customer-profile" title="Dashboard">👤</a>
            </div>
        </header>

        <div class="customer-content">

            <section class="profile-hero-card">
                <div>
                    <p class="eyebrow">ACCOUNT SETTINGS</p>
                    <h1>Hello, <%= user.getFullName() %></h1>
                    <p>
                        Keep your contact details up to date and protect your AgriBridge account with a secure password.
                    </p>
                </div>

                <div class="profile-id-card">
                    <span>Customer ID</span>
                    <strong>#<%= user.getUserId() %></strong>
                    <small><%= user.getUserType() %></small>
                </div>
            </section>

            <% if ("updated".equals(profileStatus)) { %>
                <div class="review-success">Profile updated successfully.</div>
            <% } else if ("email_exists".equals(profileStatus)) { %>
                <div class="review-error">That email address is already used by another account.</div>
            <% } else if ("error".equals(profileStatus)) { %>
                <div class="review-error">Could not update profile. Please try again.</div>
            <% } %>

            <% if ("changed".equals(securityStatus)) { %>
                <div class="review-success">Password changed successfully.</div>
            <% } else if ("wrong_current".equals(securityStatus)) { %>
                <div class="review-error">Current password is incorrect.</div>
            <% } else if ("mismatch".equals(securityStatus)) { %>
                <div class="review-error">New password and confirmation do not match.</div>
            <% } else if ("weak".equals(securityStatus)) { %>
                <div class="review-error">Password must be at least 6 characters long.</div>
            <% } else if ("error".equals(securityStatus)) { %>
                <div class="review-error">Could not change password. Please try again.</div>
            <% } %>

            <!-- ACCOUNT STATS -->
            <section class="profile-stats-grid">
                <div>
                    <span>Total Orders</span>
                    <strong><%= totalOrders %></strong>
                    <small>All orders placed</small>
                </div>

                <div>
                    <span>Delivered Orders</span>
                    <strong><%= deliveredOrders %></strong>
                    <small>Completed fulfilment</small>
                </div>

                <div>
                    <span>Pending Payments</span>
                    <strong><%= pendingPayments %></strong>
                    <small>Awaiting payment</small>
                </div>

                <div>
                    <span>Total Spend</span>
                    <strong>KES <%= String.format("%,.2f", totalSpent) %></strong>
                    <small>Recorded order value</small>
                </div>
            </section>

            <section class="profile-layout">

                <!-- PERSONAL DETAILS -->
                <div class="profile-card">
                    <div class="profile-card-header">
                        <div>
                            <h2>Personal Details</h2>
                            <p>Update your name, email address, and phone number.</p>
                        </div>
                    </div>

                    <form action="updateProfile" method="post" class="profile-form" onsubmit="return validateProfileForm();">

                        <label>Full Name</label>
                        <input type="text"
                               name="fullName"
                               id="fullName"
                               value="<%= user.getFullName() != null ? user.getFullName() : "" %>"
                               required>

                        <label>Email Address</label>
                        <input type="email"
                               name="email"
                               id="email"
                               value="<%= user.getEmail() != null ? user.getEmail() : "" %>"
                               required>

                        <label>Phone Number</label>
                        <input type="text"
                               name="phone"
                               id="phone"
                               placeholder="0712345678"
                               value="<%= user.getPhone() != null ? user.getPhone() : "" %>">

                        <button type="submit" class="profile-main-btn">
                            Save Changes
                        </button>
                    </form>
                </div>

                <!-- SECURITY SETTINGS -->
                <div class="profile-card">
                    <div class="profile-card-header">
                        <div>
                            <h2>Security Settings</h2>
                            <p>Change your password using your current password.</p>
                        </div>
                    </div>

                    <form action="changePassword" method="post" class="profile-form" onsubmit="return validatePasswordForm();">

                        <label>Current Password</label>
                        <div class="profile-password-wrap">
                            <input type="password"
                                   name="currentPassword"
                                   id="currentPassword"
                                   placeholder="Enter current password"
                                   required>

                            <button type="button" onclick="toggleProfilePassword('currentPassword', this)">👁</button>
                        </div>

                        <label>New Password</label>
                        <div class="profile-password-wrap">
                            <input type="password"
                                   name="newPassword"
                                   id="newPassword"
                                   placeholder="Enter new password"
                                   required>

                            <button type="button" onclick="toggleProfilePassword('newPassword', this)">👁</button>
                        </div>

                        <label>Confirm New Password</label>
                        <div class="profile-password-wrap">
                            <input type="password"
                                   name="confirmPassword"
                                   id="confirmPassword"
                                   placeholder="Confirm new password"
                                   required>

                            <button type="button" onclick="toggleProfilePassword('confirmPassword', this)">👁</button>
                        </div>

                        <div class="profile-security-note">
                            Use at least 6 characters. Avoid using obvious passwords such as your name or phone number.
                        </div>

                        <button type="submit" class="profile-main-btn warning">
                            Change Password
                        </button>
                    </form>
                </div>

            </section>

        </div>

    </main>

</div>

<script>
    function validateProfileForm() {
        const fullName = document.getElementById("fullName").value.trim();
        const email = document.getElementById("email").value.trim();
        const phone = document.getElementById("phone").value.trim();

        if (fullName.length < 2) {
            alert("Full name must be at least 2 characters.");
            return false;
        }

        if (!email.includes("@")) {
            alert("Please enter a valid email address.");
            return false;
        }

        if (phone && !/^0[17][0-9]{8}$/.test(phone)) {
            alert("Phone number should look like 0712345678 or 0112345678.");
            return false;
        }

        return true;
    }

    function validatePasswordForm() {
        const newPassword = document.getElementById("newPassword").value;
        const confirmPassword = document.getElementById("confirmPassword").value;

        if (newPassword.length < 6) {
            alert("New password must be at least 6 characters.");
            return false;
        }

        if (newPassword !== confirmPassword) {
            alert("New password and confirmation do not match.");
            return false;
        }

        return true;
    }

    function toggleProfilePassword(inputId, btn) {
        const input = document.getElementById(inputId);

        if (input.type === "password") {
            input.type = "text";
            btn.innerText = "🙈";
        } else {
            input.type = "password";
            btn.innerText = "👁";
        }
    }
</script>

</body>
</html>