// File: AddProductServlet.java
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

public class AddProductServlet extends HttpServlet {
    private ProductDAO productDAO;
    private static final String UPLOAD_DIR = "Uploads/images";
    
    @Override
    public void init() {
        productDAO = new ProductDAO();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            String name = request.getParameter("productName");
            String category = request.getParameter("category");
            String description = request.getParameter("description");
            double price = Double.parseDouble(request.getParameter("price"));
            int stock = Integer.parseInt(request.getParameter("stockQty"));
            
            // Handle image upload
            String imagePath = null;
            Part filePart = request.getPart("productImage");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
                String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }
                filePart.write(uploadPath + File.separator + fileName);
                imagePath = UPLOAD_DIR + "/" + fileName;
            }
            
            // Get checkbox values
            boolean publicInCatalog = request.getParameter("publicInCatalog") != null;
            boolean featuredProduct = request.getParameter("featuredProduct") != null;
            
            Product product = new Product();
            product.setName(name);
            product.setCategory(category);
            product.setDescription(description);
            product.setPrice(price);
            product.setStock(stock);
            product.setImagePath(imagePath);
            product.setPublicInCatalog(publicInCatalog);
            product.setFeaturedProduct(featuredProduct);
            
            productDAO.addProduct(product);
            
            response.sendRedirect(request.getContextPath() + "/products?message=Product added successfully&messageType=success");
            
        } catch (NumberFormatException | SQLException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/addProduct.jsp?message=Error adding product&messageType=error");
        }
    }
}