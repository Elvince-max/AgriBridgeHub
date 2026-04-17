<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>DairyBridge | Add New Product</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            background: #eef2f5;
            font-family: 'Inter', sans-serif;
            padding: 2rem 1.5rem;
            color: #1e2a32;
        }

        .dashboard-container {
            max-width: 1280px;
            margin: 0 auto;
        }

        /* Alert messages */
        .alert {
            padding: 1rem 1.2rem;
            border-radius: 20px;
            margin-bottom: 1.5rem;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .alert-success {
            background: #dff0e6;
            color: #1c6e48;
            border-left: 5px solid #1c6e48;
        }
        .alert-error {
            background: #ffe6e5;
            color: #c23d3d;
            border-left: 5px solid #c23d3d;
        }

        .page-header {
            display: flex;
            align-items: baseline;
            justify-content: space-between;
            flex-wrap: wrap;
            margin-bottom: 1.8rem;
        }
        .title-badge {
            display: flex;
            align-items: baseline;
            gap: 0.5rem;
            flex-wrap: wrap;
        }
        .catalog {
            font-size: 1.5rem;
            font-weight: 600;
            color: #2c4b3e;
            letter-spacing: -0.2px;
        }
        .separator {
            font-size: 1.6rem;
            font-weight: 400;
            color: #8aa4a0;
        }
        .new-product {
            font-size: 1.5rem;
            font-weight: 500;
            color: #1e4a6e;
            background: #e9f0f5;
            padding: 0.1rem 0.8rem;
            border-radius: 40px;
        }
        .add-text {
            font-size: 1rem;
            font-weight: 500;
            background: #2b7a4b20;
            color: #1f6e43;
            padding: 0.25rem 1rem;
            border-radius: 30px;
        }

        .product-card {
            background: #ffffff;
            border-radius: 28px;
            box-shadow: 0 12px 28px rgba(0, 0, 0, 0.05), 0 0 0 1px rgba(0, 0, 0, 0.02);
            overflow: hidden;
        }

        .two-column-layout {
            display: flex;
            flex-wrap: wrap;
        }

        .form-main {
            flex: 2;
            min-width: 260px;
            padding: 1.8rem 2rem 2rem 2rem;
            border-right: 1px solid #e6edf0;
        }

        .form-sidebar {
            flex: 1.2;
            min-width: 240px;
            padding: 1.8rem 2rem 2rem 2rem;
            background: #fefefe;
        }

        .field-group {
            margin-bottom: 1.75rem;
        }
        .field-label {
            font-size: 0.8rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: #5a6e7a;
            margin-bottom: 0.5rem;
            display: flex;
            align-items: center;
            gap: 6px;
        }
        .field-label i {
            font-size: 0.8rem;
            color: #7e9aa8;
        }
        input, textarea, select {
            width: 100%;
            padding: 0.85rem 1rem;
            font-family: 'Inter', monospace;
            font-size: 0.95rem;
            border: 1.5px solid #e2e9ef;
            border-radius: 18px;
            background: #fff;
            transition: 0.2s;
            outline: none;
            color: #1f2e36;
            font-weight: 500;
        }
        input:focus, textarea:focus, select:focus {
            border-color: #2f8b5e;
            box-shadow: 0 0 0 3px #2f8b5e20;
        }
        textarea {
            resize: vertical;
            min-height: 85px;
        }
        .row-2cols {
            display: flex;
            gap: 1.2rem;
            flex-wrap: wrap;
        }
        .row-2cols .field-group {
            flex: 1;
        }
        .action-buttons {
            display: flex;
            gap: 1rem;
            justify-content: flex-end;
            margin-top: 2rem;
            border-top: 1px solid #eef3f7;
            padding-top: 1.8rem;
        }
        .btn {
            padding: 0.7rem 1.8rem;
            border-radius: 40px;
            font-weight: 600;
            font-size: 0.9rem;
            border: none;
            cursor: pointer;
            transition: 0.2s;
            background: white;
            font-family: 'Inter', sans-serif;
        }
        .btn-cancel {
            background: #f2f6f9;
            color: #4b6e7c;
            border: 1px solid #dce6ec;
            text-decoration: none;
            display: inline-block;
        }
        .btn-cancel:hover {
            background: #e9f0f4;
        }
        .btn-save {
            background: #1c6e48;
            color: white;
            box-shadow: 0 2px 6px rgba(28,110,72,0.2);
        }
        .btn-save:hover {
            background: #0f5a3a;
            transform: translateY(-1px);
        }
        .btn-catalog {
            background: #e6f0f8;
            color: #1e4a6e;
            border: 1px solid #cddfeb;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        .btn-catalog:hover {
            background: #d6e7f5;
        }

        .image-upload-area {
            background: #f9fdfb;
            border: 2px dashed #cbdcd6;
            border-radius: 28px;
            padding: 1.2rem;
            text-align: center;
            margin-bottom: 1.8rem;
        }
        .image-preview {
            width: 100%;
            aspect-ratio: 1 / 1;
            max-height: 200px;
            object-fit: cover;
            border-radius: 20px;
            background: #f0f4f8;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 0.8rem;
            overflow: hidden;
        }
        .image-preview img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        .image-preview i {
            font-size: 3rem;
            color: #91b3a6;
        }
        .image-placeholder-text {
            font-size: 0.8rem;
            color: #538270;
            font-weight: 500;
            margin-top: 8px;
        }
        .browse-btn {
            background: #eef3f0;
            border: none;
            padding: 0.5rem 1rem;
            border-radius: 30px;
            font-size: 0.75rem;
            font-weight: 600;
            margin-top: 8px;
            cursor: pointer;
            font-family: inherit;
            width: 100%;
        }
        .remove-image-btn {
            background: #fee2e2;
            color: #dc2626;
            border: none;
            padding: 0.5rem 1rem;
            border-radius: 30px;
            font-size: 0.75rem;
            font-weight: 600;
            margin-top: 8px;
            cursor: pointer;
            font-family: inherit;
            width: 100%;
            display: none;
        }
        .remove-image-btn:hover {
            background: #fecaca;
        }
        .visibility-status {
            background: #ffffff;
            border: 1px solid #e2ede8;
            border-radius: 24px;
            padding: 1rem 1.2rem;
            margin: 1.5rem 0;
        }
        .toggle-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1rem;
        }
        .toggle-label {
            font-weight: 600;
            font-size: 0.85rem;
        }
        /* Custom toggle switch styling for checkboxes */
        .toggle-switch {
            position: relative;
            display: inline-block;
            width: 52px;
            height: 26px;
        }
        .toggle-switch input {
            opacity: 0;
            width: 0;
            height: 0;
        }
        .toggle-slider {
            position: absolute;
            cursor: pointer;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: #ccdfd8;
            transition: 0.3s;
            border-radius: 34px;
        }
        .toggle-slider:before {
            position: absolute;
            content: "";
            height: 20px;
            width: 20px;
            left: 3px;
            bottom: 3px;
            background-color: white;
            transition: 0.3s;
            border-radius: 50%;
        }
        input:checked + .toggle-slider {
            background-color: #1c6e48;
        }
        input:checked + .toggle-slider:before {
            transform: translateX(26px);
        }
        .warning-message {
            background: #fff6e5;
            border-left: 5px solid #e6a017;
            padding: 1rem;
            border-radius: 20px;
            font-size: 0.75rem;
            color: #a45d2e;
            display: flex;
            gap: 12px;
            align-items: flex-start;
        }
        .warning-message i {
            font-size: 1rem;
            margin-top: 2px;
        }
        small {
            display: block;
            font-size: 0.7rem;
            margin-top: 0.3rem;
            color: #6f8f9c;
        }

        @media (max-width: 760px) {
            body { padding: 1rem; }
            .two-column-layout { flex-direction: column; }
            .form-main { border-right: 0; border-bottom: 1px solid #e6edf0; }
            .action-buttons { justify-content: center; }
        }
    </style>
</head>
<body>
<div class="dashboard-container">
    <div class="page-header">
        <div class="title-badge">
            <span class="catalog">CATALOG</span>
            <span class="separator">|</span>
            <span class="new-product">NEW PRODUCT</span>
            <span class="add-text"><i class="fas fa-plus-circle"></i> Add Product</span>
        </div>
    </div>

    <!-- Display success/error messages -->
    <c:if test="${not empty message}">
        <div class="alert alert-${messageType}">
            <i class="fas ${messageType == 'success' ? 'fa-check-circle' : 'fa-exclamation-triangle'}"></i>
            <span>${message}</span>
        </div>
    </c:if>

    <form action="${pageContext.request.contextPath}/ProductServlet" method="POST" enctype="multipart/form-data">
        <input type="hidden" name="action" value="add">
        
        <!-- If editing an existing product -->
        <c:if test="${not empty product}">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="id" value="${product.id}">
            <input type="hidden" name="existingImage" value="${product.imagePath}">
        </c:if>
        
        <div class="product-card">
            <div class="two-column-layout">
                <div class="form-main">
                    <div class="field-group">
                        <div class="field-label"><i class="fas fa-box"></i> PRODUCT NAME</div>
                        <input type="text" name="productName" value="${not empty product ? product.name : 'Pranium Murask'}" required>
                    </div>

                    <div class="field-group">
                        <div class="field-label"><i class="fas fa-tags"></i> CATEGORY</div>
                        <select name="category">
                            <option value="Yogurt" ${not empty product and product.category == 'Yoghurt' ? 'selected' : (empty product ? 'selected' : '')}>Yoghurt</option>
                            <option value="Cheese" ${not empty product and product.category == 'Cheese' ? 'selected' : ''}>Cheese</option>
                            <option value="Ghee" ${not empty product and product.category == 'Ghee' ? 'selected' : ''}>Ghee</option>
                            <option value="Fresh Milk" ${not empty product and product.category == 'Fresh Milk' ? 'selected' : ''}>Fresh Milk</option>
                            <option value="Fermented Drinks" ${not empty product and product.category == 'Fermented Drinks' ? 'selected' : ''}>Fermented Drinks</option>
                            <option value="Butter" ${not empty product and product.category == 'Butter' ? 'selected' : ''}>Butter</option>
                            <option value="Desserts" ${not empty product and product.category == 'Desserts' ? 'selected' : ''}>Desserts</option>
                            <option value="Cream" ${not empty product and product.category == 'Cream' ? 'selected' : ''}>Cream</option>
                        </select>
                    </div>

                    <div class="field-group">
                        <div class="field-label"><i class="fas fa-align-left"></i> DESCRIPTION</div>
                        <textarea name="description">${not empty product ? product.description : 'Traditionally fermented milk stored in seasoned gourds (soteri) with charcoal from specially selected trees, providing a unique smoky aroma and rich probiotic profile.'}</textarea>
                    </div>

                    <div class="row-2cols">
                        <div class="field-group">
                            <div class="field-label"><i class="fas fa-coins"></i> PRICE (KES)</div>
                            <input type="number" name="price" value="${not empty product ? product.price : '250'}" step="0.01" min="0" required>
                        </div>
                        <div class="field-group">
                            <div class="field-label"><i class="fas fa-percent"></i> DISCOUNT</div>
                            <input type="text" name="discount" value="${not empty product.discount ? product.discount : '0%'}">
                        </div>
                    </div>

                    <div class="field-group">
                        <div class="field-label"><i class="fas fa-warehouse"></i> STOCK CONTROL</div>
                        <input type="number" name="stockQty" value="${not empty product ? product.stock : '142'}" min="0" required>
                        <small><i class="fas fa-info-circle"></i> Low stock alert threshold: 20 units</small>
                    </div>

                    <div class="action-buttons">
                        <button type="reset" class="btn btn-cancel" onclick="resetForm()">Cancel</button>

                        <!-- View Catalog Button -->
                        <a href="${pageContext.request.contextPath}/ProductServlet?action=list" class="btn btn-catalog">
                            <i class="fas fa-list"></i> View Catalog
                        </a>

                        <button type="submit" class="btn btn-save">
                            <i class="fas fa-save"></i> Save Product
                        </button>
                    </div>
                </div>

                <div class="form-sidebar">
                    <div class="field-label"><i class="fas fa-image"></i> PRODUCT IMAGE</div>
                    <div class="image-upload-area" id="imageUploadArea">
                        <div class="image-preview" id="imagePreview">
                            <c:choose>
                                <c:when test="${not empty product and not empty product.imagePath}">
                                    <img src="ProductServlet?action=viewImage&path=${product.imagePath}" alt="Product Image">
                                </c:when>
                                <c:otherwise>
                                    <i class="fas fa-cheese" style="font-size: 3rem; color: #afcdbc;"></i>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="image-placeholder-text" id="placeholderText">
                            ${not empty product and not empty product.imagePath ? 'Current image displayed' : 'No image selected'}
                        </div>
                        <button type="button" class="browse-btn" id="browseBtn">
                            <i class="fas fa-folder-open"></i> Browse Image
                        </button>
                        <button type="button" class="remove-image-btn" id="removeImageBtn" 
                                style="${not empty product and not empty product.imagePath ? 'display: block;' : 'display: none;'}">
                            <i class="fas fa-trash-alt"></i> Remove Image
                        </button>
                        <input type="file" name="productImage" id="imageInput" accept="image/*" style="display: none;">
                        <small>PNG, JPG, GIF up to 10MB. Recommended size: 500x500px</small>
                    </div>

                    <div class="visibility-status">
                        <div class="field-label" style="margin-bottom: 0.8rem;"><i class="fas fa-eye"></i> VISIBILITY & STATUS</div>
                        <div class="toggle-row">
                            <span class="toggle-label"><i class="fas fa-globe"></i> Public in Catalog</span>
                            <label class="toggle-switch">
                                <input type="checkbox" name="publicInCatalog" value="true" 
                                       ${(not empty product and product.publicInCatalog) or empty product ? 'checked' : ''}>
                                <span class="toggle-slider"></span>
                            </label>
                        </div>
                        <div class="toggle-row">
                            <span class="toggle-label"><i class="fas fa-star"></i> Featured Product</span>
                            <label class="toggle-switch">
                                <input type="checkbox" name="featuredProduct" value="true" 
                                       ${not empty product and product.featuredProduct ? 'checked' : ''}>
                                <span class="toggle-slider"></span>
                            </label>
                        </div>
                        <small><i class="fas fa-chart-line"></i> Featured items appear on homepage</small>
                    </div>

                    <div class="warning-message">
                        <i class="fas fa-snowflake"></i>
                        <div>
                            <strong>STORAGE WARNING</strong><br>
                            Fresh dairy products require refrigerated storage to prevent spoilage.
                        </div>
                    </div>
                    
                    <div style="margin-top: 1rem; font-size: 0.7rem; text-align: center; color: #6f9a88;">
                        <i class="fas fa-leaf"></i> DairyBridge · traditional excellence
                    </div>
                </div>
            </div>
        </div>
    </form>
</div>

<script>
    // Image preview functionality
    const imageInput = document.getElementById('imageInput');
    const browseBtn = document.getElementById('browseBtn');
    const removeImageBtn = document.getElementById('removeImageBtn');
    const imagePreview = document.getElementById('imagePreview');
    const placeholderText = document.getElementById('placeholderText');
    
    // Variable to track if image was changed
    let imageChanged = false;
    let currentImageSrc = null;
    
    // Store current image source for comparison
    if (imagePreview.querySelector('img')) {
        currentImageSrc = imagePreview.querySelector('img').src;
    }
    
    // Browse button click
    browseBtn.addEventListener('click', function() {
        imageInput.value = "";
        imageInput.click();
    });
    
    // Image selection handler
    imageInput.addEventListener('change', function () {
        const file = this.files[0];

        if (!file) return;

        // Validate type
        if (!file.type.startsWith('image/')) {
            alert('Please select a valid image file');
            this.value = '';
            return;
        }

        // Validate size (10MB)
        if (file.size > 10 * 1024 * 1024) {
            alert('File is too large! Max is 10MB');
            this.value = '';
            return;
        }

        // Show preview
        const reader = new FileReader();

        reader.onload = function (e) {
            imagePreview.innerHTML = `<img src="${e.target.result}" alt="Preview">`;
            placeholderText.textContent = "New image selected";
            removeImageBtn.style.display = "block";
        };

        reader.readAsDataURL(file);
    });
    
    // Remove image handler
    removeImageBtn.addEventListener('click', function() {
        if (confirm('Remove this image?')) {
            // Clear the file input
            imageInput.value = '';
            
            // Reset preview to default icon
            imagePreview.innerHTML = '<i class="fas fa-cheese" style="font-size: 3rem; color: #afcdbc;"></i>';
            placeholderText.textContent = 'No image selected';
            
            // If this was an existing product, add a hidden field to indicate image removal
            const existingImageHidden = document.querySelector('input[name="existingImage"]');
            if (existingImageHidden && existingImageHidden.value) {
                // Add flag to remove existing image
                let removeFlag = document.querySelector('input[name="removeImage"]');
                if (!removeFlag) {
                    removeFlag = document.createElement('input');
                    removeFlag.type = 'hidden';
                    removeFlag.name = 'removeImage';
                    removeFlag.value = 'true';
                    document.getElementById('productForm').appendChild(removeFlag);
                }
            }
            
            imageChanged = true;
            removeImageBtn.style.display = 'none';
        }
    });
    
    // Reset form function
    function resetForm() {
        if (confirm('Reset all form fields? Unsaved changes will be lost.')) {
            // Reset file input
            imageInput.value = '';
            
            // Reset image preview to original if editing, or default if adding
            <c:choose>
                <c:when test="${not empty product and not empty product.imagePath}">
                    imagePreview.innerHTML = `<img src="ProductServlet?action=viewImage&path=${product.imagePath}" alt="Product Image">`;
                    placeholderText.textContent = 'Current image displayed';
                    removeImageBtn.style.display = 'block';
                    removeImageBtn.textContent = 'Remove Image';
                </c:when>
                <c:otherwise>
                    imagePreview.innerHTML = '<i class="fas fa-cheese" style="font-size: 3rem; color: #afcdbc;"></i>';
                    placeholderText.textContent = 'No image selected';
                    removeImageBtn.style.display = 'none';
                </c:otherwise>
            </c:choose>
            
            imageChanged = false;
            
            // Reset other form fields
            const form = document.getElementById('productForm');
            form.reset();
            
            // Reset checkboxes specifically
            const publicCheckbox = document.querySelector('input[name="publicInCatalog"]');
            const featuredCheckbox = document.querySelector('input[name="featuredProduct"]');
            if (publicCheckbox) publicCheckbox.checked = true;
            if (featuredCheckbox) featuredCheckbox.checked = false;
        }
    }
    
    // Form validation before submit
    document.getElementById('productForm').addEventListener('submit', function(e) {
        const productName = document.querySelector('input[name="productName"]').value.trim();
        const price = document.querySelector('input[name="price"]').value;
        const stockQty = document.querySelector('input[name="stockQty"]').value;
        
        if (!productName) {
            e.preventDefault();
            alert('Please enter a product name');
            return false;
        }
        
        if (!price || parseFloat(price) <= 0) {
            e.preventDefault();
            alert('Please enter a valid price');
            return false;
        }
        
        if (!stockQty || parseInt(stockQty) < 0) {
            e.preventDefault();
            alert('Please enter a valid stock quantity');
            return false;
        }
        
        return true;
    });
    
    // Optional: Add drag and drop functionality
    const uploadArea = document.getElementById('imageUploadArea');
    
    uploadArea.addEventListener('dragover', function(e) {
        e.preventDefault();
        uploadArea.style.borderColor = '#1c6e48';
        uploadArea.style.backgroundColor = '#e8f5ef';
    });
    
    uploadArea.addEventListener('dragleave', function(e) {
        e.preventDefault();
        uploadArea.style.borderColor = '#cbdcd6';
        uploadArea.style.backgroundColor = '#f9fdfb';
    });
    
    uploadArea.addEventListener('drop', function(e) {
        e.preventDefault();

        const file = e.dataTransfer.files[0];

        if (!file || !file.type.startsWith('image/')) {
            alert('Please drop an image file');
            return;
        }

        const dataTransfer = new DataTransfer();
        dataTransfer.items.add(file);
        imageInput.files = dataTransfer.files;

        // manually trigger change
        imageInput.dispatchEvent(new Event('change'));
    });
</script>
</body>
</html>