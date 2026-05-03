package com.agribridgef1.controller;

import com.agribridgef1.dao.OrderDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;

@WebServlet("/updateDeliveryStatus")
public class UpdateDeliveryStatusServlet extends HttpServlet {

    private static final Set<String> ALLOWED_STATUSES = new HashSet<>(Arrays.asList(
            "ASSIGNED",
            "PICKED_UP",
            "IN_TRANSIT",
            "DELIVERED",
            "FAILED"
    ));

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String userType = (String) session.getAttribute("userType");

        if (!"DELIVERY_AGENT".equals(userType)) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            int agentId = (int) session.getAttribute("userId");
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            String deliveryStatus = request.getParameter("deliveryStatus");

            if (deliveryStatus == null || !ALLOWED_STATUSES.contains(deliveryStatus)) {
                response.sendRedirect("delivery.jsp?status=error");
                return;
            }

            OrderDAO dao = new OrderDAO();
            dao.updateDeliveryStatus(orderId, agentId, deliveryStatus);

            response.sendRedirect("delivery.jsp?status=updated");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("delivery.jsp?status=error");
        }
    }
}