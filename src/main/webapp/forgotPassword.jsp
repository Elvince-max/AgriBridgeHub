<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Forgot Password - EgertonAgriBridgeHub</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 flex items-center justify-center h-screen">
    <div class="bg-white p-8 rounded-lg shadow-md w-96">
        <h2 class="text-2xl font-bold text-center text-green-700 mb-4">Forgot Password</h2>
        <p class="text-gray-600 text-center mb-6">Enter your email and we'll send you a reset link.</p>
        
        <%-- Show success or error messages --%>
        <% if (request.getAttribute("message") != null) { %>
            <div class="bg-green-100 text-green-700 p-3 rounded mb-4"><%= request.getAttribute("message") %></div>
        <% } %>
        <% if (request.getAttribute("error") != null) { %>
            <div class="bg-red-100 text-red-700 p-3 rounded mb-4"><%= request.getAttribute("error") %></div>
        <% } %>
        
        <form action="ForgotPasswordServlet" method="post">
            <label class="block text-gray-700 font-semibold mb-2">Email Address</label>
            <input type="email" name="email" required 
                   class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-green-500">
            <button type="submit" 
                    class="w-full mt-4 bg-green-600 text-white py-2 rounded-md hover:bg-green-700 transition">
                Send Reset Link
            </button>
        </form>
        <div class="text-center mt-4">
            <a href="login.jsp" class="text-green-600 hover:underline">Back to Login</a>
        </div>
    </div>
</body>
</html>