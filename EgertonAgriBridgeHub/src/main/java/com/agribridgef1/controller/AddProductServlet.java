package com.agribridgef1.controller;

import com.agribridgef1.dao.ProductDAO;
import com.agribridgef1.model.Product;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.File;
import java.io.IOException;

@WebServlet("/addProduct")
@MultipartConfig
public class AddProductServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userType") == null ||
                !"ADMIN".equals(session.getAttribute("userType"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            String name = request.getParameter("name");
            String desc = request.getParameter("description");

            double price = Double.parseDouble(request.getParameter("price"));
            int qty = Integer.parseInt(request.getParameter("quantity"));

            if (name == null || name.trim().isEmpty() || price <= 0 || qty < 0) {
                response.sendRedirect("addProduct.jsp?status=error");
                return;
            }

            Part filePart = request.getPart("imageFile");

            String imagePath = "";

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

            Product product = new Product(name.trim(), desc, price, qty, imagePath);

            ProductDAO dao = new ProductDAO();
            dao.addProduct(product);

            response.sendRedirect("addProduct.jsp?success=1");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("addProduct.jsp?status=error");
        }
    }
}