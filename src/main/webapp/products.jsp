<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="com.agribridge.dao.ProductDAO, com.agribridge.model.Product, java.util.List" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%
    // Load products directly so the page works without going through a servlet
    if (request.getAttribute("products") == null) {
        try {
            ProductDAO dao = new ProductDAO();
            List<Product> productList = dao.getAllProducts();
            request.setAttribute("products", productList);
        } catch (Exception e) {
            request.setAttribute("dbError", e.getMessage());
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>The Dairy Collection | EgertonAgriBridgeHub</title>
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;700;800&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; }
        .font-headline { font-family: 'Manrope', sans-serif; }
        .product-card:hover { transform: translateY(-4px); transition: all 0.2s ease; }
    </style>
</head>
<body class="bg-[#FAFAF2] text-[#1A1C18]">

<!-- Header / Navigation -->
<nav class="sticky top-0 z-50 bg-[#FAFAF2]/80 backdrop-blur-md shadow-sm">
    <div class="max-w-7xl mx-auto px-6 py-4 flex flex-wrap items-center justify-between gap-4">
        <div class="flex items-center gap-8">
            <span class="text-xl font-bold text-[#00450D] font-headline tracking-tight">EgertonAgriBridgeHub</span>
            <div class="hidden md:flex gap-6">
                <a href="products" class="text-[#00450D] font-bold border-b-2 border-[#835400]">Marketplace</a>
                <a href="#" class="text-stone-600 hover:text-[#835400]">Farmer Stories</a>
                <a href="#" class="text-stone-600 hover:text-[#835400]">Process</a>
                <a href="#" class="text-stone-600 hover:text-[#835400]">Support</a>
            </div>
        </div>
        <div class="flex items-center gap-4">
            <div class="relative">
                <input type="text" id="searchInput" placeholder="Search products..." 
                       class="pl-10 pr-4 py-2 rounded-full border border-stone-300 bg-white focus:outline-none focus:ring-2 focus:ring-[#00450D]">
                <span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-stone-400 text-xl">search</span>
            </div>
            <a href="cart.jsp" class="relative">
                <span class="material-symbols-outlined text-stone-700 hover:text-[#00450D]">shopping_cart</span>
                <span id="cartCount" class="absolute -top-2 -right-2 bg-[#835400] text-white text-xs rounded-full px-1 min-w-[18px] text-center">0</span>
            </a>
            <a href="login.jsp">
                <span class="material-symbols-outlined text-stone-700 hover:text-[#00450D]">account_circle</span>
            </a>
        </div>
    </div>
</nav>

<!-- Hero / Title -->
<div class="max-w-7xl mx-auto px-6 pt-12 pb-6">
    <h1 class="font-headline text-5xl md:text-6xl font-extrabold text-[#00450D] tracking-tight">The Dairy Collection</h1>
    <p class="text-stone-600 text-lg mt-2 max-w-2xl">Heritage farming from Egerton University – fresh from the pastoral heartlands.</p>
</div>

<!-- Category Filters -->
<div class="max-w-7xl mx-auto px-6 pb-6">
    <div class="flex flex-wrap gap-3 border-b border-stone-200 pb-4">
        <button class="filter-btn active px-5 py-2 rounded-full bg-[#00450D] text-white font-medium" data-category="all">All Products</button>
        <button class="filter-btn px-5 py-2 rounded-full bg-white border border-stone-300 text-stone-700 hover:bg-stone-100" data-category="Milk">Milk</button>
        <button class="filter-btn px-5 py-2 rounded-full bg-white border border-stone-300 text-stone-700 hover:bg-stone-100" data-category="Yogurt">Yogurt</button>
        <button class="filter-btn px-5 py-2 rounded-full bg-white border border-stone-300 text-stone-700 hover:bg-stone-100" data-category="Cheese">Cheese</button>
        <button class="filter-btn px-5 py-2 rounded-full bg-white border border-stone-300 text-stone-700 hover:bg-stone-100" data-category="Butter">Butter</button>
    </div>
</div>

<!-- Product Grid -->
<div class="max-w-7xl mx-auto px-6 py-8">
    <div id="productGrid" class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
        <c:forEach var="product" items="${products}">
            <div class="product-card bg-white rounded-2xl shadow-md overflow-hidden hover:shadow-xl transition-all duration-200"
                 data-category="${product.category}" data-name="${product.name.toLowerCase()}">
                <img src="${not empty product.imagePath ? pageContext.request.contextPath.concat('/ProductServlet?action=viewImage&path=').concat(product.imagePath) : 'https://rethinkrural.raydientrural.com/hubfs/Blog_Photos/Rural_Life/Food/Uses_for_milk_lead.jpg'}"
                     alt="${product.name}" class="w-full h-48 object-cover">
                <div class="p-4">
                    <h3 class="font-headline font-bold text-lg text-[#1A1C18]">${product.name}</h3>
                    <p class="text-stone-500 text-sm mt-1">${product.category}</p>
                    <div class="flex justify-between items-center mt-3">
                        <span class="font-bold text-xl text-[#00450D]">KES <fmt:formatNumber value="${product.price}" pattern="#,##0.00"/></span>
                        <c:choose>
                            <c:when test="${product.stock > 0}">
                                <span class="text-xs text-green-700 bg-green-100 px-2 py-1 rounded-full">
                                    ${product.stock < 10 ? 'Low Stock' : 'In Stock'}
                                </span>
                            </c:when>
                            <c:otherwise>
                                <span class="text-xs text-red-700 bg-red-100 px-2 py-1 rounded-full">Out of Stock</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <button class="add-to-cart mt-4 w-full bg-[#835400] hover:bg-[#643f00] text-white font-semibold py-2 rounded-xl transition flex items-center justify-center gap-2"
                            data-id="${product.id}"
                            data-name="${product.name}"
                            data-price="${product.price}"
                            data-stock="${product.stock}"
                            data-image="">
                        <span class="material-symbols-outlined text-base">shopping_cart</span> Add to Cart
                    </button>
                </div>
            </div>
        </c:forEach>
        <c:if test="${empty products}">
            <div class="col-span-full text-center py-12 text-stone-500">
                <c:choose>
                    <c:when test="${not empty dbError}">Database error: ${dbError}</c:when>
                    <c:otherwise>No products available. Check back soon!</c:otherwise>
                </c:choose>
            </div>
        </c:if>
    </div>
</div>

<!-- Persistent Checkout Bar -->
<div id="checkoutBar" class="fixed bottom-0 left-0 w-full bg-white border-t border-stone-200 shadow-lg p-4 flex flex-wrap justify-between items-center gap-4 z-40">
    <div class="flex items-center gap-3">
        <span class="material-symbols-outlined text-[#00450D]">payments</span>
        <span class="font-semibold text-stone-700">Swift M-Pesa Checkout</span>
    </div>
    <div class="flex items-center gap-6">
        <div>
            <span class="text-stone-500">Cart Total:</span>
            <span id="cartTotal" class="font-bold text-2xl text-[#00450D]">KES 0.00</span>
        </div>
        <button id="payNowBtn" class="bg-[#835400] hover:bg-[#643f00] text-white px-6 py-2 rounded-full font-semibold transition"
                onclick="window.location.href='quickOrder'">
            Pay Now
        </button>
    </div>
</div>

<!-- Footer -->
<footer class="bg-[#00450D] mt-24 py-12 px-8 flex flex-col md:flex-row justify-between items-center gap-4">
    <div class="flex flex-col gap-2">
        <span class="text-white font-headline font-bold text-xl">EgertonAgriBridgeHub</span>
        <span class="text-xs uppercase tracking-wide text-stone-400">© 2024 EgertonAgriBridgeHub. Modern Pastoral Excellence.</span>
    </div>
    <div class="flex flex-wrap justify-center gap-8">
        <a href="#" class="text-xs uppercase tracking-wide text-stone-400 hover:text-[#FCAB28]">Privacy Policy</a>
        <a href="#" class="text-xs uppercase tracking-wide text-stone-400 hover:text-[#FCAB28]">Terms of Service</a>
        <a href="#" class="text-xs uppercase tracking-wide text-stone-400 hover:text-[#FCAB28]">Farmer Login</a>
        <a href="#" class="text-xs uppercase tracking-wide text-stone-400 hover:text-[#FCAB28]">Sustainability Report</a>
    </div>
</footer>

<!-- JavaScript: Filtering, Search, and Add-to-Cart with AJAX -->
<!--<script>
    // Add to Cart – updates UI dynamically, no page reload
    document.querySelectorAll('.add-to-cart').forEach(btn => {
        btn.addEventListener('click', (e) => {
            const productId = btn.dataset.id;
            const name = btn.dataset.name;
            const price = btn.dataset.price;
            const imageUrl = btn.dataset.image || '';
            const quantity = 1;

            fetch('CartServlet', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: new URLSearchParams({
                    action: 'add',
                    productId: productId,
                    name: name,
                    price: price,
                    quantity: quantity,
                    imageUrl: imageUrl
                })
            })
            .then(response => {
                if (!response.ok) {
                    throw new Error(`HTTP ${response.status}: ${response.statusText}`);
                }
                return response.json();
            })
            .then(data => {
                if (data.success) {
                    // Update cart badge and bottom bar total
                    const cartCountSpan = document.getElementById('cartCount');
                    const cartTotalSpan = document.getElementById('cartTotal');
                    if (cartCountSpan) cartCountSpan.innerText = data.cartSize;
                    if (cartTotalSpan) cartTotalSpan.innerText = 'KES ' + data.cartTotal.toFixed(2);
                    // Show success message (optional)
                    alert('Added to cart!');
                } else {
                    alert('Failed to add item: ' + (data.error || 'Unknown error'));
                }
            })
            .catch(error => {
                console.error('Add to cart error:', error);
                alert('Could not add to cart. Please try again.\n' + error.message);
            });
        });
    });

    // Category Filter (unchanged)
    const filterBtns = document.querySelectorAll('.filter-btn');
    const productCards = document.querySelectorAll('#productGrid .product-card');
    filterBtns.forEach(btn => {
        btn.addEventListener('click', () => {
            const category = btn.dataset.category;
            filterBtns.forEach(b => {
                b.classList.remove('bg-[#00450D]', 'text-white');
                b.classList.add('bg-white', 'border', 'border-stone-300', 'text-stone-700');
            });
            btn.classList.remove('bg-white', 'border', 'border-stone-300', 'text-stone-700');
            btn.classList.add('bg-[#00450D]', 'text-white');
            productCards.forEach(card => {
                if (category === 'all' || card.dataset.category === category) {
                    card.style.display = '';
                } else {
                    card.style.display = 'none';
                }
            });
        });
    });

    // Search Filter (unchanged)
    const searchInput = document.getElementById('searchInput');
    if (searchInput) {
        searchInput.addEventListener('input', (e) => {
            const searchTerm = e.target.value.toLowerCase();
            productCards.forEach(card => {
                const name = card.dataset.name || '';
                if (name.includes(searchTerm)) {
                    card.style.display = '';
                } else {
                    card.style.display = 'none';
                }
            });
        });
    }

    // Pay Now button (unchanged)
    const payNowBtn = document.getElementById('payNowBtn');
    if (payNowBtn) {
        payNowBtn.addEventListener('click', () => {
            window.location.href = 'checkout.jsp';
        });
    }
