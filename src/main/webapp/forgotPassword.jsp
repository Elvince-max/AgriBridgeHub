<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
      <meta charset="UTF-8">
    <title>Forgot Password</title>
    <link rel="stylesheet" href="styles.css">
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;600;700;800&amp;family=Work+Sans:wght@300;400;500;600&amp;display=swap" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f5f5f5;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .forgot-container {
            background-color: #fff;
            padding: 30px 40px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            width: 350px;
        }
        .forgot-container h2 {
            text-align: center;
            margin-bottom: 20px;
        }
        .forgot-container label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }
        .forgot-container input[type="email"] {
            width: 100%;
            padding: 10px;
            margin-bottom: 15px;
            border-radius: 5px;
            border: 1px solid #ccc;
        }
        .forgot-container button {
            width: 100%;
            padding: 10px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        .forgot-container button:hover {
            background-color: #45a049;
        }
        .login-link {
            text-align: center;
            margin-top: 15px;
        }
        .login-link a {
            text-decoration: none;
            color: #4CAF50;
            
        }
    </style>
</head>
<body>
<div class="forgot-container">
    <h2>Forgot Password</h2>
    <p>Enter your email and you will receive instructions on how to reset your password</p>
    <form action="ForgotPasswordServlet" method="post">
        
        <label for="email">Enter your email address:</label>
        <input type="email" id="email" name="email" placeholder="you@example.com" required>
        <button type="submit">Reset Password</button>
    </form>
    <div class="login-link"  >
        <a href="login.jsp" class="font-semibold hover:underline">Return to Login</a>
    </div>
</div>
</body>
</html>