<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DairyAdmin | Product Management</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            background: #f0f2f5;
            font-family: 'Inter', sans-serif;
            color: #1a2c3e;
            padding: 24px 32px;
        }

        .app-container {
            max-width: 1600px;
            margin: 0 auto;
        }

        /* Header */
        .top-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 28px;
            flex-wrap: wrap;
            gap: 16px;
        }

        .logo-area h1 {
            font-size: 1.8rem;
            font-weight: 700;
            background: linear-gradient(135deg, #2b6e4c, #1e4a3b);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .logo-area p {
            font-size: 0.8rem;
            color: #6c8a9c;
            margin-top: 4px;
        }

        .header-actions {
            display: flex;
            gap: 16px;
            align-items: center;
        }

        .btn-primary {
            background: #2b6e4c;
            color: white;
            padding: 10px 24px;
            border-radius: 40px;
            text-decoration: none;
            font-weight: 600;
            font-size: 0.9rem;
            transition: all 0.3s;
            border: none;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn-primary:hover {
            background: #1e5a3e;
            transform: translateY(-2px);
        }

        /* Stats Row */
        .stats-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 28px;
        }

        .stat-card {
            background: white;
            border-radius: 20px;
            padding: 20px 24px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.04);
            transition: transform 0.2s;
        }

        .stat-card:hover {
            transform: translateY(-2px);
        }

        .stat-title {
            font-size: 0.75rem;
            text-transform: uppercase;
            font-weight: 600;
            color: #7a9bb0;
            letter-spacing: 0.5px;
        }

        .stat-number {
            font-size: 2.2rem;
            font-weight: 800;
            color: #1a3a2e;
            margin-top: 8px;
        }

        .stat-sub {
            font-size: 0.7rem;
            color: #95b3c4;
            margin-top: 4px;
        }

        /* Dashboard Grid */
        .dashboard-grid {
            display: flex;
            gap: 28px;
            flex-wrap: wrap;
        }

        .products-panel {
            flex: 3;
            min-width: 0;
        }

        .side-panel {
            flex: 1.2;
            min-width: 260px;
        }

        /* Cards */
        .card {
            background: white;
            border-radius: 24px;
            padding: 20px 24px;
            margin-bottom: 24px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.04);
        }

        .card-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 16px;
        }

        .section-title {
            font-size: 1rem;
            font-weight: 700;
            color: #1a3a2e;
        }

        .section-title i {
            margin-right: 8px;
            color: #2b6e4c;
        }

        /* Search Bar */
        .search-container {
            margin-bottom: 24px;
        }

        .search-bar {
            display: flex;
            align-items: center;
            background: #f8fafc;
            border-radius: 48px;
            padding: 12px 20px;
            border: 1px solid #e2e8f0;
            transition: all 0.3s;
        }

        .search-bar:focus-within {
            border-color: #2b6e4c;
            box-shadow: 0 0 0 3px rgba(43,110,76,0.1);
        }

        .search-bar i {
            color: #94a3b8;
            margin-right: 12px;
        }

        .search-bar input {
            border: none;
            width: 100%;
            background: transparent;
            font-size: 0.9rem;
            outline: none;
        }

        /* Product Table */
        .product-table {
            width: 100%;
            border-collapse: collapse;
        }

        .product-table th {
            text-align: left;
            padding: 14px 12px;
            font-size: 0.7rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: #7a9bb0;
            border-bottom: 1px solid #eef2f6;
        }

        .product-table td {
            padding: 16px 12px;
            border-bottom: 1px solid #f0f2f5;
            font-size: 0.85rem;
        }

        .product-info {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .product-thumb {
            width: 44px;
            height: 44px;
            border-radius: 12px;
            object-fit: cover;
            background: #f0f2f5;
        }

        .product-name {
            font-weight: 600;
        }

        .price {
            font-weight: 700;
            color: #2b6e4c;
        }

        /* Badges */
        .badge {
            padding: 4px 12px;
            border-radius: 40px;
            font-size: 0.7rem;
            font-weight: 600;
            display: inline-block;
        }

        .badge-instock {
            background: #dcfce7;
            color: #15803d;
        }

        .badge-low {
            background: #fef3c7;
            color: #b45309;
        }

        .badge-out {
            background: #fee2e2;
            color: #dc2626;
        }

        /* Action Buttons */
        .action-buttons {
            display: flex;
            gap: 8px;
        }

        .btn-icon {
            padding: 6px 12px;
            border-radius: 20px;
            text-decoration: none;
            font-size: 0.7rem;
            font-weight: 500;
            transition: all 0.2s;
        }

        .btn-edit {
            background: #e0f2fe;
            color: #0284c7;
        }

        .btn-edit:hover {
            background: #bae6fd;
        }

        .btn-delete {
            background: #fee2e2;
            color: #dc2626;
        }

        .btn-delete:hover {
            background: #fecaca;
        }

        /* Category List */
        .category-list {
            list-style: none;
        }

        .category-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 0;
            border-bottom: 1px solid #f0f2f5;
        }

        .category-name {
            font-size: 0.85rem;
        }

        .category-count {
            background: #eef2f6;
            padding: 2px 10px;
            border-radius: 20px;
            font-size: 0.7rem;
            font-weight: 600;
            color: #2b6e4c;
        }

        /* Low Stock Items */
        .low-stock-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 12px 0;
            border-bottom: 1px solid #f0f2f5;
        }

        .low-stock-name {
            font-size: 0.85rem;
            font-weight: 500;
        }

        .low-stock-qty {
            font-size: 0.75rem;
            color: #e67e22;
            font-weight: 600;
        }

        .empty-message {
            text-align: center;
            padding: 32px;
            color: #95b3c4;
        }

        .empty-message i {
            font-size: 2rem;
            margin-bottom: 8px;
        }

        /* Footer Stats */
        .footer-stats {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 16px;
            padding-top: 16px;
            border-top: 1px solid #eef2f6;
            font-size: 0.75rem;
            color: #7a9bb0;
        }

        /* Messages */
        .message {
            padding: 14px 20px;
            border-radius: 16px;
            margin-bottom: 24px;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .message-success {
            background: #dcfce7;
            color: #15803d;
            border-left: 4px solid #15803d;
        }

        .message-error {
            background: #fee2e2;
            color: #dc2626;
            border-left: 4px solid #dc2626;
        }

        @media (max-width: 900px) {
            body { padding: 16px; }
            .dashboard-grid { flex-direction: column; }
        }
    </style>
</head>
<body>
<div class="app-container">

    <!-- Header -->
    <div class="top-header">
        <div class="logo-area">
            <h1><i class="fas fa-tachometer-alt"></i> DairyAdmin</h1>
            <p>Manage your estate's digital dairy catalog and inventory.</p>
        </div>
        <div class="header-actions">
            <a href="${pageContext.request.contextPath}/addProduct.jsp" class="btn-primary">
                <i class="fas fa-plus"></i> Add Product
            </a>
        </div>
    </div>

    <!-- Messages -->
    <c:if test="${not empty message}">
        <div class="message message-${messageType}">
            <i class="fas ${messageType == 'success' ? 'fa-check-circle' : 'fa-exclamation-circle'}"></i>
            ${message}
        </div>
    </c:if>

    <!-- Stats Row -->
    <div class="stats-row">
        <div class="stat-card">
            <div class="stat-title"><i class="fas fa-tags"></i> TOTAL CATEGORIES</div>
            <div class="stat-number">${totalCategories}</div>
            <div class="stat-sub">Product categories</div>
        </div>
        <div class="stat-card">
            <div class="stat-title"><i class="fas fa-box"></i> TOTAL PRODUCTS</div>
            <div class="stat-number">${totalProducts}</div>
            <div class="stat-sub">Active products</div>
        </div>
        <div class="stat-card">
            <div class="stat-title"><i class="fas fa-exclamation-triangle"></i> LOW STOCK ALERTS</div>
            <div class="stat-number">${lowStockCount}</div>
            <div class="stat-sub">Items below 20 units</div>
        </div>
        <div class="stat-card">
            <div class="stat-title"><i class="fas fa-star"></i> FEATURED PRODUCTS</div>
            <div class="stat-number">
                <c:set var="featuredCount" value="0"/>
                <c:forEach items="${products}" var="p">
                    <c:if test="${p.featuredProduct}"><c:set var="featuredCount" value="${featuredCount + 1}"/></c:if>
                </c:forEach>
                ${featuredCount}
            </div>
            <div class="stat-sub">Featured items</div>
        </div>
    </div>

    <!-- Dashboard Grid -->
    <div class="dashboard-grid">
        <!-- Main Products Panel -->
        <div class="products-panel">
            <div class="card">
                <div class="card-header">
                    <div class="section-title">
                        <i class="fas fa-list"></i> PRODUCTS
                    </div>
                </div>

                <!-- Search -->
                <div class="search-container">
                    <form method="get" action="${pageContext.request.contextPath}/ProductServlet">
                        <input type="hidden" name="action" value="list">
                        <div class="search-bar">
                            <i class="fas fa-search"></i>
                            <input type="text" name="search" placeholder="Search by product name, category, or description..." 
                                   value="${param.search}">
                        </div>
                    </form>
                </div>

                <!-- Product Table -->
                <c:choose>
                    <c:when test="${empty products}">
                        <div class="empty-message">
                            <i class="fas fa-box-open"></i>
                            <p>No products found</p>
                            <a href="${pageContext.request.contextPath}/addProduct.jsp" class="btn-primary" style="margin-top: 16px; display: inline-block;">
                                Add your first product
                            </a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <table class="product-table">
                            <thead>
                                <tr>
                                    <th>PRODUCT</th>
                                    <th>CATEGORY</th>
                                    <th>PRICE (KES)</th>
                                    <th>STOCK STATUS</th>
                                    <th>QUANTITY</th>
                                    <th>ACTIONS</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${products}" var="product">
                                    <tr>
                                        <td>
                                            <div class="product-info">
                                                <c:choose>
                                                    <c:when test="${not empty product.imagePath}">
                                                        <img src="${pageContext.request.contextPath}/ProductServlet?action=viewImage&path=${product.imagePath}" 
                                                             class="product-thumb" alt="${product.name}">
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="product-thumb" style="background: #eef2f6; display: flex; align-items: center; justify-content: center;">
                                                            <i class="fas fa-image" style="color: #95b3c4;"></i>
                                                        </div>
                                                    </c:otherwise>
                                                </c:choose>
                                                <span class="product-name">${product.name}</span>
                                            </div>
                                        </td>
                                        <td>${product.category}</td>
                                        <td class="price">
                                            <fmt:formatNumber value="${product.price}" pattern="#,##0.00"/> KES
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${product.stock <= 0}">
                                                    <span class="badge badge-out"><i class="fas fa-ban"></i> Out of Stock</span>
                                                </c:when>
                                                <c:when test="${product.stock < 20}">
                                                    <span class="badge badge-low"><i class="fas fa-exclamation"></i> Low Stock</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-instock"><i class="fas fa-check"></i> In Stock</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>${product.stock} units</td>
                                        <td>
                                            <div class="action-buttons">
                                                <a href="${pageContext.request.contextPath}/ProductServlet?action=edit&id=${product.id}" 
                                                   class="btn-icon btn-edit">
                                                    <i class="fas fa-edit"></i> Edit
                                                </a>
                                                <a href="${pageContext.request.contextPath}/ProductServlet?action=delete&id=${product.id}"
                                                   class="btn-icon btn-delete"
                                                   onclick="return confirm('Delete ${product.name}? This action cannot be undone.')">
                                                    <i class="fas fa-trash"></i> Delete
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>

                        <!-- Footer Stats -->
                        <div class="footer-stats">
                            <span><i class="fas fa-database"></i> Showing ${fn:length(products)} products</span>
                            <span><i class="fas fa-leaf"></i> Fresh from the farm</span>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- Side Panel -->
        <div class="side-panel">
            <!-- Categories Card -->
            <div class="card">
                <div class="card-header">
                    <div class="section-title">
                        <i class="fas fa-folder"></i> All Categories
                    </div>
                </div>
                
                <c:choose>
                    <c:when test="${empty categories}">
                        <div class="empty-message" style="padding: 16px;">
                            <i class="fas fa-folder-open"></i>
                            <p>No categories</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <ul class="category-list">
                            <c:forEach items="${categories}" var="category">
                                <li class="category-item">
                                    <span class="category-name">
                                        <i class="fas fa-tag"></i> ${category.key}
                                    </span>
                                    <span class="category-count">${category.value} items</span>
                                </li>
                            </c:forEach>
                        </ul>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Low Stock Items Card -->
            <div class="card">
                <div class="card-header">
                    <div class="section-title">
                        <i class="fas fa-bell"></i> Low Stock Items
                    </div>
                </div>
                
                <c:set var="hasLowStock" value="false"/>
                <c:forEach items="${products}" var="product">
                    <c:if test="${product.stock > 0 && product.stock < 20}">
                        <c:set var="hasLowStock" value="true"/>
                    </c:if>
                </c:forEach>

                <c:choose>
                    <c:when test="${!hasLowStock}">
                        <div class="empty-message" style="padding: 16px;">
                            <i class="fas fa-check-circle" style="color: #2b6e4c;"></i>
                            <p>No low stock items</p>
                            <small>All inventory levels are healthy</small>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach items="${products}" var="product">
                            <c:if test="${product.stock > 0 && product.stock < 20}">
                                <div class="low-stock-item">
                                    <div>
                                        <div class="low-stock-name">${product.name}</div>
                                        <small style="color: #95b3c4;">${product.category}</small>
                                    </div>
                                    <div class="low-stock-qty">
                                        <i class="fas fa-boxes"></i> ${product.stock} units
                                    </div>
                                </div>
                            </c:if>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Quick Stats Card -->
            <div class="card">
                <div class="card-header">
                    <div class="section-title">
                        <i class="fas fa-chart-line"></i> Quick Stats
                    </div>
                </div>
                
                <c:set var="featuredCount" value="0"/>
                <c:set var="publicCount" value="0"/>
                <c:forEach items="${products}" var="product">
                    <c:if test="${product.featuredProduct}"><c:set var="featuredCount" value="${featuredCount + 1}"/></c:if>
                    <c:if test="${product.publicInCatalog}"><c:set var="publicCount" value="${publicCount + 1}"/></c:if>
                </c:forEach>
                
                <div style="display: flex; flex-direction: column; gap: 12px;">
                    <div style="display: flex; justify-content: space-between;">
                        <span style="color: #6c8a9c;">Total Products:</span>
                        <strong>${totalProducts}</strong>
                    </div>
                    <div style="display: flex; justify-content: space-between;">
                        <span style="color: #6c8a9c;">Featured Products:</span>
                        <strong>${featuredCount}</strong>
                    </div>
                    <div style="display: flex; justify-content: space-between;">
                        <span style="color: #6c8a9c;">Public in Catalog:</span>
                        <strong>${publicCount}</strong>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    // Auto-hide messages after 5 seconds
    setTimeout(function() {
        var messages = document.querySelectorAll('.message');
        messages.forEach(function(message) {
            message.style.transition = 'opacity 0.5s';
            message.style.opacity = '0';
            setTimeout(function() {
                message.remove();
            }, 500);
        });
    }, 5000);
</script>
</body>
</html>