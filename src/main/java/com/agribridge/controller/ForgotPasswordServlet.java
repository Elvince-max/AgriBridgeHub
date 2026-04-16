package com.agribridge.controller;

import com.agribridge.dao.UserDAO;
import com.agribridge.util.EmailUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.UUID;

@WebServlet("/ForgotPasswordServlet")
public class ForgotPasswordServlet extends HttpServlet {

    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");
        if (email == null || email.trim().isEmpty()) {
            req.setAttribute("error", "Email is required.");
            req.getRequestDispatcher("forgotPassword.jsp").forward(req, resp);
            return;
        }

        try {
            // Check if email exists
            boolean exists = userDAO.isEmailExists(email);
            if (!exists) {
                req.setAttribute("error", "No account found with that email.");
                req.getRequestDispatcher("forgotPassword.jsp").forward(req, resp);
                return;
            }

            // Generate unique token
            String token = UUID.randomUUID().toString();
            // Save token with 1-hour expiry
            boolean saved = userDAO.saveResetToken(email, token, 1);
            if (!saved) {
                req.setAttribute("error", "Could not process request. Try again.");
                req.getRequestDispatcher("forgotPassword.jsp").forward(req, resp);
                return;
            }

            // Build reset link (full URL)
            String resetLink = req.getScheme() + "://" + req.getServerName() + ":" + req.getServerPort()
                    + req.getContextPath() + "/resetPassword.jsp?token=" + token;

            // Try to send the email
            try {
                EmailUtil.sendResetEmail(email, resetLink);
                req.setAttribute("message", "Password reset link has been sent to your email. Please check your inbox (and spam folder).");
            } catch (Exception e) {
                // Email sending failed – log the link to the server console for testing
                System.err.println("Email sending failed: " + e.getMessage());
                System.err.println("Reset link (copy this and open in browser): " + resetLink);
                req.setAttribute("error", "Could not send email. Please contact support or try again later.");
            }

            req.getRequestDispatcher("forgotPassword.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Server error. Please try again later.");
            req.getRequestDispatcher("forgotPassword.jsp").forward(req, resp);
        }
    }
}