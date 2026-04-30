<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Reset Password - EgertonAgriBridgeHub</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 flex items-center justify-center h-screen">
    <div class="bg-white p-8 rounded-lg shadow-md w-96">
        <h2 class="text-2xl font-bold text-center text-green-700 mb-4">Reset Password</h2>
        
        <%
            String token = request.getParameter("token");
            String error = request.getParameter("error");
            
            // Display error message if present
            if (error != null && !error.trim().isEmpty()) {
        %>
            <div class="bg-red-100 text-red-700 p-3 rounded mb-4"><%= error %></div>
        <%
            }
            
            if (token == null || token.trim().isEmpty()) {
        %>
            <div class="bg-red-100 text-red-700 p-3 rounded mb-4">Invalid or missing reset token.</div>
        <% } else { %>
            <form action="ResetPasswordServlet" method="post">
                <input type="hidden" name="token" value="<%= token %>">
                <label class="block text-gray-700 font-semibold mb-2">New Password</label>
                <input type="password" name="password" required 
                       class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-green-500">
                <label class="block text-gray-700 font-semibold mt-3 mb-2">Confirm Password</label>
                <input type="password" name="confirm_password" required 
                       class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-green-500">
                <button type="submit" 
                        class="w-full mt-4 bg-green-600 text-white py-2 rounded-md hover:bg-green-700 transition">
                    Update Password
                </button>
            </form>
        <% } %>
        <div class="text-center mt-4">
            <a href="login.jsp" class="text-green-600 hover:underline">Return to Login</a>
        </div>
    </div>
</body>
</html>