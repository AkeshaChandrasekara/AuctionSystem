<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Login - AuctionX</title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600;700&display=swap" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            background-color: #ffffff;
            height: 100vh;
            display: flex;
            font-family: 'Montserrat', sans-serif;
        }

        .split-container {
            display: flex;
            width: 100%;
            height: 100%;
        }

        .image-half {
            flex: 1.3;
            background: linear-gradient(135deg, #1976d2, #0d47a1);
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            padding: 2rem;
            color: white;
            position: relative;
            overflow: hidden;
        }

        .image-half::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(255,255,255,0.1) 0%, rgba(255,255,255,0) 70%);
            animation: rotateGradient 15s linear infinite;
        }

        .auction-title {
            text-align: center;
            z-index: 2;
        }

        /* Animation Option 1: Fade In Staggered */
        .fade-in-staggered h1:nth-child(1) {
            animation: fadeInUp 0.8s ease-out 0.3s both;
        }
        .fade-in-staggered h2 {
            animation: fadeInUp 0.8s ease-out 0.6s both;
        }
        .fade-in-staggered h1:nth-child(3) {
            animation: fadeInUp 0.8s ease-out 0.9s both;
        }

        .auction-title h1 {
            font-size: 3.5rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
            text-transform: uppercase;
            letter-spacing: 3px;
            opacity: 0; /* Start invisible for animations */
        }

        .auction-title h2 {
            font-size: 2rem;
            font-weight: 600;
            margin-bottom: 1.5rem;
            letter-spacing: 5px;
            opacity: 0; /* Start invisible for animations */
        }

        /* Keyframe Animations */
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @keyframes rotateGradient {
            from {
                transform: rotate(0deg);
            }
            to {
                transform: rotate(360deg);
            }
        }

        .login-half {
            flex: 2;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 2rem;
            background-color: #ffffff;
        }

        .login-container {
            width: 100%;
            max-width: 420px;
            background: #fbfbfb;
            padding: 2rem; /* Reduced from 3rem */
            border-radius: 8px;
            box-shadow: 0 15px 30px rgba(13, 71, 161, 0.1);
            position: relative;
        }

        .login-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 4px;
            height: 100%;
            background: linear-gradient(to bottom, #1976d2, #0d47a1);
        }

        .logo-container {
            display: flex;
            justify-content: center;
            align-items: center;
            margin-bottom: 1.5rem; /* Reduced from 2.5rem */
        }

        .logo-container i {
            margin-right: 12px;
            color: #1976d2;
            font-size: 2.5rem;
        }

        .logo-container span {
            font-size: 2.4rem;
            font-weight: 700;
            color: #0d47a1;
            letter-spacing: -0.5px;
        }

        .login-header {
            text-align: center;
            margin-bottom: 1.5rem; /* Reduced from 2.5rem */
        }

        .login-header h2 {
            color: #0d47a1;
            font-size: 1.6rem;
            font-weight: 600;
            margin-bottom: 0.5rem;
        }

        .login-header p {
            color: #607d8b;
            font-size: 0.95rem;
        }

        .form-group {
            margin-bottom: 1.25rem; /* Reduced from 1.75rem */
            position: relative;
        }

        label {
            display: block;
            margin-bottom: 0.5rem; /* Reduced from 0.75rem */
            color: #455a64;
            font-size: 0.95rem;
            font-weight: 500;
        }

        input[type="text"],
        input[type="password"] {
            width: 100%;
            padding: 12px 14px; /* Reduced from 14px 16px */
            border: 1px solid #cfd8dc;
            border-radius: 6px;
            font-size: 0.95rem;
            transition: all 0.3s ease;
            background-color: #f5f7fa;
        }

        input[type="text"]:focus,
        input[type="password"]:focus {
            border-color: #1976d2;
            outline: none;
            box-shadow: 0 0 0 3px rgba(25, 118, 210, 0.1);
            background-color: white;
        }

        .btn-container {
            margin-top: 1.5rem; /* Reduced from 2.5rem */
        }

        button {
            background: linear-gradient(to right, #1976d2, #0d47a1);
            color: white;
            padding: 12px; /* Reduced from 14px */
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 1rem;
            font-weight: 600;
            transition: all 0.3s ease;
            width: 100%;
            box-shadow: 0 4px 6px rgba(13, 71, 161, 0.15);
        }

        button:hover {
            transform: translateY(-2px);
            box-shadow: 0 7px 14px rgba(13, 71, 161, 0.2);
        }

        .error {
            color: #d32f2f;
            margin-bottom: 1rem; /* Reduced from 1.5rem */
            padding: 10px; /* Reduced from 12px */
            background-color: #ffebee;
            border-radius: 6px;
            text-align: center;
            font-size: 0.9rem;
            border: 1px solid #ef9a9a;
        }

        /* Google Sign-In Button Styles */
        .google-btn {
            display: flex;
            align-items: center;
            justify-content: center;
            background: white;
            color: #757575;
            padding: 10px; /* Reduced from 12px */
            border-radius: 6px;
            border: 1px solid #ddd;
            font-size: 0.95rem;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
            width: 100%;
            margin-top: 0.75rem; /* Reduced from 1rem */
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .google-btn:hover {
            background: #f7f7f7;
            box-shadow: 0 3px 6px rgba(0,0,0,0.15);
        }

        .google-btn i {
            margin-right: 10px;
            color: #4285F4;
            font-size: 1.2rem;
        }

        .divider {
            display: flex;
            align-items: center;
            margin: 1rem 0; /* Reduced from 1.5rem */
            color: #90a4ae;
            font-size: 0.85rem;
        }

        .divider::before,
        .divider::after {
            content: "";
            flex: 1;
            border-bottom: 1px solid #cfd8dc;
        }

        .divider::before {
            margin-right: 1rem;
        }

        .divider::after {
            margin-left: 1rem;
        }

        /* New styles for create account link */
        .create-account {
            text-align: center;
            margin-top: 1.5rem;
            font-size: 0.9rem;
            color: #455a64;
        }

        .create-account a {
            color: #1976d2;
            text-decoration: none;
            font-weight: 600;
            transition: color 0.2s;
        }

        .create-account a:hover {
            color: #0d47a1;
            text-decoration: underline;
        }

        @media (max-width: 768px) {
            .split-container {
                flex-direction: column;
            }

            .image-half {
                padding: 1.5rem;
            }

            .auction-title h1 {
                font-size: 2.5rem;
            }

            .auction-title h2 {
                font-size: 1.5rem;
            }

            .login-container {
                padding: 1.5rem; /* Reduced from 2rem */
            }
        }
    </style>
</head>
<body>
<div class="split-container">
    <div class="image-half">
        <div class="auction-title fade-in-staggered">
            <h1>BID</h1>
            <h2>WITH</h2>
            <h1>AUCTIONX</h1>
        </div>
    </div>

    <div class="login-half">
        <div class="login-container">
            <div class="logo-container">
                <i class="fas fa-gavel"></i>
                <span>AuctionX</span>
            </div>

            <div class="login-header">
                <h2>Login to Your Account</h2>
                <p>Enter your credentials to continue</p>
            </div>

            <% if (request.getAttribute("error") != null) { %>
            <div class="error"><%= request.getAttribute("error") %></div>
            <% } %>

            <form action="login" method="post">
                <div class="form-group">
                    <label for="username">Username</label>
                    <input type="text" id="username" name="username" placeholder="Enter your username" required>
                </div>

                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" placeholder="Enter your password" required>
                </div>

                <div class="btn-container">
                    <button type="submit">Sign In</button>
                </div>
            </form>

            <div class="create-account">
                Don't have an account? <a href="/register">Create account</a>
            </div>

            <div class="divider">OR</div>

            <button class="google-btn" onclick="window.location.href='/auth/google'">
                <i class="fab fa-google"></i>
                Continue with Google
            </button>
        </div>
    </div>
</div>
</body>
</html>