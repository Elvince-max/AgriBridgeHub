<%@ page import="java.util.*, com.agribridgef1.dao.*, com.agribridgef1.model.Product" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    boolean loggedIn = session.getAttribute("userId") != null;

    ProductDAO dao = new ProductDAO();
    CategoryDAO categoryDAO = new CategoryDAO();

    String keyword = request.getParameter("search");
    String categoryParam = request.getParameter("category");

    List<Product> products;

    if (categoryParam != null && !categoryParam.isEmpty()) {
        int categoryId = Integer.parseInt(categoryParam);
        products = dao.getProductsByCategory(categoryId);
    } else if (keyword != null && !keyword.trim().isEmpty()) {
        products = dao.searchProducts(keyword);
    } else {
        products = dao.getAllProducts();
    }

    Map<Integer, String> categories = categoryDAO.getAllCategories();

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
    <title>Marketplace - Egerton AgriBridge Hub</title>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/style.css">
</head>

<body class="market-body">

<!-- NAVBAR -->
<div class="market-navbar">
    <div class="market-logo">EgertonAgriBridgeHub</div>

    <div class="market-nav-links">
        <a href="index.jsp" class="active">Home</a>
        <a href="products.jsp" class="active">Market Place</a>
        <a href="index.jsp#heritage">Farmer Stories</a>
        <a href="index.jsp#process">Process</a>
        <a href="index.jsp#heritage">Support</a>
    </div>

    <div class="market-nav-right">
        <form method="get" action="products.jsp" class="market-search">
            <input type="text"
                   name="search"
                   placeholder="Search dairy..."
                   value="<%= keyword != null ? keyword : "" %>">
            <button type="submit">⌕</button>
        </form>

        <a class="market-icon" href="cart.jsp">
            🛒
            <span id="cartCountBadge" class="<%= cartCount > 0 ? "" : "hidden" %>">
                <%= cartCount %>
            </span>
        </a>

        <% if (loggedIn) { %>
            <a class="market-icon" href="myOrders.jsp">☻</a>
        <% } else { %>
            <a class="market-icon" href="login.jsp">☻</a>
        <% } %>
    </div>
</div>

<!-- HEADER -->
<section class="market-header">
    <h1>The Dairy Collection</h1>
    <p>
        Fresh from the pastures of Egerton University. Our dairy products represent
        the pinnacle of heritage farming and modern quality standards.
    </p>
</section>

<!-- CATEGORY TABS -->
<div class="market-tabs">

    <a class="<%= (categoryParam == null || categoryParam.isEmpty()) ? "active" : "" %>"
       href="products.jsp">
       All Products
    </a>

    <%
        for (Map.Entry<Integer, String> entry : categories.entrySet()) {
            String activeClass = "";

            if (categoryParam != null && categoryParam.equals(String.valueOf(entry.getKey()))) {
                activeClass = "active";
            }
    %>
        <a class="<%= activeClass %>"
           href="products.jsp?category=<%= entry.getKey() %>">
           <%= entry.getValue() %>
        </a>
    <%
        }
    %>

</div>

<!-- PRODUCTS -->
<section class="market-products">

    <%
        if (products.isEmpty()) {
    %>

        <div class="market-empty">
            <h2>No products found</h2>
            <p>Try searching another product or selecting a different category.</p>
            <a href="products.jsp">View All Products</a>
        </div>

    <%
        } else {
            for (Product p : products) {
                String stockLabel;
                String stockClass;

                if (p.getStockQuantity() <= 0) {
                    stockLabel = "OUT OF STOCK";
                    stockClass = "out";
                } else if (p.getStockQuantity() >= 1 && p.getStockQuantity() <= 5) {
                    stockLabel = "LOW STOCK";
                    stockClass = "low";
                } else {
                    stockLabel = "IN STOCK";
                    stockClass = "in";
                }
    %>

        <div class="market-product-card">

            <div class="market-product-image">
                <%
                    if (p.getImageUrl() != null && !p.getImageUrl().isEmpty()) {
                %>
                    <img src="<%= request.getContextPath() + "/" + p.getImageUrl() %>"
                         alt="<%= p.getProductName() %>">
                <%
                    } else {
                %>
                    <div class="market-no-image">No Image</div>
                <%
                    }
                %>

                <span class="market-stock <%= stockClass %>">
                    <%= stockLabel %>
                </span>
            </div>

            <div class="market-product-info">
                <h3><%= p.getProductName() %></h3>

                <p class="market-desc">
                    <%= p.getDescription() %>
                </p>

                <p class="market-price">
                    KES <%= String.format("%.2f", p.getPrice()) %>
                    <span>/ item</span>
                </p>

                <div class="market-card-actions">
                    <a class="market-details-btn"
                       href="productDetails.jsp?id=<%= p.getProductId() %>">
                        View Details
                    </a>

                    <%
                        if (p.getStockQuantity() <= 0) {
                    %>
                        <button class="market-cart-btn disabled" disabled>
                            Out of Stock
                        </button>
                    <%
                        } else if (loggedIn) {
                    %>
                        <a class="market-cart-btn"
                           href="cart?id=<%= p.getProductId() %>"
                           onclick="addToCart(event, this)"
                           data-price="<%= p.getPrice() %>">
                            🛒 Add to Cart
                        </a>
                    <%
                        } else {
                    %>
                        <a class="market-cart-btn"
                           href="login.jsp">
                            Login to Buy
                        </a>
                    <%
                        }
                    %>
                </div>
            </div>

        </div>

    <%
            }
        }
    %>

</section>

<!-- CHECKOUT STRIP -->
<section class="market-checkout-strip">
    <div>
        <h2>Swift M-Pesa Checkout</h2>
        <p>
            Experience seamless transactions with integrated M-Pesa STK Push.
            Fast, secure, and direct from your phone.
        </p>
    </div>

    <div class="market-checkout-box">
        <span>Cart Total</span>
        <h3 id="cartTotalText">KES <%= String.format("%.2f", cartTotal) %></h3>

        <%
            if (!loggedIn) {
        %>
            <a href="login.jsp">Login</a>
        <%
            } else {
        %>
            <a id="checkoutBtn"
               href="cart.jsp"
               class="<%= cartTotal > 0 ? "" : "disabled-checkout" %>">
               <%= cartTotal > 0 ? "Pay Now" : "Add Items" %>
            </a>
        <%
            }
        %>
    </div>
</section>

<!-- FOOTER -->
<footer class="market-footer">
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

    <div class="market-footer-icons">
        🌿 🚜 🚚
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
        link.innerHTML = "Adding...";
        link.style.pointerEvents = "none";

        fetch(url, {
            method: "GET"
        })
        .then(response => {
            if (response.ok) {
                cartCount++;
                cartTotal += price;

                const badge = document.getElementById("cartCountBadge");
                const totalText = document.getElementById("cartTotalText");
                const checkoutBtn = document.getElementById("checkoutBtn");

                badge.innerText = cartCount;
                badge.classList.remove("hidden");

                totalText.innerText = "KES " + cartTotal.toFixed(2);

                if (checkoutBtn) {
                    checkoutBtn.innerText = "Pay Now";
                    checkoutBtn.classList.remove("disabled-checkout");
                }

                link.innerHTML = "Added ✓";

                setTimeout(() => {
                    link.innerHTML = originalText;
                    link.style.pointerEvents = "auto";
                }, 1000);

            } else {
                link.innerHTML = "Try Again";
                link.style.pointerEvents = "auto";
            }
        })
        .catch(error => {
            console.log(error);
            link.innerHTML = "Try Again";
            link.style.pointerEvents = "auto";
        });
    }
</script>

</body>
</html>