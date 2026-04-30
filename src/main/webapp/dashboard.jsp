<%@ page import="java.util.*" %>
<%@ page session="true" %>
<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    Integer activeOrders = (Integer) request.getAttribute("activeOrders");
    Integer deliveries = (Integer) request.getAttribute("deliveries");
    Double wallet = (Double) request.getAttribute("wallet");

    if (activeOrders == null) activeOrders = 8;
    if (deliveries == null) deliveries = 4;
    if (wallet == null) wallet = 42850.0;
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Dashboard</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>

<body class="bg-gray-100 font-sans">

<div class="flex h-screen">

    <!-- SIDEBAR -->
    <div class="w-64 bg-white shadow-md p-5">
        <h1 class="text-xl font-bold text-green-700 mb-6">Agri-Bridge</h1>

        <ul class="space-y-4">
            <li class="text-green-700 font-semibold">Dashboard</li>
            <li class="hover:text-green-600 cursor-pointer">Marketplace</li>
            <li class="hover:text-green-600 cursor-pointer">Logistics</li>
            <li class="hover:text-green-600 cursor-pointer">Order History</li>
            <li class="hover:text-green-600 cursor-pointer">Account</li>
        </ul>

        <div class="mt-10 border-t pt-4">
            <p class="text-sm text-gray-500">Logged in as</p>
            <p class="font-semibold"><%= username %></p>
        </div>
    </div>

    <!-- MAIN CONTENT -->
    <div class="flex-1 p-8">

        <!-- HEADER -->
        <h1 class="text-3xl font-bold text-green-800 mb-6">
            Hello, <%= username %>! Here's your dashboard
        </h1>

        <!-- CARDS -->
        <div class="grid grid-cols-3 gap-6 mb-8">

            <!-- Active Orders -->
            <div class="bg-white p-6 rounded-xl shadow">
                <p class="text-gray-500">Active Orders</p>
                <h2 class="text-2xl font-bold text-green-700"><%= activeOrders %></h2>
                <p class="text-sm text-gray-400">Arriving today</p>
            </div>

            <!-- Deliveries -->
            <div class="bg-orange-100 p-6 rounded-xl shadow">
                <p class="text-gray-600">Incoming Deliveries</p>
                <h2 class="text-2xl font-bold"><%= deliveries %></h2>
                <p class="text-sm text-gray-500">Trackers active</p>
            </div>

            <!-- Wallet -->
            <div class="bg-green-700 text-white p-6 rounded-xl shadow">
                <p>Wallet Balance</p>
                <h2 class="text-2xl font-bold">KES <%= wallet %></h2>
                <p class="text-sm">Ready for checkout</p>
            </div>

        </div>

        <!-- QUICK ACTIONS -->
        <h2 class="text-xl font-semibold mb-4">Quick Actions</h2>

        <div class="grid grid-cols-4 gap-4 mb-8">

            <button class="bg-white p-4 rounded shadow hover:bg-green-50">
                Browse Marketplace
            </button>

            <button class="bg-white p-4 rounded shadow hover:bg-green-50">
                Track Orders
            </button>

           

            <button class="bg-white p-4 rounded shadow hover:bg-green-50">
                Price Drops
            </button>

        </div>

        <!-- ORDER ACTIVITY -->
        <h2 class="text-xl font-semibold mb-4">Order Activity</h2>

        <div class="bg-white p-6 rounded-xl shadow space-y-4">

            <div>
                <p class="font-semibold text-green-700">Order Placed Successfully</p>
                <p class="text-sm text-gray-500">
                    Your yoghurt order has been received.
                </p>
            </div>

            <div>
                <p class="font-semibold text-orange-600">Out for Delivery</p>
                <p class="text-sm text-gray-500">
                    Your cheese is on the way.
                </p>
            </div>

            <div>
                <p class="font-semibold text-blue-600">Payment Confirmed</p>
                <p class="text-sm text-gray-500">
                    Transaction completed successfully.
                </p>
            </div>

        </div>

    </div>

</div>

</body>
</html>