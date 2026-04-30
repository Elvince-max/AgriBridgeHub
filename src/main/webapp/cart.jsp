<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Your Harvest Basket | EgertonAgriBridgeHub</title>
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;700;800&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; background: #f9f7f3; }
        .font-headline { font-family: 'Manrope', sans-serif; }
        .quantity-btn { transition: all 0.1s ease; }
        .quantity-btn:active { transform: scale(0.95); }
        /* Search dropdown */
        .search-container {
            position: relative;
        }
        .search-results-dropdown {
            position: absolute;
            top: 100%;
            left: 0;
            right: 0;
            background: white;
            border: 1px solid #ddd;
            border-radius: 12px;
            max-height: 300px;
            overflow-y: auto;
            z-index: 1000;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            display: none;
        }
        .search-result-item {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 10px 12px;
            border-bottom: 1px solid #f0f0f0;
            cursor: pointer;
            transition: background 0.1s;
        }
        .search-result-item:hover {
            background-color: #f5f5f0;
        }
        .search-result-img {
            width: 40px;
            height: 40px;
            object-fit: cover;
            border-radius: 8px;
        }
        .search-result-info {
            flex: 1;
        }
        .search-result-name {
            font-weight: 600;
            font-size: 0.9rem;
        }
        .search-result-price {
            font-size: 0.8rem;
            color: #1e4a2f;
        }
        .add-to-cart-search {
            background-color: #835400;
            color: white;
            border: none;
            border-radius: 20px;
            padding: 4px 12px;
            font-size: 0.7rem;
            cursor: pointer;
        }
        .add-to-cart-search:hover {
            background-color: #643f00;
        }
    </style>
</head>
<body class="bg-[#FAFAF2] text-[#1A1C18]">

<!-- Header (same as products.jsp) -->
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
           <div class="relative search-container">
            <input type="text" id="searchInput" placeholder="Search products..." 
                   class="pl-10 pr-4 py-2 rounded-full border border-stone-300 bg-white focus:outline-none focus:ring-2 focus:ring-[#00450D]">
            <span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-stone-400 text-xl">search</span>
            <div id="searchResults" class="search-results-dropdown"></div>
        </div>
            <a href="cart.jsp" class="relative">
                <span class="material-symbols-outlined text-stone-700">shopping_cart</span>
                <span id="cartCount" class="absolute -top-2 -right-2 bg-[#835400] text-white text-xs rounded-full px-1 min-w-[18px] text-center">
                    ${not empty cart ? cart.items.size() : 0}
                </span>
            </a>
            <a href="login.jsp">
                <span class="material-symbols-outlined text-stone-700">account_circle</span>
            </a>
        </div>
    </div>
</nav>

<!-- Breadcrumbs -->
<div class="max-w-7xl mx-auto px-6 py-4 text-sm text-stone-500">
    <span class="text-stone-600">Marketplace</span> <span class="mx-1">›</span> 
    <span class="font-semibold text-[#00450D]">Shopping Cart</span>
</div>

