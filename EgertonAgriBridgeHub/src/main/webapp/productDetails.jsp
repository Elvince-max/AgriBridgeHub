<%@ page import="java.util.*, com.agribridgef1.dao.ProductDAO, com.agribridgef1.dao.ReviewDAO, com.agribridgef1.model.Product, com.agribridgef1.model.Review" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    boolean loggedIn = session.getAttribute("userId") != null;

    String idParam = request.getParameter("id");

    if (idParam == null || idParam.trim().isEmpty()) {
        response.sendRedirect("products.jsp");
        return;
    }

    int productId = Integer.parseInt(idParam);

    ProductDAO dao = new ProductDAO();
    Product product = dao.getProductById(productId);

    if (product == null) {
        response.sendRedirect("products.jsp");
        return;
    }

    List<Product> allProducts = dao.getAllProducts();

    ReviewDAO reviewDAO = new ReviewDAO();
    List<Review> reviews = reviewDAO.getReviewsByProductId(productId);
    double averageRating = reviewDAO.getAverageRating(productId);

    String stockLabel;
    String stockClass;

    if (product.getStockQuantity() <= 0) {
        stockLabel = "OUT OF STOCK";
        stockClass = "out";
    } else if (product.getStockQuantity() >= 1 && product.getStockQuantity() <= 5) {
        stockLabel = "LOW STOCK";
        stockClass = "low";
    } else {
        stockLabel = "IN STOCK";
        stockClass = "in";
    }

    String imageUrl = product.getImageUrl();

    if (imageUrl == null || imageUrl.trim().isEmpty()) {
        imageUrl = "";
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title><%= product.getProductName() %> - Egerton AgriBridge Hub</title>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/style.css">
</head>

<body class="product-detail-body">

<!-- NAVBAR -->
<div class="product-detail-navbar">
    <div class="product-detail-logo">EgertonAgriBridgeHub</div>

    <div class="product-detail-links">
        <a href="products.jsp" class="active">Products</a>
        <a href="index.jsp#heritage">Farms</a>
        <a href="index.jsp#process">Process</a>

        <% if (loggedIn) { %>
            <a href="cart.jsp">Cart</a>
            <a href="myOrders.jsp">My Orders</a>
            <a href="logout">Logout</a>
        <% } else { %>
            <a href="login.jsp">Login</a>
            <a href="register.jsp">Register</a>
        <% } %>
    </div>
</div>

<div class="product-detail-container">

    <!-- BREADCRUMB -->
    <div class="product-breadcrumb">
        <a href="products.jsp">SHOP</a>
        <span>›</span>
        <a href="products.jsp">DAIRY</a>
        <span>›</span>
        <strong><%= product.getProductName().toUpperCase() %></strong>
    </div>

    <!-- MAIN PRODUCT SECTION -->
    <section class="product-detail-grid">

        <!-- LEFT IMAGE GALLERY -->
        <div class="product-gallery">

            <div class="product-main-image">
                <% if (!imageUrl.isEmpty()) { %>
                    <img id="mainProductImage"
                         src="<%= request.getContextPath() + "/" + imageUrl %>"
                         alt="<%= product.getProductName() %>">
                <% } else { %>
                    <div class="product-detail-no-image">
                        No Image Available
                    </div>
                <% } %>

                <div class="detail-floating-badges">
                    <span>FARM FRESH</span>
                    <span class="gold">BESTSELLER</span>
                </div>
            </div>

            <div class="product-thumbnails">
                <% if (!imageUrl.isEmpty()) { %>
                    <div class="thumb active" onclick="changeMainImage('<%= request.getContextPath() + "/" + imageUrl %>', this)">
                        <img src="<%= request.getContextPath() + "/" + imageUrl %>" alt="Product thumbnail">
                    </div>
                <% } %>

                <div class="thumb" onclick="changeMainImage('<%= request.getContextPath() %>/uploads/egerton gate.jpg', this)">
                    <img src="<%= request.getContextPath() %>/uploads/egerton gate.jpg" alt="Farm thumbnail">
                </div>

                <div class="thumb" onclick="changeMainImage('<%= request.getContextPath() %>/uploads/milking man.jpg', this)">
                    <img src="<%= request.getContextPath() %>/uploads/milking man.jpg" alt="Dairy thumbnail">
                </div>
            </div>

        </div>

        <!-- RIGHT PRODUCT DETAILS -->
        <div class="product-detail-info">

            <h1><%= product.getProductName() %></h1>

            <div class="detail-price-row">
                <span>KES <%= String.format("%.2f", product.getPrice()) %></span>
                <small>/ item</small>
            </div>

            <div class="detail-stock <%= stockClass %>">
                ● <%= stockLabel %>
            </div>

            <div class="purchase-panel">
                <p>
                    <%= product.getDescription() %>
                    This product is sourced with care and handled to maintain freshness,
                    safety, and quality from farm to table.
                </p>

                <label>Select Quantity</label>

                <div class="quantity-control">
                    <button type="button" onclick="decreaseQuantity()">−</button>

                    <input id="quantityInput"
                           type="number"
                           value="1"
                           min="1"
                           max="<%= product.getStockQuantity() %>"
                           readonly>

                    <button type="button" onclick="increaseQuantity(<%= product.getStockQuantity() %>)">+</button>
                </div>

                <% if (product.getStockQuantity() <= 0) { %>

                    <button class="detail-add-btn disabled" disabled>
                        Out of Stock
                    </button>

                <% } else if (loggedIn) { %>

                    <button class="detail-add-btn"
                            id="addToCartBtn"
                            onclick="addProductToCart(<%= product.getProductId() %>)">
                        🛒 Add to Cart
                    </button>

                    <button class="detail-buy-btn"
                            id="buyNowBtn"
                            onclick="buyNow(<%= product.getProductId() %>)">
                        Buy Now
                    </button>

                <% } else { %>

                    <a class="detail-add-btn link-btn" href="login.jsp">
                        Login to Add to Cart
                    </a>

                    <a class="detail-buy-btn link-btn" href="login.jsp">
                        Login to Buy
                    </a>

                <% } %>

                <div id="cartMessage" class="detail-cart-message hidden">
                    Product added to cart successfully.
                </div>
            </div>

            <div class="trust-grid">
                <div class="trust-card">
                    <div>🚚</div>
                    <h4>Swift Delivery</h4>
                    <p>Delivered carefully within the supported delivery zones.</p>
                </div>

                <div class="trust-card">
                    <div>🏅</div>
                    <h4>Farm Certified</h4>
                    <p>Tested and handled for safety, freshness and purity.</p>
                </div>
            </div>

            <div class="mpesa-mini-card">
                <div class="mpesa-logo-mini">M-PESA</div>

                <div>
                    <small>EXPRESS CHECKOUT</small>
                    <h4>Pay with M-Pesa</h4>
                </div>

                <span>›</span>
            </div>

        </div>
    </section>

    <!-- SPECIFICATIONS -->
    <section class="product-spec-section">
        <h2>Product Specifications</h2>

        <div class="spec-grid">

            <div class="spec-card">
                <h3>Nutritional Info</h3>

                <div class="spec-row">
                    <span>Energy</span>
                    <strong>64 kcal / 100ml</strong>
                </div>

                <div class="spec-row">
                    <span>Fat Content</span>
                    <strong>3.5% Min</strong>
                </div>

                <div class="spec-row">
                    <span>Protein</span>
                    <strong>3.2g / 100ml</strong>
                </div>

                <div class="spec-row">
                    <span>Calcium</span>
                    <strong>120mg / 100ml</strong>
                </div>
            </div>

            <div class="spec-card">
                <h3>Storage & Handling</h3>

                <ul class="spec-list">
                    <li>Keep refrigerated where applicable.</li>
                    <li>Consume within recommended freshness period.</li>
                    <li>Keep sealed until ready to use.</li>
                    <li>Handle with clean utensils after opening.</li>
                </ul>
            </div>

            <div class="spec-card farm-origin-card">
                <h3>Farm Origin</h3>

                <div class="origin-box">
                    <p>
                        Produced and handled through Egerton AgriBridge Hub’s trusted
                        farm-to-table process, ensuring reliable quality and freshness.
                    </p>

                    <div class="manager-row">
                        <div class="manager-avatar"></div>

                        <div>
                            <strong>FARM SOURCE</strong>
                            <span>Egerton AgriBridge Hub</span>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </section>

    <!-- REVIEWS -->
    <section class="reviews-section">
        <div class="section-heading">
            <div>
                <p class="eyebrow">CUSTOMER FEEDBACK</p>
                <h2>Customer Reviews</h2>

                <% if (!reviews.isEmpty()) { %>
                    <p class="review-summary">
                        Average rating:
                        <strong><%= String.format("%.1f", averageRating) %>/5</strong>
                        from <%= reviews.size() %> review(s)
                    </p>
                <% } %>
            </div>
        </div>

        <% if ("success".equals(request.getParameter("review"))) { %>
            <div class="review-success">
                Thank you! Your review has been submitted.
            </div>
        <% } else if ("invalid".equals(request.getParameter("review"))) { %>
            <div class="review-error">
                Please select a valid rating and write a comment.
            </div>
        <% } %>

        <% if (reviews.isEmpty()) { %>

            <div class="review-empty">
                <h3>No reviews yet</h3>
                <p>Be the first customer to review this product.</p>
            </div>

        <% } else { %>

            <div class="review-grid">
                <%
                    for (Review r : reviews) {
                        String stars = "";

                        for (int i = 1; i <= 5; i++) {
                            if (i <= r.getRating()) {
                                stars += "★";
                            } else {
                                stars += "☆";
                            }
                        }
                %>

                    <div class="review-card">
                        <div class="review-stars"><%= stars %></div>

                        <p>
                            <%= r.getComment() %>
                        </p>

                        <strong>
                            <%= r.getCustomerName() != null ? r.getCustomerName() : "Verified Customer" %>
                        </strong>

                        <small>
                            <%= r.getCreatedAt() %>
                        </small>
                    </div>

                <%
                    }
                %>
            </div>

        <% } %>

        <% if (loggedIn) { %>

            <div class="review-form-card">
                <h3>Leave a Review</h3>
                <p class="review-form-note">
                    Share your experience with this product.
                </p>

                <form action="addReview" method="post">
                    <input type="hidden" name="productId" value="<%= product.getProductId() %>">

                    <label>Rating</label>
                    <select name="rating" required>
                        <option value="5">★★★★★ Excellent</option>
                        <option value="4">★★★★☆ Good</option>
                        <option value="3">★★★☆☆ Average</option>
                        <option value="2">★★☆☆☆ Poor</option>
                        <option value="1">★☆☆☆☆ Very Poor</option>
                    </select>

                    <label>Comment</label>
                    <textarea name="comment" rows="4" placeholder="Write your review..." required></textarea>

                    <button class="btn" type="submit">Submit Review</button>
                </form>
            </div>

        <% } else { %>

            <div class="review-form-card">
                <h3>Want to leave a review?</h3>
                <p class="review-form-note">
                    Login after purchasing to share your experience.
                </p>

                <a class="btn" href="login.jsp">Login to Review</a>
            </div>

        <% } %>
    </section>

    <!-- RECOMMENDED PRODUCTS -->
    <section class="pair-section">
        <div class="section-heading">
            <div>
                <h2>Pair it with...</h2>
                <p>Recommended fresh dairy additions from our hub.</p>
            </div>

            <a href="products.jsp">View All →</a>
        </div>

        <div class="pair-grid">
            <%
                int shown = 0;

                for (Product rec : allProducts) {
                    if (rec.getProductId() == product.getProductId()) {
                        continue;
                    }

                    if (shown >= 4) {
                        break;
                    }

                    shown++;
            %>

                <div class="pair-card">
                    <% if (rec.getImageUrl() != null && !rec.getImageUrl().isEmpty()) { %>
                        <img src="<%= request.getContextPath() + "/" + rec.getImageUrl() %>"
                             alt="<%= rec.getProductName() %>">
                    <% } else { %>
                        <div class="pair-no-image">No Image</div>
                    <% } %>

                    <small>RECOMMENDED</small>
                    <h3><%= rec.getProductName() %></h3>
                    <strong>KES <%= String.format("%.2f", rec.getPrice()) %></strong>

                    <a href="productDetails.jsp?id=<%= rec.getProductId() %>">
                        View Product
                    </a>
                </div>

            <%
                }
            %>
        </div>
    </section>

</div>

<script>
    function changeMainImage(src, element) {
        const mainImage = document.getElementById("mainProductImage");

        if (mainImage) {
            mainImage.src = src;
        }

        const thumbs = document.querySelectorAll(".thumb");

        thumbs.forEach(function (thumb) {
            thumb.classList.remove("active");
        });

        element.classList.add("active");
    }

    function decreaseQuantity() {
        const qtyInput = document.getElementById("quantityInput");
        let value = parseInt(qtyInput.value);

        if (value > 1) {
            qtyInput.value = value - 1;
        }
    }

    function increaseQuantity(maxStock) {
        const qtyInput = document.getElementById("quantityInput");
        let value = parseInt(qtyInput.value);

        if (value < maxStock) {
            qtyInput.value = value + 1;
        }
    }

    function addProductToCart(productId) {
        const qty = parseInt(document.getElementById("quantityInput").value);
        const btn = document.getElementById("addToCartBtn");
        const message = document.getElementById("cartMessage");

        btn.innerHTML = "Adding...";
        btn.disabled = true;

        let requests = [];

        for (let i = 0; i < qty; i++) {
            requests.push(fetch("cart?id=" + productId, { method: "GET" }));
        }

        Promise.all(requests)
            .then(function () {
                btn.innerHTML = "Added ✓";
                message.classList.remove("hidden");

                setTimeout(function () {
                    btn.innerHTML = "🛒 Add to Cart";
                    btn.disabled = false;
                    message.classList.add("hidden");
                }, 1500);
            })
            .catch(function () {
                btn.innerHTML = "Try Again";
                btn.disabled = false;
            });
    }

    function buyNow(productId) {
        const qty = parseInt(document.getElementById("quantityInput").value);
        const btn = document.getElementById("buyNowBtn");

        btn.innerHTML = "Preparing...";
        btn.disabled = true;

        let requests = [];

        for (let i = 0; i < qty; i++) {
            requests.push(fetch("cart?id=" + productId, { method: "GET" }));
        }

        Promise.all(requests)
            .then(function () {
                window.location.href = "cart.jsp";
            })
            .catch(function () {
                btn.innerHTML = "Buy Now";
                btn.disabled = false;
            });
    }
</script>

</body>
</html>