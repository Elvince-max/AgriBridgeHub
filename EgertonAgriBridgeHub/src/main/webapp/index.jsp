<%@ page import="java.util.*, com.agribridgef1.dao.ProductDAO, com.agribridgef1.model.Product" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    boolean loggedIn = session.getAttribute("userId") != null;

    String userType = (String) session.getAttribute("userType");

    if (userType == null) {
        userType = "";
    }

    userType = userType.trim().toUpperCase();

    boolean isCustomer = loggedIn && "CUSTOMER".equals(userType);
    boolean isAdmin = loggedIn && ("ADMIN".equals(userType) || "STAFF".equals(userType));
    boolean isDeliveryAgent = loggedIn && "DELIVERY_AGENT".equals(userType);

    String dashboardLink = "products.jsp";

    if (isCustomer) {
        dashboardLink = "customerDashboard.jsp";
    } else if (isAdmin) {
        dashboardLink = "adminDashboard.jsp";
    } else if (isDeliveryAgent) {
        dashboardLink = "delivery.jsp";
    }

    ProductDAO dao = new ProductDAO();
    List<Product> products = dao.getAllProducts();

    double cartTotal = 0;
    int cartCount = 0;

    Object cartObject = session.getAttribute("cart");

    if (cartObject instanceof Map) {
        Map<Integer, Integer> cart = (Map<Integer, Integer>) cartObject;

        for (Map.Entry<Integer, Integer> entry : cart.entrySet()) {
            Product cartProduct = dao.getProductById(entry.getKey());

            if (cartProduct != null) {
                int quantity = entry.getValue();
                cartTotal += cartProduct.getPrice() * quantity;
                cartCount += quantity;
            }
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Egerton AgriBridge Hub</title>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/style.css?v=4">
</head>
<body class="landing-body">

<!-- NAVBAR -->
<div class="landing-navbar">
    <div class="landing-logo">EgertonAgriBridgeHub</div>

    <div class="landing-links">
        <a href="index.jsp" class="active">Home</a>
        <a href="products.jsp">Marketplace</a>
        <a href="#process">Process</a>
        <a href="#heritage">About</a>

        <% if (loggedIn) { %>

            <a href="<%= dashboardLink %>">Dashboard</a>

            <% if (isCustomer) { %>
                <a href="cart.jsp" class="landing-cart-link">
                    Cart
                    <span id="cartCountBadge" class="<%= cartCount > 0 ? "" : "hidden" %>">
                        <%= cartCount %>
                    </span>
                </a>

                <a href="myOrders.jsp">My Orders</a>

            <% } else if (isAdmin) { %>
                <a href="manageProducts.jsp">Products</a>
                <a href="manageOrders.jsp">Orders</a>

            <% } else if (isDeliveryAgent) { %>
                <a href="delivery.jsp">My Deliveries</a>
            <% } %>

            <a href="logout">Logout</a>

        <% } else { %>

            <a href="login.jsp">Login</a>
            <a href="register.jsp">Register</a>

        <% } %>
    </div>
</div>

<!-- HERO -->
<section class="hero-section">
    <div class="hero-content">
        <p class="eyebrow">FARM TO TABLE, DIGITALLY</p>
        <h1>Fresh Dairy,<br>From Farm to Table</h1>
        <p class="hero-text">
            Premium Egerton dairy products, crafted with care and delivered to your door
            through a clean, traceable digital ordering experience.
        </p>

        <div class="hero-actions">
            <a class="landing-btn" href="products.jsp">Shop Now →</a>

            <% if (loggedIn) { %>
                <a class="landing-btn light" href="<%= dashboardLink %>">Go to Dashboard</a>
            <% } else { %>
                <a class="landing-btn light" href="#process">How It Works</a>
            <% } %>
        </div>

        <div class="hero-benefits">
            <div>
                <span>🌿</span>
                <h4>Estate Fresh</h4>
                <p>Sourced from our trusted farms.</p>
            </div>

            <div>
                <span>🛡️</span>
                <h4>Quality Assured</h4>
                <p>Tested for premium quality.</p>
            </div>

            <div>
                <span>🚚</span>
                <h4>Delivered Fresh</h4>
                <p>Cold-chain delivery care.</p>
            </div>
        </div>
    </div>

    <div class="hero-image-card">
        <img src="<%= request.getContextPath() %>/uploads/milking man.jpg" alt="Fresh dairy product">
    </div>
</section>

<!-- FEATURED PRODUCTS -->
<section class="landing-section" id="products">
    <div class="section-heading">
        <div>
            <p class="eyebrow">PREMIUM SELECTION</p>
            <h2>Direct from the Estate</h2>
        </div>

        <a href="products.jsp">View Marketplace →</a>
    </div>

    <div class="featured-grid">
        <%
            int count = 0;
            for (Product p : products) {
                if (count >= 3) break;
                count++;

                String stockLabel;
                String stockClass;

                if (p.getStockQuantity() <= 0) {
                    stockLabel = "OUT OF STOCK";
                    stockClass = "out";
                } else if (p.getStockQuantity() >= 1 && p.getStockQuantity() <= 5) {
                    stockLabel = "LOW STOCK";
                    stockClass = "low";
                } else {
                    stockLabel = "FRESH";
                    stockClass = "in";
                }
        %>

        <div class="featured-card">
            <div class="product-badge <%= stockClass %>">
                <%= stockLabel %>
            </div>

            <% if (p.getImageUrl() != null && !p.getImageUrl().isEmpty()) { %>
                <img src="<%= request.getContextPath() + "/" + p.getImageUrl() %>"
                     alt="<%= p.getProductName() %>">
            <% } else { %>
                <div class="image-placeholder">No Image</div>
            <% } %>

            <div class="featured-info">
                <h3><%= p.getProductName() %></h3>
                <p><%= p.getDescription() %></p>

                <div class="featured-bottom">
                    <strong>KES <%= String.format("%.2f", p.getPrice()) %></strong>

                    <div class="featured-actions">
                        <a class="featured-details-btn"
                           href="productDetails.jsp?id=<%= p.getProductId() %>">
                            Details
                        </a>

                        <% if (p.getStockQuantity() <= 0) { %>
                            <button class="featured-cart-btn disabled" disabled>
                                🛒
                            </button>
                        <% } else if (loggedIn && isCustomer) { %>
                            <a class="featured-cart-btn"
                               href="cart?id=<%= p.getProductId() %>"
                               onclick="addToCart(event, this)"
                               data-price="<%= p.getPrice() %>">
                                🛒
                            </a>
                        <% } else if (loggedIn && !isCustomer) { %>
                            <a class="featured-cart-btn" href="<%= dashboardLink %>" title="Go to dashboard">
                                🛒
                            </a>
                        <% } else { %>
                            <a class="featured-cart-btn" href="login.jsp">
                                🛒
                            </a>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>

        <%
            }
        %>
    </div>
</section>

<!-- PROCESS -->
<section class="process-section" id="process">
    <p class="eyebrow center">OUR PROCESS</p>
    <h2>Farm-to-Table Efficiency</h2>
    <p class="process-intro">
        A seamless digital experience connecting you directly to fresh, safe and nutritious dairy.
    </p>

    <div class="process-grid">
        <div class="process-card">
            <div class="process-icon">🔍</div>
            <span>1</span>
            <h3>Browse</h3>
            <p>Explore milk, yoghurt, cheese, butter and more from trusted Egerton sources.</p>
        </div>

        <div class="process-card highlight">
            <div class="process-icon">💳</div>
            <span>2</span>
            <h3>Order & Pay</h3>
            <p>Checkout securely using M-Pesa STK Push or cash on delivery.</p>
        </div>

        <div class="process-card">
            <div class="process-icon">🚚</div>
            <span>3</span>
            <h3>Delivered</h3>
            <p>Your order is assigned, tracked and delivered fresh to your location.</p>
        </div>
    </div>
</section>

<!-- HERITAGE -->
<section class="heritage-section" id="heritage">
    <div class="heritage-panel">
        <p class="eyebrow gold">OUR HERITAGE</p>
        <h2>Egerton. Heritage in Every Drop.</h2>
        <p>
            Egerton AgriBridge Hub connects customers to trusted agricultural products
            through a modern digital marketplace. Starting with dairy, the platform
            brings together product ordering, payment, delivery and management in one system.
        </p>

        <div class="heritage-stats">
            <div>
                <h3>80+</h3>
                <p>Years of Excellence</p>
            </div>

            <div>
                <h3>100%</h3>
                <p>Estate Sourced</p>
            </div>

            <div>
                <h3>24/7</h3>
                <p>Digital Access</p>
            </div>
        </div>
    </div>

    <div class="heritage-image">
        <img src="<%= request.getContextPath() %>/uploads/egerton gate.jpg" alt="Egerton farm landscape">
        <div class="quality-card">
            <h3>Guaranteed Quality</h3>
            <p>Every product is handled with care for freshness, safety and trust.</p>
        </div>
    </div>
</section>

<!-- FOOTER -->
<footer class="landing-footer">
    <div>
        <h3>EgertonAgriBridgeHub</h3>
        <p>Bridging farm to table, digitally.</p>
    </div>

    <div class="footer-links">
        <a href="products.jsp">Marketplace</a>

        <% if (loggedIn) { %>
            <a href="<%= dashboardLink %>">Dashboard</a>
            <a href="logout">Logout</a>
        <% } else { %>
            <a href="login.jsp">Login</a>
            <a href="register.jsp">Register</a>
        <% } %>

        <a href="#">Privacy Policy</a>
        <a href="#">Terms of Service</a>
    </div>
</footer>

<script>
    let cartCount = <%= cartCount %>;
    let cartTotal = <%= cartTotal %>;

    function addToCart(event, link) {
        event.preventDefault();

        const url = link.getAttribute("href");
        const price = parseFloat(link.getAttribute("data-price"));

        const originalText = link.innerHTML;
        link.innerHTML = "✓";
        link.style.pointerEvents = "none";

        fetch(url, {
            method: "GET"
        })
        .then(response => {
            if (response.ok) {
                cartCount++;
                cartTotal += price;

                const badge = document.getElementById("cartCountBadge");

                if (badge) {
                    badge.innerText = cartCount;
                    badge.classList.remove("hidden");
                }

                setTimeout(() => {
                    link.innerHTML = originalText;
                    link.style.pointerEvents = "auto";
                }, 900);

            } else {
                link.innerHTML = "!";
                link.style.pointerEvents = "auto";
            }
        })
        .catch(error => {
            console.log(error);
            link.innerHTML = "!";
            link.style.pointerEvents = "auto";
        });
    }
</script>

</body>
</html>