<!-- Main content: two columns -->
<div class="max-w-7xl mx-auto px-6 py-6 flex flex-col lg:flex-row gap-8">
    <!-- LEFT: Shopping Basket Table -->
    <div class="flex-1 bg-white rounded-2xl shadow-sm p-6">
        <h2 class="text-2xl font-headline font-bold text-[#00450D] mb-4">Your Harvest Basket</h2>
        
        <c:choose>
            <c:when test="${empty cart or empty cart.items}">
                 <div class="text-center py-12 text-stone-500">
                    <span class="material-symbols-outlined text-6xl mb-3">shopping_basket</span>
                    <p>Your basket is empty.</p>
                    <a href="products" class="inline-block mt-4 text-[#00450D] underline hover:text-[#0f331f] transition">Continue Shopping</a>
                 </div>
                </c:when>
            <c:otherwise>
                <div class="overflow-x-auto">
                    <table class="w-full text-left">
                        <thead class="border-b border-stone-200 text-stone-500 text-sm">
                            <tr>
                                <th class="pb-3">Product</th>
                                <th class="pb-3">Quantity</th>
                                <th class="pb-3">Price</th>
                                <th class="pb-3 text-right">Subtotal</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="item" items="${cart.items}">
                                <tr class="border-b border-stone-100">
                                    <!-- Product cell with image -->
                                    <td class="py-4">
                                        <div class="flex items-center gap-3">
                                            <img src="${item.imageUrl != null ? item.imageUrl : 'https://via.placeholder.com/50x50?text=Product'}" 
                                                 alt="${item.name}" 
                                                 class="w-12 h-12 object-cover rounded-lg">
                                            <div>
                                                <div class="font-medium">${item.name}</div>
                                                <div class="text-xs text-stone-400">Pasture-raised, fresh from Egerton farms</div>
                                            </div>
                                        </div>
                                    </td>
                                    <!-- Quantity with +/- forms -->
                                    <td class="py-4">
                                        <div class="flex items-center gap-2">
                                            <form action="CartServlet" method="post" class="inline">
                                                <input type="hidden" name="action" value="update">
                                                <input type="hidden" name="productId" value="${item.productId}">
                                                <input type="hidden" name="quantity" value="${item.quantity - 1}">
                                                <button type="submit" class="quantity-btn w-8 h-8 rounded-full bg-stone-100 hover:bg-stone-200 flex items-center justify-center">-</button>
                                            </form>
                                            <span class="w-8 text-center">${item.quantity}</span>
                                            <form action="CartServlet" method="post" class="inline">
                                                <input type="hidden" name="action" value="update">
                                                <input type="hidden" name="productId" value="${item.productId}">
                                                <input type="hidden" name="quantity" value="${item.quantity + 1}">
                                                <button type="submit" class="quantity-btn w-8 h-8 rounded-full bg-stone-100 hover:bg-stone-200 flex items-center justify-center">+</button>
                                            </form>
                                        </div>
                                    </td>
                                    <td class="py-4">KES <fmt:formatNumber value="${item.price}" pattern="#,##0.00"/></td>
                                    <td class="py-4 text-right font-medium">KES <fmt:formatNumber value="${item.price * item.quantity}" pattern="#,##0.00"/></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
                <!-- Basket actions -->
                <div class="flex justify-between items-center mt-6 pt-4 border-t border-stone-200">
                    <a href="products" class="text-[#00450D] font-medium flex items-center gap-1">
                        <span class="material-symbols-outlined text-base">arrow_back</span> Continue Shopping
                    </a>
                    <a href="CartServlet?action=clear" class="text-red-600 hover:text-red-700 text-sm flex items-center gap-1" onclick="return confirm('Empty your entire cart?');">
                        <span class="material-symbols-outlined text-base">delete</span> Empty Cart
                    </a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- RIGHT: Cart Total & M-Pesa Checkout -->
    <div class="w-full lg:w-96">
        <div class="bg-white rounded-2xl shadow-sm p-6 sticky top-24">
            <h3 class="text-lg font-headline font-bold text-[#00450D] mb-4">Cart Total</h3>
            <div class="space-y-2 text-sm">
                <div class="flex justify-between">
                    <span class="text-stone-600">Subtotal</span>
                    <span class="font-medium">KES <fmt:formatNumber value="${cart.total}" pattern="#,##0.00"/></span>
                </div>
                <div class="flex justify-between">
                    <span class="text-stone-600">Delivery Fee</span>
                    <span class="font-medium">KES 0.00</span>
                </div>
                <div class="flex justify-between">
<!--                    <span class="text-stone-600">Estimated Tax (16% VAT)</span>
                    <span class="font-medium">KES</span>-->
                </div>
                <div class="border-t border-stone-200 pt-3 mt-3">
                    <div class="flex justify-between text-lg font-bold text-[#00450D]">
                        <span>Grand Total</span>
                        <span>KES <fmt:formatNumber value="${cart.total}" pattern="#,##0.00"/></span>
                    </div>
                    <p class="text-xs text-stone-400 mt-1">takes and fees for later</p>
                </div>
            </div>

            <!-- Proceed to Checkout Button -->
            <a href="checkout.jsp" class="mt-6 block w-full bg-[#1e4a2f] hover:bg-[#0f331f] text-white text-center font-semibold py-3 rounded-full transition">
                Proceed to Checkout
            </a>

            <!-- M-Pesa Direct Checkout Box -->
            <div class="mt-6 bg-[#fefaf5] rounded-xl p-4 border border-[#e6dfd3]">
                <div class="flex items-center gap-2 mb-2">
                    <span class="material-symbols-outlined text-[#835400]">payments</span>
                    <span class="font-bold text-[#835400]">M-Pesa Direct Checkout</span>
                </div>
                <p class="text-xs text-stone-600 mb-3">
                    A payment prompt will be sent to your registered phone number after you place your order.
                </p>
                <!-- Trust Icons -->
                <div class="flex justify-around text-stone-500 text-xs">
                    <span class="flex items-center gap-1"><span class="material-symbols-outlined text-sm">shield</span> Secure SSL</span>
                    <span class="flex items-center gap-1"><span class="material-symbols-outlined text-sm">lock</span> Encrypted</span>
                    <span class="flex items-center gap-1"><span class="material-symbols-outlined text-sm">check_circle</span> Trusted</span>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Footer -->
