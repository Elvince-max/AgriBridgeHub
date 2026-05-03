<%@ page import="java.util.*, com.agribridgef1.dao.ProductDAO, com.agribridgef1.model.Product" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    boolean loggedIn = session.getAttribute("userId") != null;

    if (!loggedIn) {
        response.sendRedirect("login.jsp");
        return;
    }

    ProductDAO dao = new ProductDAO();

    Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute("cart");

    if (cart == null) {
        cart = new HashMap<>();
        session.setAttribute("cart", cart);
    }

    double subtotal = 0;
    int cartCount = 0;

    List<Product> cartProducts = new ArrayList<>();

    for (Map.Entry<Integer, Integer> entry : cart.entrySet()) {
        Product product = dao.getProductById(entry.getKey());

        if (product != null) {
            cartProducts.add(product);

            int quantity = entry.getValue();
            subtotal += product.getPrice() * quantity;
            cartCount += quantity;
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Your Cart - Egerton AgriBridge Hub</title>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/style.css">
</head>

<body class="cart-body">

<!-- NAVBAR -->
<div class="cart-navbar">
    <div class="cart-logo">EgertonAgriBridgeHub</div>

    <div class="cart-nav-links">
        <a href="index.jsp" class="active">Home</a>
        <a href="products.jsp">Marketplace</a>
        <a href="index.jsp#heritage">Farmer Stories</a>
        <a href="index.jsp#process">Process</a>
        <a href="index.jsp#heritage">Support</a>
    </div>

    <div class="cart-nav-right">
        <a class="cart-icon active" href="cart.jsp">
            🛒
            <% if (cartCount > 0) { %>
                <span><%= cartCount %></span>
            <% } %>
        </a>

        <a class="cart-icon" href="myOrders.jsp">☻</a>
    </div>
</div>

<div class="cart-page">

    <div class="cart-breadcrumb">
        <a href="products.jsp">MARKETPLACE</a>
        <span>›</span>
        <strong>SHOPPING CART</strong>
    </div>

    <h1>Your Harvest Basket</h1>

    <% if (cartProducts.isEmpty()) { %>

        <div class="cart-empty-state">
            <div class="cart-empty-icon">🧺</div>
            <h2>Your basket is empty</h2>
            <p>Browse fresh dairy products and add items to begin checkout.</p>
            <a href="products.jsp">Continue Shopping</a>
        </div>

    <% } else { %>

        <div class="cart-layout">

            <!-- CART ITEMS -->
            <div class="cart-items-card">

                <div class="cart-table-head">
                    <span>Product</span>
                    <span>Quantity</span>
                    <span>Price</span>
                    <span>Subtotal</span>
                </div>

                <%
                    for (Product p : cartProducts) {
                        int quantity = cart.get(p.getProductId());
                        double itemSubtotal = p.getPrice() * quantity;
                %>

                    <div class="cart-item">

                        <div class="cart-product-cell">
                            <% if (p.getImageUrl() != null && !p.getImageUrl().isEmpty()) { %>
                                <img src="<%= request.getContextPath() + "/" + p.getImageUrl() %>"
                                     alt="<%= p.getProductName() %>">
                            <% } else { %>
                                <div class="cart-no-image">No Image</div>
                            <% } %>

                            <div>
                                <h3><%= p.getProductName() %></h3>
                                <p><%= p.getDescription() %></p>

                                <% if (quantity >= p.getStockQuantity()) { %>
                                    <small class="cart-stock-warning">
                                        Maximum available stock selected
                                    </small>
                                <% } %>

                                <a class="cart-remove"
                                   href="cart?action=remove&id=<%= p.getProductId() %>"
                                   onclick="return confirm('Remove this item from cart?');">
                                    🗑 Remove
                                </a>
                            </div>
                        </div>

                        <div class="cart-quantity-cell">
                            <a href="cart?action=decrease&id=<%= p.getProductId() %>">−</a>
                            <strong><%= quantity %></strong>

                            <% if (quantity < p.getStockQuantity()) { %>
                                <a href="cart?action=increase&id=<%= p.getProductId() %>">+</a>
                            <% } else { %>
                                <span class="qty-disabled">+</span>
                            <% } %>
                        </div>

                        <div class="cart-price-cell">
                            KES <%= String.format("%.2f", p.getPrice()) %>
                        </div>

                        <div class="cart-subtotal-cell">
                            KES <%= String.format("%.2f", itemSubtotal) %>
                        </div>

                    </div>

                <%
                    }
                %>

            </div>

            <!-- SUMMARY -->
            <div class="cart-summary-card">
                <h2>Cart Total</h2>

                <div class="summary-row">
                    <span>Subtotal</span>
                    <strong>KES <%= String.format("%.2f", subtotal) %></strong>
                </div>

                <div class="summary-row">
                    <span>Delivery / Pickup</span>
                    <strong>Selected at checkout</strong>
                </div>

                <small class="cart-estimate-note">
                    Choose campus pickup or a delivery zone during checkout.
                </small>

                <hr>

                <div class="summary-total">
                    <span>Total before delivery</span>
                    <strong>KES <%= String.format("%.2f", subtotal) %></strong>
                </div>

                <a class="checkout-main-btn" href="checkout.jsp">
                    Proceed to Checkout 💵
                </a>

                <div class="mpesa-checkout-note">
                    <div>M</div>
                    <div>
                        <h4>M-Pesa Direct Checkout</h4>
                        <p>Securely pay via M-Pesa STK Push after confirming pickup or delivery.</p>
                    </div>
                </div>

                <div class="cart-security-icons">
                    <span>🛡️</span>
                    <span>🔒</span>
                    <span>✅</span>
                </div>
            </div>

        </div>

        <div class="cart-bottom-actions">
            <a href="products.jsp">← Continue Shopping</a>

            <a href="cart?action=clear"
               onclick="return confirm('Empty your entire cart?');">
                🗑 Empty Cart
            </a>
        </div>

    <% } %>

</div>

<footer class="cart-footer">
    <div>
        <h3>EgertonAgriBridgeHub</h3>
        <p>© 2024 EgertonAgriBridgeHub. Modern pastoral excellence.</p>
    </div>

    <div>
        <a href="#">Privacy Policy</a>
        <a href="#">Terms of Service</a>
        <a href="login.jsp">Farmer Login</a>
        <a href="#">Sustainability Report</a>
    </div>
</footer>

</body>
</html>