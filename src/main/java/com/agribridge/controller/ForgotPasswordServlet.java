package com.agribridge.controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "ForgotPasswordServlet", urlPatterns = {"/ForgotPasswordServlet"})
public class ForgotPasswordServlet extends HttpServlet {

    /**
     * Handles the HTTP <code>POST</code> method for password reset requests.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Set content type
        response.setContentType("text/html;charset=UTF-8");

        // Get the email input from the form
        String email = request.getParameter("email");

        try (PrintWriter out = response.getWriter()) {
            
            // Basic validation
            if (email == null || email.isEmpty()) {
                out.println("<h3>Please provide a valid email address.</h3>");
                return;
            }

//            // TODO: Here you would integrate your DB check and email sending logic
//            // For now, we just display a confirmation message
//            out.println("<!DOCTYPE html>");
//            out.println("<html>");
//            out.println("<head>");
//            out.println("<title>Forgot Password</title>");
//            out.println("<link href=\"https://cdn.tailwindcss.com\" rel=\"stylesheet\">");
//            out.println("</head>");
//            out.println("<body class='flex items-center justify-center min-h-screen bg-gray-100'>");
//            out.println("<div class='bg-white p-8 rounded shadow-md text-center'>");
//            out.println("<h2 class='text-xl font-bold mb-4'>Password Reset Request</h2>");
//            out.println("<p>If an account with <strong>" + email + "</strong> exists, you will receive instructions to reset your password.</p>");
//            out.println("<a href='Login.jsp' class='mt-6 inline-block text-green-700 font-semibold hover:underline'>Return to Login</a>");
//            out.println("</div>");
//            out.println("</body>");
//            out.println("</html>");
        }
    }

    /**
     * Handles the HTTP <code>GET</code> method by forwarding to the forgot password page.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        //  forward to ForgotPassword.jsp
        request.getRequestDispatcher("ForgotPassword.jsp").forward(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Handles password reset requests by email.";
    }
}