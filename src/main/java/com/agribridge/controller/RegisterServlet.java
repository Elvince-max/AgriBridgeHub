package com.agribridge.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/RegisterServlet"})
public class RegisterServlet extends HttpServlet {

    private static final String DB_URL = "jdbc:mysql://localhost:3306/Egerton_AgriBridge_Hub?useSSL=false&serverTimezone=UTC";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "YourStrongPassword123!";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String fullName = request.getParameter("full_name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String roleName = request.getParameter("role_name");
        String terms = request.getParameter("terms");

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        try {
            // 🔹 VALIDATION
            if (fullName.isEmpty() || email.isEmpty() || password.isEmpty() || roleName.isEmpty()) {
                out.println("<h3 style='color:red;'>All fields are required!</h3>");
                return;
            }

            if (terms == null) {
                out.println("<h3 style='color:red;'>Accept terms to continue!</h3>");
                return;
            }

            // 🔹 CONNECT DB
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            // 🔹 CHECK EMAIL
            String checkSql = "SELECT user_id FROM users WHERE email = ?";
            PreparedStatement checkStmt = conn.prepareStatement(checkSql);
            checkStmt.setString(1, email);
            ResultSet checkRs = checkStmt.executeQuery();

            if (checkRs.next()) {
                out.println("<h3 style='color:red;'>Email already exists!</h3>");
                return;
            }

            // 🔹 GET ROLE ID (IMPORTANT FIX)
            String roleSql = "SELECT role_id FROM roles WHERE role_name = ?";
            PreparedStatement roleStmt = conn.prepareStatement(roleSql);
            roleStmt.setString(1, roleName);

            ResultSet roleRs = roleStmt.executeQuery();

            int roleId;
            if (roleRs.next()) {
                roleId = roleRs.getInt("role_id");
            } else {
                out.println("<h3 style='color:red;'>Selected role does not exist!</h3>");
                return;
            }

            // 🔹 INSERT USER
            String insertSql = "INSERT INTO users (name, email, phone, password_hash, role_id) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(insertSql);

            stmt.setString(1, fullName);
            stmt.setString(2, email);
            stmt.setString(3, phone);
            stmt.setString(4, password); // ⚠️ hash later
            stmt.setInt(5, roleId);

            int rows = stmt.executeUpdate();

            if (rows > 0) {
                response.sendRedirect("login.jsp");
            } else {
                out.println("<h3 style='color:red;'>Registration failed!</h3>");
            }

            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
            out.println("<h3 style='color:red;'>Error: " + e.getMessage() + "</h3>");
        }
    }
}