<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DairyAdmin | Edit Product</title>
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
            padding: 32px;
        }

        .form-container {
            max-width: 800px;
            margin: 0 auto;
        }

        .card {
            background: white;
            border-radius: 28px;
            padding: 32px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 28px;
            flex-wrap: wrap;
            gap: 16px;
        }

        h1 {
            font-size: 1.6rem;
            font-weight: 700;
            background: linear-gradient(135deg, #2b6e4c, #1e4a3b);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .back-link {
            color: #6c8a9c;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: color 0.2s;
        }

        .back-link:hover {
            color: #2b6e4c;
        }

        .form-group {
            margin-bottom: 24px;
        }

        label {
            display: block;
            font-weight: 600;
            font-size: 0.85rem;
            margin-bottom: 8px;
            color: #1a3a2e;
        }

        label i {
            margin-right: 6px;
            color: #2b6e4c;
        }

        input[type="text"],
        input[type="number"],
        textarea,
        select {
            width: 100%;
            padding: 12px 16px;
            border: 1px solid #e2e8f0;
            border-radius: 16px;
            font-size: 0.9rem;
            font-family: 'Inter', sans-serif;
            transition: all 0.3s;
            background: #f8fafc;
        }

        input:focus,
        textarea:focus,
        select:focus {
            outline: none;
            border-color: #2b6e4c;
            box-shadow: 0 0 0 3px rgba(43,110,76,0.1);
            background: white;
        }

        textarea {
            resize: vertical;
            min-height: 80px;
        }

        .checkbox-group {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-top: 8px;
        }

        .checkbox-group input {
            width: auto;
            transform: scale(1.1);
        }

        .checkbox-group label {
            margin-bottom: 0;
            font-weight: normal;
        }

        .current-image {
            background: #f8fafc;
            border-radius: 16px;
            padding: 16px;
            margin-top: 8px;
            display: flex;
            align-items: center;
            gap: 16px;
            flex-wrap: wrap;
        }

        .current-image img {
            width: 80px;
            height: 80px;
            border-radius: 12px;
            object-fit: cover;
        }

        .image-actions {
            display: flex;
            align-items: center;
            gap: 16px;
            flex-wrap: wrap;
        }

        .remove-checkbox {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .form-actions {
            display: flex;
            gap: 16px;
            margin-top: 32px;
            padding-top: 24px;
            border-top: 1px solid #eef2f6;
        }

        .btn-primary {
            background: #2b6e4c;
            color: white;
            padding: 12px 28px;
            border-radius: 40px;
            text-decoration: none;
            font-weight: 600;
            border: none;
            cursor: pointer;
            font-size: 0.9rem;
            transition: all 0.3s;
        }

        .btn-primary:hover {
            background: #1e5a3e;
            transform: translateY(-2px);
        }

        .btn-secondary {
            background: #eef2f6;
            color: #475569;
            padding: 12px 28px;
            border-radius: 40px;
            text-decoration: none;
            font-weight: 600;
            border: none;
            cursor: pointer;
            font-size: 0.9rem;
            transition: all 0.3s;
        }

        .btn-secondary:hover {
            background: #e2e8f0;
        }

        .btn-danger {
            background: #fee2e2;
            color: #dc2626;
            padding: 12px 28px;
            border-radius: 40px;
            text-decoration: none;
            font-weight: 600;
            border: none;
            cursor: pointer;
            font-size: 0.9rem;
            transition: all 0.3s;
        }

        .btn-danger:hover {
            background: #fecaca;
        }

        .message {
            padding: 14px 20px;
            border-radius: 16px;
            margin-bottom: 24px;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .message-error {
            background: #fee2e2;
            color: #dc2626;
            border-left: 4px solid #dc2626;
        }

        .row-2cols {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }

        @media (max-width: 600px) {
            body { padding: 16px; }
            .card { padding: 20px; }
            .row-2cols { grid-template-columns: 1fr; }
            .form-actions { flex-direction: column; }
            .form-actions button { width: 100%; }
        }
    </style>
</head>
<body>
<div class="form-container">
    <div class="header">
        <h1><i class="fas fa-edit"></i> Edit Product</h1>
        <a href="${pageContext.request.contextPath}/ProductServlet?action=list" class="back-link">
            <i class="fas fa-arrow-left"></i> Back to Products
        </a>
    </div>

    <div class="card">
        <!-- Error Message -->
        <c:if test="${not empty message}">
            <div class="message message-error">
                <i class="fas fa-exclamation-circle"></i>
                ${message}
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/ProductServlet" method="post" enctype="multipart/form-data">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="id" value="${product.id}">

            <div class="row-2cols">
                <div class="form-group">
                    <label><i class="fas fa-box"></i> Product Name *</label>
                    <input type="text" name="productName" value="${product.name}" required>
                </div>

                <div class="form-group">
                    <label><i class="fas fa-tag"></i> Category *</label>
                    <input type="text" name="category" value="${product.category}" required>
                </div>
            </div>

            <div class="form-group">
                <label><i class="fas fa-align-left"></i> Description</label>
                <textarea name="description">${product.description}</textarea>
            </div>

            <div class="row-2cols">
                <div class="form-group">
                    <label><i class="fas fa-dollar-sign"></i> Base Price (KES) *</label>
                    <input type="number" name="price" step="0.01" value="<fmt:formatNumber value='${product.price / 1.10}' pattern='#.##'/>" required>
                    <small style="color: #6c8a9c; font-size: 0.7rem;">10% VAT will be added automatically</small>
                </div>

                <div class="form-group">
                    <label><i class="fas fa-cubes"></i> Stock Quantity *</label>
                    <input type="number" name="stockQty" value="${product.stock}" required>
                </div>
            </div>

            <div class="row-2cols">
                <div class="form-group">
                    <div class="checkbox-group">
                        <input type="checkbox" name="publicInCatalog" value="true" ${product.publicInCatalog ? 'checked' : ''}>
                        <label>Public in Catalog</label>
                    </div>
                </div>

                <div class="form-group">
                    <div class="checkbox-group">
                        <input type="checkbox" name="featuredProduct" value="true" ${product.featuredProduct ? 'checked' : ''}>
                        <label>Featured Product</label>
                    </div>
                </div>
            </div>

            <!-- Current Image Display -->
            <div class="form-group">
                <label><i class="fas fa-image"></i> Product Image</label>
                
                <c:if test="${not empty product.imagePath}">
                    <div class="current-image">
                        <img src="${pageContext.request.contextPath}/ProductServlet?action=viewImage&path=${product.imagePath}" alt="Current image">
                        <div class="image-actions">
                            <div class="remove-checkbox">
                                <input type="checkbox" name="removeImage" value="true" id="removeImage">
                                <label for="removeImage">Remove current image</label>
                            </div>
                        </div>
                    </div>
                </c:if>
                
                <div style="margin-top: 12px;">
                    <input type="file" name="productImage" accept="image/*">
                    <small style="color: #6c8a9c; font-size: 0.7rem; display: block; margin-top: 4px;">
                        Leave empty to keep current image. Max size: 10MB
                    </small>
                </div>
            </div>

            <div class="form-actions">
                <button type="submit" class="btn-primary">
                    <i class="fas fa-save"></i> Update Product
                </button>
                <a href="${pageContext.request.contextPath}/ProductServlet?action=list" class="btn-secondary">
                    <i class="fas fa-times"></i> Cancel
                </a>
                <a href="${pageContext.request.contextPath}/ProductServlet?action=delete&id=${product.id}" 
                   class="btn-danger"
                   onclick="return confirm('Delete ${product.name} permanently?')">
                    <i class="fas fa-trash"></i> Delete
                </a>
            </div>
        </form>
    </div>
</div>
</body>
</html>