// File: DeleteProductServlet.java
package com.projectmanagement.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.projectmanagement.dao.ProductDAO;
import com.projectmanagement.model.Product;
import java.io.File;
import java.io.IOException;
import java.sql.SQLException;

public class DeleteProductServlet extends HttpServlet {
    private ProductDAO productDAO;
    
    @Override
    public void init() {
        productDAO = new ProductDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            
            // Get product to delete its image
            Product product = productDAO.getProductById(id);
            if (product != null && product.getImagePath() != null && !product.getImagePath().isEmpty()) {
                String imagePath = getServletContext().getRealPath("") + File.separator + product.getImagePath();
                File imageFile = new File(imagePath);
                if (imageFile.exists()) {
                    imageFile.delete();
                }
            }
            
            productDAO.deleteProduct(id);
            response.sendRedirect(request.getContextPath() + "/products?message=Product deleted successfully&messageType=success");
            
        } catch (SQLException | NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/products?message=Error deleting product&messageType=error");
        }
    }
}