</script>-->

<script>
    function updateCartUI() {
        // Optional: fetch current cart size from server to sync badge
        fetch('CartServlet?action=getCartSize')
            .then(r => r.json())
            .then(data => {
                document.getElementById('cartCount').innerText = data.cartSize;
                document.getElementById('cartTotal').innerText = 'KES ' + data.cartTotal.toFixed(2);
            })
            .catch(console.error);
    }

    document.querySelectorAll('.add-to-cart').forEach(btn => {
        btn.addEventListener('click', (e) => {
            const productId = btn.dataset.id;
            const name = btn.dataset.name;
            const price = btn.dataset.price;
            const imageUrl = btn.dataset.image || '';
            const quantity = 1;

            fetch('CartServlet', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: new URLSearchParams({
                    action: 'add',
                    productId: productId,
                    name: name,
                    price: price,
                    quantity: quantity,
                    imageUrl: imageUrl
                })
            })
            .then(response => {
                if (!response.ok) throw new Error(`HTTP ${response.status}`);
                return response.json();
            })
            .then(data => {
                if (data.success) {
                    document.getElementById('cartCount').innerText = data.cartSize;
                    document.getElementById('cartTotal').innerText = 'KES ' + data.cartTotal.toFixed(2);
                    alert('Added to cart!');
                } else {
                    alert('Error: ' + (data.error || 'Unknown'));
                }
            })
            .catch(error => {
                console.error('Add to cart failed:', error);
                alert('Failed to add item. Check console for details.');
            });
        });
    });

    // ... (keep your existing filter and search code unchanged)
</script>
</body>
</html>