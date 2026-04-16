package com.agribridge.controller;

import com.agribridge.dao.UserDAO;
import com.agribridge.model.User;
import org.mindrot.jbcrypt.BCrypt;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/ResetPasswordServlet")
public class ResetPasswordServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String token = req.getParameter("token");
        String password = req.getParameter("password");
        String confirmPassword = req.getParameter("confirm_password");

        if (token == null || token.isEmpty()) {
            resp.sendRedirect("forgotPassword.jsp?error=Invalid token");
            return;
        }
        if (password == null || !password.equals(confirmPassword)) {
            resp.sendRedirect("resetPassword.jsp?token=" + token + "&error=Passwords do not match");
            return;
        }
        if (password.length() < 6) {
            resp.sendRedirect("resetPassword.jsp?token=" + token + "&error=Password must be at least 6 characters");
            return;
        }

        try {
            User user = userDAO.getUserByResetToken(token);
            if (user == null) {
                resp.sendRedirect("forgotPassword.jsp?error=Invalid or expired reset link");
                return;
            }

            String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
            boolean updated = userDAO.updatePassword(user.getUserId(), hashedPassword);
            if (updated) {
                resp.sendRedirect("login.jsp?message=Password reset successfully. Please login.");
            } else {
                resp.sendRedirect("resetPassword.jsp?token=" + token + "&error=Failed to update password");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("forgotPassword.jsp?error=Server error");
        }
    }
}