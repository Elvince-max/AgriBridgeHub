// File: EditProductServlet.java
package com.projectmanagement.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import com.projectmanagement.dao.ProductDAO;
import com.projectmanagement.model.Product;
import java.io.File;
import java.io.IOException;
import java.sql.SQLException;

public class EditProductServlet extends HttpServlet {
    private ProductDAO productDAO;
    private static final String UPLOAD_DIR = "Uploads/images";
    
    @Override
    public void init() {
        productDAO = new ProductDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Product product = productDAO.getProductById(id);
            request.setAttribute("product", product);
            request.getRequestDispatcher("/editProduct.jsp").forward(request, response);
        } catch (SQLException | NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/products?message=Error loading product&messageType=error");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String name = request.getParameter("name");
            String category = request.getParameter("category");
            String description = request.getParameter("description");
            double price = Double.parseDouble(request.getParameter("price"));
            int stock = Integer.parseInt(request.getParameter("quantity"));
            
            // Get existing product to preserve image if no new image uploaded
            Product existingProduct = productDAO.getProductById(id);
            String imagePath = existingProduct.getImagePath();
            
            // Handle image upload if new image is provided
            Part filePart = request.getPart("productImage");
            if (filePart != null && filePart.getSize() > 0) {
                // Delete old image if exists
                if (imagePath != null && !imagePath.isEmpty()) {
                    String oldImagePath = getServletContext().getRealPath("") + File.separator + imagePath;
                    File oldFile = new File(oldImagePath);
                    if (oldFile.exists()) {
                        oldFile.delete();
                    }
                }
                
                String fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
                String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }
                filePart.write(uploadPath + File.separator + fileName);
                imagePath = UPLOAD_DIR + "/" + fileName;
            }
            
            // Check if image should be removed
            if (request.getParameter("removeImage") != null) {
                if (imagePath != null && !imagePath.isEmpty()) {
                    String oldImagePath = getServletContext().getRealPath("") + File.separator + imagePath;
                    File oldFile = new File(oldImagePath);
                    if (oldFile.exists()) {
                        oldFile.delete();
                    }
                }
                imagePath = null;
            }
            
            boolean publicInCatalog = request.getParameter("publicInCatalog") != null;
            boolean featuredProduct = request.getParameter("featuredProduct") != null;
            
            Product product = new Product();
            product.setId(id);
            product.setName(name);
            product.setCategory(category);
            product.setDescription(description);
            product.setPrice(price);
            product.setStock(stock);
            product.setImagePath(imagePath);
            product.setPublicInCatalog(publicInCatalog);
            product.setFeaturedProduct(featuredProduct);
            
            productDAO.updateProduct(product);
            
            response.sendRedirect(request.getContextPath() + "/products?message=Product updated successfully&messageType=success");
            
        } catch (NumberFormatException | SQLException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/products?message=Error updating product&messageType=error");
        }
    }
}