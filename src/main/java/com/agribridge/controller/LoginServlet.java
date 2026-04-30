package com.agribridge.controller;

import com.agribridge.dao.UserDAO;
import com.agribridge.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");
        String password = req.getParameter("password");

        if (email == null || password == null || email.trim().isEmpty() || password.trim().isEmpty()) {
            resp.sendRedirect("login.jsp?error=missing");
            return;
        }

        try {
            User user = userDAO.getUserByEmail(email);
            if (user == null) {
                resp.sendRedirect("login.jsp?error=invalid");
                return;
            }

            // Verify password against stored hash
            if (BCrypt.checkpw(password, user.getPasswordHash())) {
                // Login successful
                HttpSession session = req.getSession();
                session.setAttribute("userId", user.getUserId());
                session.setAttribute("userName", user.getName());
                session.setAttribute("userEmail", user.getEmail());
                // If you have role_id column, store it as well
                resp.sendRedirect("index.jsp");
            } else {
                resp.sendRedirect("login.jsp?error=invalid");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("login.jsp?error=server");
        }
    }
}