<footer class="bg-[#00450D] mt-16 py-12 px-8 flex flex-col md:flex-row justify-between items-center gap-4">
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
<script>
    const searchInput = document.getElementById('searchInput');
    const resultsDiv = document.getElementById('searchResults');
    let debounceTimer;

    searchInput.addEventListener('input', function() {
        clearTimeout(debounceTimer);
        const query = this.value.trim();
        if (query.length < 2) {
            resultsDiv.style.display = 'none';
            return;
        }
        debounceTimer = setTimeout(() => {
            fetch(`ProductSearchServlet?q=${encodeURIComponent(query)}`)
                .then(response => response.json())
                .then(products => {
                    if (products.length === 0) {
                        resultsDiv.innerHTML = '<div class="p-3 text-center text-stone-500">No products found</div>';
                        resultsDiv.style.display = 'block';
                        return;
                    }
                    let html = '';
                    products.forEach(p => {
                        html += `
                            <div class="search-result-item" data-product='${JSON.stringify(p)}'>
                                <img src="${p.imageUrl || 'https://via.placeholder.com/40x40?text=Product'}" class="search-result-img">
                                <div class="search-result-info">
                                    <div class="search-result-name">${escapeHtml(p.name)}</div>
                                    <div class="search-result-price">KES ${p.price.toFixed(2)}</div>
                                </div>
                                <button class="add-to-cart-search" data-id="${p.productId}" data-name="${escapeHtml(p.name)}" data-price="${p.price}" data-image="${p.imageUrl || ''}">Add</button>
                            </div>
                        `;
                    });
                    resultsDiv.innerHTML = html;
                    resultsDiv.style.display = 'block';
                    
                    // Attach add-to-cart events to each button in dropdown
                    document.querySelectorAll('.add-to-cart-search').forEach(btn => {
                        btn.addEventListener('click', (e) => {
                            e.stopPropagation();
                            const productId = btn.dataset.id;
                            const name = btn.dataset.name;
                            const price = parseFloat(btn.dataset.price);
                            const imageUrl = btn.dataset.image;
                            addToCart(productId, name, price, imageUrl);
                        });
                    });
                })
                .catch(err => {
                    console.error('Search error:', err);
                    resultsDiv.innerHTML = '<div class="p-3 text-center text-red-500">Error loading results</div>';
                    resultsDiv.style.display = 'block';
                });
        }, 300);
    });

    // Hide dropdown when clicking outside
    document.addEventListener('click', function(e) {
        if (!searchInput.contains(e.target) && !resultsDiv.contains(e.target)) {
            resultsDiv.style.display = 'none';
        }
    });

    // Function to add item to cart via AJAX and refresh cart UI
    function addToCart(productId, name, price, imageUrl) {
        fetch('CartServlet', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: new URLSearchParams({
                action: 'add',
                productId: productId,
                name: name,
                price: price,
                quantity: 1,
                imageUrl: imageUrl
            })
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                // Reload the page to refresh cart display (simplest)
                // Or update the cart table dynamically. For simplicity, reload.
                window.location.reload();
            } else {
                alert('Failed to add item.');
            }
        })
        .catch(error => console.error('Error:', error));
    }

    // Helper to escape HTML to prevent XSS
    function escapeHtml(str) {
        if (!str) return '';
        return str.replace(/[&<>]/g, function(m) {
            if (m === '&') return '&amp;';
            if (m === '<') return '&lt;';
            if (m === '>') return '&gt;';
            return m;
        });
    }
</script>
</body>
</html>