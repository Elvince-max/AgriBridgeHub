package com.agribridgef1.controller;

import com.agribridgef1.dao.UserDAO;
import com.agribridgef1.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        UserDAO dao = new UserDAO();
        User user = dao.loginUser(email, password);

            if (user != null) {
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                session.setAttribute("userId", user.getUserId());
                session.setAttribute("fullName", user.getFullName());
                session.setAttribute("userType", user.getUserType());

                String role = user.getUserType();

                if ("ADMIN".equals(role)) {
                    response.sendRedirect("adminDashboard.jsp");
                } else if ("STAFF".equals(role)) {
                    response.sendRedirect("manageOrders.jsp");
                } else if ("DELIVERY_AGENT".equals(role)) {
                    response.sendRedirect("delivery.jsp");
                } 
                else if ("CUSTOMER".equals(role)){
                    response.sendRedirect("customerDashboard.jsp");
                }
                else {
                    response.sendRedirect("products.jsp");
                }
                

            } else {
                response.sendRedirect("login.jsp?error=1");
            }
    }
}