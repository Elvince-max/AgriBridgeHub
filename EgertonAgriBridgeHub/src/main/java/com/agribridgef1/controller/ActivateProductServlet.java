package com.agribridgef1.controller;

import com.agribridgef1.dao.ProductDAO;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/activateProduct")
public class ActivateProductServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int productId = Integer.parseInt(request.getParameter("id"));

        ProductDAO dao = new ProductDAO();
        dao.activateProduct(productId);

        response.sendRedirect("manageProducts.jsp");
    }
}