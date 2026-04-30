package com.agribridge.controller;

import com.agribridge.model.Cart;
import com.agribridge.model.CartItem;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/CartServlet")
public class CartServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        HttpSession session = req.getSession();
        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null) {
            cart = new Cart();
            session.setAttribute("cart", cart);
        }

        if ("add".equals(action)) {
            int productId = Integer.parseInt(req.getParameter("productId"));
            String name = req.getParameter("name");
            double price = Double.parseDouble(req.getParameter("price"));
            int quantity = Integer.parseInt(req.getParameter("quantity"));
            String imageUrl = req.getParameter("imageUrl");
            cart.addItem(new CartItem(productId, name, price, quantity, imageUrl));
            resp.setContentType("application/json");
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("cartSize", cart.getItems().size());
            response.put("cartTotal", cart.getTotal());
            new Gson().toJson(response, resp.getWriter());
        } 
        else if ("update".equals(action)) {
            int productId = Integer.parseInt(req.getParameter("productId"));
            int quantity = Integer.parseInt(req.getParameter("quantity"));
            cart.updateQuantity(productId, quantity);
            resp.sendRedirect("cart.jsp");
        }
        else if ("remove".equals(action)) {
            int productId = Integer.parseInt(req.getParameter("productId"));
            cart.removeItem(productId);
            resp.sendRedirect("cart.jsp");
        }
        else if ("clear".equals(action)) {
            cart.clear();
            resp.sendRedirect("cart.jsp");
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        HttpSession session = req.getSession();
        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null) {
            cart = new Cart();
            session.setAttribute("cart", cart);
        }
        if ("clear".equals(action)) {
            cart.clear();
            resp.sendRedirect("cart.jsp");
        }
        else if ("remove".equals(action)) {
            int productId = Integer.parseInt(req.getParameter("productId"));
            cart.removeItem(productId);
            resp.sendRedirect("cart.jsp");
        }
        else if ("update".equals(action)) {
            int productId = Integer.parseInt(req.getParameter("productId"));
            int quantity = Integer.parseInt(req.getParameter("quantity"));
            cart.updateQuantity(productId, quantity);
            resp.sendRedirect("cart.jsp");
        }
        else {
            req.getRequestDispatcher("cart.jsp").forward(req, resp);
        }
    }
}