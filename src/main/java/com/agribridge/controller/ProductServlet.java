package com.projectmanagement.controller;

import com.projectmanagement.dao.ProductDAO;
import com.projectmanagement.dao.CategoryDAO;
import com.projectmanagement.model.Product;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

@WebServlet(name = "ProductServlet", urlPatterns = {"/ProductServlet"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 50
)
public class ProductServlet extends HttpServlet {

    private ProductDAO productDAO = new ProductDAO();
    private CategoryDAO categoryDAO = new CategoryDAO();
    private String UPLOAD_DIR = "C:\\Users\\HP\\Documents\\DairyHubUploads";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if (action == null) {
            action = "list";
        }

        try {
            switch (action) {
                case "list":
                    listProducts(request, response);
                    break;
                case "viewImage":
                    viewImage(request, response);
                    break;
                case "delete":
                    deleteProduct(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                default:
                    listProducts(request, response);
                    break;
            }
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if (action == null) {
            action = "add";
        }

        try {
            switch (action) {
                case "add":
                    addProduct(request, response);
                    break;
                case "update":
                    updateProduct(request, response);
                    break;
                default:
                    addProduct(request, response);
                    break;
            }
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }

    private void addProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {

        try {
            String name = request.getParameter("productName");
            String category = request.getParameter("category");
            String description = request.getParameter("description");
            double basePrice = Double.parseDouble(request.getParameter("price"));
            int stock = Integer.parseInt(request.getParameter("stockQty"));
            double finalPrice = basePrice * 1.10;
            boolean publicInCatalog = "true".equals(request.getParameter("publicInCatalog"));
            boolean featuredProduct = "true".equals(request.getParameter("featuredProduct"));

            // Handle Image Upload
            String fileName = null;
            Part filePart = request.getPart("productImage");

            if (filePart != null && filePart.getSize() > 0) {
                fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
                String uploadPath = UPLOAD_DIR;

                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }

                filePart.write(uploadPath + File.separator + fileName);
            }

            // Use ProductDAO to add product
            Product product = new Product();
            product.setName(name);
            product.setCategory(category);
            product.setDescription(description);
            product.setPrice(finalPrice);
            product.setStock(stock);
            product.setImagePath(fileName);
            product.setPublicInCatalog(publicInCatalog);
            product.setFeaturedProduct(featuredProduct);

            productDAO.addProduct(product);

            request.setAttribute("message", "Product added successfully! Product ID: " + product.getId());
            request.setAttribute("messageType", "success");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "Error: " + e.getMessage());
            request.setAttribute("messageType", "error");
        }

        response.sendRedirect(request.getContextPath() + "/ProductServlet?action=list");
    }

    private void listProducts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {

        String searchTerm = request.getParameter("search");
        List<Product> products;

        // Use ProductDAO to get products
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            products = productDAO.searchProducts(searchTerm);
            request.setAttribute("searchTerm", searchTerm);
        } else {
            products = productDAO.getAllProducts();
        }

        // Get statistics using DAO
        int totalCategories = categoryDAO.getTotalCategories();
        int lowStockCount = productDAO.getLowStockCount();
        int outOfStockCount = productDAO.getOutOfStockCount();
        
        // Get categories with counts
        Map<String, Integer> categories = categoryDAO.getAllCategories();

        // Set attributes for JSP
        request.setAttribute("products", products);
        request.setAttribute("categories", categories);
        request.setAttribute("totalCategories", totalCategories);
        request.setAttribute("lowStockCount", lowStockCount);
        request.setAttribute("outOfStockCount", outOfStockCount);
        request.setAttribute("totalProducts", products.size());

        // Forward to the product management page
        request.getRequestDispatcher("/productManagement.jsp").forward(request, response);
    }

    private void viewImage(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String fileName = request.getParameter("path");

        if (fileName == null || fileName.isEmpty()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        File file = new File(UPLOAD_DIR, fileName);

        if (!file.exists()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        String mime = getServletContext().getMimeType(file.getName());
        response.setContentType(mime != null ? mime : "image/jpeg");

        try (FileInputStream in = new FileInputStream(file); OutputStream out = response.getOutputStream()) {
            byte[] buffer = new byte[4096];
            int length;
            while ((length = in.read(buffer)) != -1) {
                out.write(buffer, 0, length);
            }
        }
    }

    private void deleteProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {

        String idStr = request.getParameter("id");

        if (idStr != null && !idStr.isEmpty()) {
            try {
                int id = Integer.parseInt(idStr);
                
                // Get product to find image path
                Product product = productDAO.getProductById(id);
                
                // Delete from database using DAO
                productDAO.deleteProduct(id);
                
                // Delete the image file if it exists
                if (product != null && product.getImagePath() != null && !product.getImagePath().isEmpty()) {
                    String fullPath = UPLOAD_DIR + File.separator + product.getImagePath();
                    File imageFile = new File(fullPath);
                    if (imageFile.exists()) {
                        imageFile.delete();
                    }
                }

                request.setAttribute("message", "Product deleted successfully!");
                request.setAttribute("messageType", "success");

            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("message", "Error deleting product: " + e.getMessage());
                request.setAttribute("messageType", "error");
            }
        }

        listProducts(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {

        String idStr = request.getParameter("id");

        if (idStr != null && !idStr.isEmpty()) {
            try {
                int id = Integer.parseInt(idStr);
                Product product = productDAO.getProductById(id);
                if (product != null) {
                    request.setAttribute("product", product);
                    request.getRequestDispatcher("/editProduct.jsp").forward(request, response);
                    return;
                }
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("message", "Error loading product: " + e.getMessage());
                request.setAttribute("messageType", "error");
            }
        }

        listProducts(request, response);
    }

    private void updateProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {

        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String name = request.getParameter("productName");
            String category = request.getParameter("category");
            String description = request.getParameter("description");
            double basePrice = Double.parseDouble(request.getParameter("price"));
            int stock = Integer.parseInt(request.getParameter("stockQty"));
            double finalPrice = basePrice * 1.10;
            boolean publicInCatalog = "true".equals(request.getParameter("publicInCatalog"));
            boolean featuredProduct = "true".equals(request.getParameter("featuredProduct"));
            boolean removeImage = "true".equals(request.getParameter("removeImage"));

            // Get existing product
            Product existingProduct = productDAO.getProductById(id);
            
            // Handle image upload
            String fileName = existingProduct.getImagePath();
            Part filePart = request.getPart("productImage");

            // Upload new image if provided
            if (filePart != null && filePart.getSize() > 0) {
                // Delete old image
                if (existingProduct.getImagePath() != null && !existingProduct.getImagePath().isEmpty()) {
                    String fullPath = UPLOAD_DIR + File.separator + existingProduct.getImagePath();
                    File oldFile = new File(fullPath);
                    if (oldFile.exists()) {
                        oldFile.delete();
                    }
                }

                fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
                String uploadPath = UPLOAD_DIR;
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }
                filePart.write(uploadPath + File.separator + fileName);
            }

            // Remove image if requested
            if (removeImage) {
                if (existingProduct.getImagePath() != null && !existingProduct.getImagePath().isEmpty()) {
                    String fullPath = UPLOAD_DIR + File.separator + existingProduct.getImagePath();
                    File oldFile = new File(fullPath);
                    if (oldFile.exists()) {
                        oldFile.delete();
                    }
                }
                fileName = null;
            }

            // Update product using DAO
            Product product = new Product();
            product.setId(id);
            product.setName(name);
            product.setCategory(category);
            product.setDescription(description);
            product.setPrice(finalPrice);
            product.setStock(stock);
            product.setImagePath(fileName);
            product.setPublicInCatalog(publicInCatalog);
            product.setFeaturedProduct(featuredProduct);

            productDAO.updateProduct(product);

            request.setAttribute("message", "Product updated successfully!");
            request.setAttribute("messageType", "success");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "Error updating product: " + e.getMessage());
            request.setAttribute("messageType", "error");
        }

        listProducts(request, response);
    }
}