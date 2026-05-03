<%@ page import="java.sql.*, com.agribridgef1.util.DBConnection" %>
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

    double amount = 0;
    double deliveryFee = 0;

    String orderStatus = "PENDING";
    String deliveryZone = "Not selected";
    String deliveryAddress = "Not provided";
    String phone = "";
    String notes = "";
    String orderDate = "Date unavailable";
    String customerName = "Customer";
    String customerEmail = "Not provided";

    boolean orderFound = false;

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        conn = DBConnection.getConnection();

        String orderSql = "SELECT * FROM orders WHERE order_id = ? AND user_id = ?";
        ps = conn.prepareStatement(orderSql);
        ps.setInt(1, orderId);
        ps.setInt(2, userId);

        rs = ps.executeQuery();

        if (rs.next()) {
            orderFound = true;

            try { amount = rs.getDouble("total_amount"); } catch (Exception e) {}
            try { deliveryFee = rs.getDouble("delivery_fee"); } catch (Exception e) {}
            try { orderStatus = rs.getString("order_status"); } catch (Exception e) {}
            try { deliveryZone = rs.getString("delivery_zone"); } catch (Exception e) {}
            try { deliveryAddress = rs.getString("delivery_address"); } catch (Exception e) {}
            try { phone = rs.getString("phone"); } catch (Exception e) {}
            try { notes = rs.getString("notes"); } catch (Exception e) {}
            try { orderDate = rs.getString("order_date"); } catch (Exception e) {}
            try { orderDate = rs.getString("created_at"); } catch (Exception e) {}
        }

        if (rs != null) try { rs.close(); } catch (Exception e) {}
        if (ps != null) try { ps.close(); } catch (Exception e) {}

        try {
            String userSql = "SELECT * FROM users WHERE user_id = ?";
            ps = conn.prepareStatement(userSql);
            ps.setInt(1, userId);
            rs = ps.executeQuery();

            if (rs.next()) {
                try { customerName = rs.getString("full_name"); } catch (Exception e) {}
                try { customerEmail = rs.getString("email"); } catch (Exception e) {}
            }
        } catch (Exception e) {
            // keep fallback values
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

    if (orderStatus == null || orderStatus.trim().isEmpty()) {
        orderStatus = "PENDING";
    }

    if (deliveryZone == null || deliveryZone.trim().isEmpty()) {
        deliveryZone = "Not selected";
    }

    if (deliveryAddress == null || deliveryAddress.trim().isEmpty()) {
        deliveryAddress = "Not provided";
    }

    if (phone == null) {
        phone = "";
    }

    String error = request.getParameter("error");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Payment - Egerton AgriBridge Hub</title>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/style.css">
</head>

<body class="payment-premium-body">

<div class="payment-nav">
    <div class="payment-logo">Egerton AgriBridge Hub</div>

    <div class="payment-nav-links">
        <a href="index.jsp">Home</a>
        <a href="products.jsp">Marketplace</a>
        <a href="cart.jsp">Cart</a>
        <a href="myOrders.jsp">My Orders</a>
        <a href="logout">Logout</a>
    </div>
</div>

<div class="payment-premium-page">

    <div class="payment-breadcrumb">
        <a href="products.jsp">MARKETPLACE</a>
        <span>›</span>
        <a href="myOrders.jsp">MY ORDERS</a>
        <span>›</span>
        <strong>PAYMENT</strong>
    </div>

    <div class="payment-premium-header">
        <div>
            <p class="eyebrow">SECURE CHECKOUT</p>
            <h1>Complete Payment</h1>
            <p>Choose how you would like to pay for Order #<%= orderId %>.</p>
        </div>

        <div class="payment-total-box">
            <span>Total Amount</span>
            <strong>KES <%= String.format("%.2f", amount) %></strong>
        </div>
    </div>

    <% if ("phone".equals(error)) { %>
        <div class="review-error">
            Invalid phone number. Use 07XXXXXXXX or 01XXXXXXXX.
        </div>
    <% } else if ("mpesa".equals(error)) { %>
        <div class="review-error">
            M-Pesa request failed. Please check your phone number, internet connection, or Daraja credentials.
        </div>
    <% } else if (error != null) { %>
        <div class="review-error">
            Payment request failed. Please try again.
        </div>
    <% } %>

    <div class="payment-premium-layout">

        <!-- LEFT: PAYMENT METHODS -->
        <section class="payment-method-panel">

            <div class="payment-section-title">
                <h2>Payment Method</h2>
                <p>Select your preferred payment option.</p>
            </div>

            <!-- MPESA -->
            <div class="premium-payment-card selected" id="mpesaCard" onclick="selectPayment('mpesa')">

                <div class="premium-payment-card-head">
                    <div class="premium-payment-icon mpesa">M</div>

                    <div>
                        <h3>Pay with M-Pesa</h3>
                        <p>Receive an STK Push prompt and enter your PIN on your phone.</p>
                    </div>

                    <div class="premium-radio"></div>
                </div>

                <div class="premium-payment-inner" id="mpesaForm" onclick="event.stopPropagation();">
                    <form action="mpesaSTKPush" method="post" onsubmit="return validateMpesaPhone();">
                        <input type="hidden" name="orderId" value="<%= orderId %>">
                        <input type="hidden" name="amount" value="<%= amount %>">

                        <label>Safaricom Phone Number</label>

                        <div class="payment-phone-row">
                            <div>
                                <input type="text"
                                       name="phone"
                                       id="mpesaPhone"
                                       placeholder="07XXXXXXXX or 01XXXXXXXX"
                                       pattern="0[17][0-9]{8}"
                                       value="<%= phone %>"
                                       title="Enter phone number in format 07XXXXXXXX or 01XXXXXXXX"
                                       required>

                                <small>
                                    Use the phone number that will receive the M-Pesa STK Push.
                                </small>
                            </div>

                            <button class="payment-primary-btn" type="submit">
                                Send STK Push
                            </button>
                        </div>

                        <div class="payment-security-note">
                            🔒 You will authorize payment securely from your phone using your M-Pesa PIN.
                        </div>
                    </form>
                </div>
            </div>

            <!-- CASH ON DELIVERY -->
            <div class="premium-payment-card" id="codCard" onclick="selectPayment('cod')">

                <div class="premium-payment-card-head">
                    <div class="premium-payment-icon cash">KES</div>

                    <div>
                        <h3>Cash on Delivery</h3>
                        <p>Pay when your products are delivered or collected.</p>
                    </div>

                    <div class="premium-radio"></div>
                </div>

                <div class="premium-payment-inner" id="codForm" onclick="event.stopPropagation();">
                    <form action="payment" method="post">
                        <input type="hidden" name="orderId" value="<%= orderId %>">
                        <input type="hidden" name="amount" value="<%= amount %>">
                        <input type="hidden" name="method" value="CASH_ON_DELIVERY">

                        <div class="payment-security-note warning">
                            Cash on Delivery will keep your payment status as pending until staff confirms payment.
                        </div>

                        <button class="payment-secondary-btn" type="submit">
                            Confirm Cash on Delivery
                        </button>
                    </form>
                </div>
            </div>

        </section>

        <!-- RIGHT: CUSTOMER / ORDER DETAILS -->
        <aside class="payment-customer-panel">

            <div class="payment-customer-card">
                <p class="eyebrow">CUSTOMER DETAILS</p>

                <div class="payment-customer-profile">
                    <div class="payment-avatar">👤</div>

                    <div>
                        <h3><%= customerName != null && !customerName.trim().isEmpty() ? customerName : "Customer" %></h3>
                        <p><%= customerEmail != null && !customerEmail.trim().isEmpty() ? customerEmail : "Email not provided" %></p>
                    </div>
                </div>

                <div class="payment-detail-list">
                    <div>
                        <span>Order Number</span>
                        <strong>#<%= orderId %></strong>
                    </div>

                    <div>
                        <span>Order Status</span>
                        <strong><%= orderStatus.replace("_", " ") %></strong>
                    </div>

                    <div>
                        <span>Phone Number</span>
                        <strong><%= phone != null && !phone.trim().isEmpty() ? phone : "Not provided" %></strong>
                    </div>

                    <div>
                        <span>Delivery Zone</span>
                        <strong><%= deliveryZone %></strong>
                    </div>

                    <div>
                        <span>Delivery Fee</span>
                        <strong>KES <%= String.format("%.2f", deliveryFee) %></strong>
                    </div>

                    <div>
                        <span>Order Date</span>
                        <strong><%= orderDate != null && !orderDate.trim().isEmpty() ? orderDate : "Date unavailable" %></strong>
                    </div>
                </div>
            </div>

            <div class="payment-fulfilment-card">
                <h3>Fulfilment Details</h3>

                <p>
                    <strong>Address / Pickup:</strong><br>
                    <%= deliveryAddress %>
                </p>

                <% if (notes != null && !notes.trim().isEmpty()) { %>
                    <p>
                        <strong>Notes:</strong><br>
                        <%= notes %>
                    </p>
                <% } %>
            </div>

            <div class="payment-summary-card">
                <h3>Payment Summary</h3>

                <div>
                    <span>Total Due</span>
                    <strong>KES <%= String.format("%.2f", amount) %></strong>
                </div>

                <a href="orderDetails.jsp?orderId=<%= orderId %>">
                    View Order Details
                </a>
            </div>

        </aside>

    </div>

</div>

<script>
    function selectPayment(method) {
        const mpesaCard = document.getElementById("mpesaCard");
        const codCard = document.getElementById("codCard");

        mpesaCard.classList.remove("selected");
        codCard.classList.remove("selected");

        if (method === "mpesa") {
            mpesaCard.classList.add("selected");
        }

        if (method === "cod") {
            codCard.classList.add("selected");
        }
    }

    function validateMpesaPhone() {
        const phone = document.getElementById("mpesaPhone").value.trim();

        if (!/^0[17][0-9]{8}$/.test(phone)) {
            alert("Please enter a valid Safaricom number such as 0712345678 or 0112345678.");
            return false;
        }

        return true;
    }
</script>

</body>
</html>