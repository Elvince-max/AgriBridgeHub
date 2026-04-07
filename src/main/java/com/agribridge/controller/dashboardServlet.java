/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.agribridge.controller;

// ✅ ALL REQUIRED IMPORTS
import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;

import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 *
 * @author mukiri
 */

@WebServlet("/dashboardServlet")
public class dashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Check session (authentication)
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // 2. Get user from session
        String username = (String) session.getAttribute("username");

        // 3. Simulate fetching data (replace later with DB)
        int activeOrders = 8;
        int deliveries = 4;
        double wallet = 42850.0;

        // 4. Set data to request scope
        request.setAttribute("activeOrders", activeOrders);
        request.setAttribute("deliveries", deliveries);
        request.setAttribute("wallet", wallet);
        request.setAttribute("username", username);

        // 5. Forward to JSP
        request.getRequestDispatcher("dashboard.jsp").forward(request, response);
    }
}