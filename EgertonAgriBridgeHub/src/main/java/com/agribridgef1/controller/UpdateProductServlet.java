package com.agribridgef1.controller;

import com.agribridgef1.dao.ProductDAO;
import com.agribridgef1.model.Product;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.File;
import java.io.IOException;

@WebServlet("/updateProduct")
@MultipartConfig
public class UpdateProductServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userType") == null ||
                !"ADMIN".equals(session.getAttribute("userType"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        int productId = 0;

        try {
            productId = Integer.parseInt(request.getParameter("productId"));

            String name = request.getParameter("name");
            String desc = request.getParameter("description");

            double price = Double.parseDouble(request.getParameter("price"));
            int qty = Integer.parseInt(request.getParameter("quantity"));

            String oldImage = request.getParameter("oldImage");

            if (name == null || name.trim().isEmpty() || price <= 0 || qty < 0) {
                response.sendRedirect("editProduct.jsp?id=" + productId + "&status=error");
                return;
            }

            Part filePart = request.getPart("imageFile");

            String imagePath = oldImage;

            if (filePart != null && filePart.getSize() > 0) {
                String submittedName = filePart.getSubmittedFileName();

                String extension = "";
                int dotIndex = submittedName.lastIndexOf(".");
                if (dotIndex >= 0) {
                    extension = submittedName.substring(dotIndex);
                }

                String fileName = "product_" + System.currentTimeMillis() + extension;

                String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";

                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }

                String filePath = uploadPath + File.separator + fileName;
                filePart.write(filePath);

                imagePath = "uploads/" + fileName;
            }

            Product product = new Product();
            product.setProductId(productId);
            product.setProductName(name.trim());
            product.setDescription(desc);
            product.setPrice(price);
            product.setStockQuantity(qty);
            product.setImageUrl(imagePath);

            ProductDAO dao = new ProductDAO();
            dao.updateProduct(product);

            response.sendRedirect("manageProducts.jsp");

        } catch (Exception e) {
            e.printStackTrace();

            if (productId > 0) {
                response.sendRedirect("editProduct.jsp?id=" + productId + "&status=error");
            } else {
                response.sendRedirect("manageProducts.jsp");
            }
        }
    }
}