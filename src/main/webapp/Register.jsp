<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    // ✅ Correct attribute name
    List<String> rolesList = (List<String>) request.getAttribute("rolesList");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Register</title>
<script src="https://cdn.tailwindcss.com"></script>
</head>

<body class="bg-gray-100 flex items-center justify-center min-h-screen">
    

<div class="bg-white p-8 rounded-lg shadow-md w-full max-w-md">

    <h2 class="text-2xl font-bold mb-6 text-center">Create Account</h2>

    <form action="RegisterServlet" method="POST" class="space-y-4">

       
    <!-- NAME: only letters and spaces -->
    <input type="text" name="full_name" placeholder="Full Name"
           pattern="^[A-Za-z ]+$"
           title="Name should contain only letters and spaces"
           class="w-full p-3 border rounded" required />

        <input type="email" name="email" placeholder="Email"
               class="w-full p-3 border rounded" required />

        <!-- PHONE: numbers only, 10–14 digits -->
    <input type="tel" name="phone" placeholder="Phone"
           pattern="^[0-9]{10,14}$"
           title="Phone must be between 10 and 14 digits"
           class="w-full p-3 border rounded" required />

        <input type="password" name="password" placeholder="Password"
               class="w-full p-3 border rounded" required />

        
        <!-- ✅ Dynamic ROLE SELECTION -->
<!--        <select name="role_name" class="w-full p-3 border rounded" required>
            <option value="">Select Role</option>
            <% if (rolesList != null) {
                   for (String role : rolesList) { %>
                      <option value="<%= role %>"><%= role %></option>
            <%     }
               } %>
        </select>-->

               
        <label class="flex items-center space-x-2 text-sm">
            <input type="checkbox" name="terms" required />
            <span>I agree to Terms & Policy</span>
        </label>

        <button type="submit"
                class="w-full bg-green-700 text-white p-3 rounded hover:bg-green-800 transition">
            Register
        </button>

        <p class="text-center text-sm text-gray-500 mt-4">
            Already have an account? 
            <a href="login.jsp" class="text-green-700 font-semibold hover:underline">Log in here</a>
        </p>

    </form>

</div>

</body>
</html>