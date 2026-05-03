package com.agribridgef1.controller;

import com.agribridgef1.dao.OrderDAO;
import com.agribridgef1.dao.ProductDAO;
import com.agribridgef1.model.Order;
import com.agribridgef1.model.OrderItem;
import com.agribridgef1.model.Product;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@WebServlet("/placeOrder")
public class OrderServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute("cart");

        if (cart == null || cart.isEmpty()) {
            response.sendRedirect("cart.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        String deliveryAddress = request.getParameter("deliveryAddress");
        String deliveryTime = request.getParameter("deliveryTime");

        ProductDAO productDAO = new ProductDAO();

        double total = 0;
        List<OrderItem> items = new ArrayList<>();

        for (Map.Entry<Integer, Integer> entry : cart.entrySet()) {
            Product product = productDAO.getProductById(entry.getKey());
            int quantity = entry.getValue();

            total += product.getPrice() * quantity;
            items.add(new OrderItem(product.getProductId(), quantity, product.getPrice()));
        }

        Order order = new Order(userId, deliveryAddress, deliveryTime, "PENDING", total);

        OrderDAO orderDAO = new OrderDAO();
        int orderId = orderDAO.createOrder(order, items);

        if (orderId > 0) {
            session.removeAttribute("cart");
            response.sendRedirect("orderConfirmation.jsp?orderId=" + orderId);
        } else {
            response.sendRedirect("checkout.jsp?error=1");
        }
    }
}