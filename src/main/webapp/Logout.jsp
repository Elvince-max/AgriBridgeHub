<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Logout - Agribridge Hub</title>
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- Fonts & Icons -->
    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;700;800&family=Work+Sans:wght@400;500;600&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
</head>
<body class="min-h-screen flex flex-col items-center justify-center bg-gray-50 font-sans text-gray-900">

    <!-- Header -->
    <header class="flex items-center gap-2 mb-10">
        <span class="material-symbols-outlined text-green-700 text-3xl">potted_plant</span>
        <h1 class="text-2xl font-bold">Agribridge Hub</h1>
    </header>

    <!-- Logout Card -->
    <div class="bg-white rounded-xl shadow-lg p-8 w-full max-w-sm text-center">
        <div class="flex items-center justify-center w-20 h-20 mx-auto mb-6 rounded-full bg-yellow-100">
            <span class="material-symbols-outlined text-yellow-700 text-4xl">logout</span>
        </div>
        <h2 class="text-xl font-bold mb-3">Log Out?</h2>
        <p class="text-gray-600 mb-6">Are you sure you want to log out? You will need to log in again to continue.</p>

        <!-- Action Buttons -->
        <form action="LogoutServlet" method="post" class="flex flex-col gap-3">
            <button type="submit" class="w-full py-3 rounded-full bg-green-700 text-white font-semibold hover:bg-green-800 transition">Log Out</button>
            <a href="dashboard.jsp" class="w-full py-3 rounded-full border border-green-700 text-green-700 font-semibold hover:bg-green-50 transition">Cancel</a>
        </form>
    </div>

    <!-- Footer -->
    <footer class="mt-10 text-center text-gray-400 text-xs">
        <div class="flex items-center justify-center gap-2 mb-2 opacity-50">
            <img src="https://lh3.googleusercontent.com/aida-public/AB6AXuAgTDCdeiESWfombmtbR6PzxZAy4Pk8k8VNWoGKK457EvfCWwvRW_QA3OSeo-c3pxfsK8L9iXNxAhAV5pJVVBa8drsU94eQlzHF5rlUZgBD0KDOdvfrqm3R99HMIVw4dtV2PDCQoDFVGt3G5zC-BFYCopIyaVwjAwDayWElkBcyl0ur9Vhbozkgl6v9F74rQCi_9dPfUdArtMUSy9xCZFihgecSa2K5bmkHA7rgQ2p31k3CrqC7AMK_jxlhJcBaoGKT3TO0zwZDfaGA" alt="Egerton University Logo" class="h-6 w-auto">
            <span class="font-bold uppercase">Agriscience Labs</span>
        </div>
        Version 4.2.0 • Secure Session Environment
    </footer>

</body>
</html>