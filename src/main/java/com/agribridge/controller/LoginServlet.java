package com.agribridge.controller;

import java.io.IOException;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet(name = "LoginServlet", urlPatterns = {"/LoginServlet"})
public class LoginServlet extends HttpServlet {

    private static final String DB_URL = "jdbc:mysql://localhost:3306/Egerton_AgriBridge_Hub?useSSL=false&serverTimezone=UTC";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "YourStrongPassword123!";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ✅ Get and clean input
        String identity = request.getParameter("identity");
        String password = request.getParameter("password");

        if (identity != null) identity = identity.trim();
        if (password != null) password = password.trim();

        // ✅ Validate input
        if (identity == null || identity.isEmpty() || password == null || password.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=empty");
            return;
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {

                // ✅ Case-insensitive email match
                String sql = "SELECT * FROM users WHERE LOWER(email) = LOWER(?) OR phone = ?";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setString(1, identity);
                stmt.setString(2, identity);

                ResultSet rs = stmt.executeQuery();

                if (rs.next()) {

                    String dbPassword = rs.getString("password_hash");

                    System.out.println("User found: " + rs.getString("email"));
                    System.out.println("Entered password: " + password);
                    System.out.println("DB password: " + dbPassword);

                    //  TEMP: Plain text comparison (for testing)
                    if (password.equals(dbPassword)) {

                        // ✅Create session
                        HttpSession session = request.getSession();
                        session.setAttribute("user_id", rs.getInt("user_id"));
                        session.setAttribute("username", rs.getString("name"));
                        session.setAttribute("role_id", rs.getInt("role_id"));

                        //  Redirect properly
                        response.sendRedirect(request.getContextPath() + "/index.jsp");

                    } else {
                        System.out.println("Password mismatch");
                        response.sendRedirect(request.getContextPath() + "/login.jsp?error=invalid");
                    }

                } else {
                    System.out.println("User not found for: " + identity);
                    response.sendRedirect(request.getContextPath() + "/login.jsp?error=notfound");
                }

                rs.close();
                stmt.close();
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.setContentType("text/plain");
            response.getWriter().println("ERROR: " + e.getMessage());
        }
    }

//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        response.sendRedirect(request.getContextPath() + "/dashboard.jsp");
//    }
}