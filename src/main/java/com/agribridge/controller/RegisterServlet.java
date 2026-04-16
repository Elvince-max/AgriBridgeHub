package com.agribridge.controller;

import com.agribridge.dao.UserDAO;
import com.agribridge.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/RegisterServlet"})
public class RegisterServlet extends HttpServlet {

    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String fullName = request.getParameter("full_name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
        String terms = request.getParameter("terms");

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        // Validation
        if (fullName == null || fullName.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            out.println("<h3 style='color:red;'>All fields are required!</h3>");
            return;
        }

        if (terms == null) {
            out.println("<h3 style='color:red;'>Accept terms to continue!</h3>");
            return;
        }

        try {
            // Check if email already exists
            if (userDAO.isEmailExists(email)) {
                out.println("<h3 style='color:red;'>Email already exists!</h3>");
                return;
            }

            // Create User object (password not hashed yet – you should hash it)
            User user = new User(fullName, email, phone, hashedPassword);

            // Register user
            boolean success = userDAO.registerUser(user);
            if (success) {
                response.sendRedirect("login.jsp");
            } else {
                out.println("<h3 style='color:red;'>Registration failed!</h3>");
            }

        } catch (Exception e) {
            e.printStackTrace();
            out.println("<h3 style='color:red;'>Error: " + e.getMessage() + "</h3>");
        }
    }
}