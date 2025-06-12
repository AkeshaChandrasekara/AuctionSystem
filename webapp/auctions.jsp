<%@ page import="com.auction.entity.Auction" %>
<%@ page import="com.auction.entity.User" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Auctions - AuctionX</title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-color: #1976d2;
            --primary-dark: #0d47a1;
            --secondary-color: #455a64;
            --success-color: #388e3c;
            --error-color: #d32f2f;
            --text-color: #263238;
            --light-bg: #f5f7fa;
            --border-color: #cfd8dc;
        }

        body {
            font-family: 'Montserrat', sans-serif;
            margin: 0;
            padding: 0;
            background-color: var(--light-bg);
            color: var(--text-color);
            line-height: 1.6;
        }

        .container {
            max-width: 2000px;
            margin: 0 auto;
            padding: 2rem;
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2.5rem;
            padding-bottom: 1.5rem;
            border-bottom: 1px solid var(--border-color);
        }

        .header h1 {
            font-size: 2rem;
            font-weight: 700;
            color: var(--primary-dark);
            margin: 0;
            letter-spacing: -0.5px;
        }

        .user-info {
            display: flex;
            align-items: center;
            gap: 1rem;
            font-weight: 500;
            color: var(--secondary-color);
        }

        .logout-link {
            color: var(--primary-dark);
            text-decoration: none;
            font-weight: 600;
            padding: 0.5rem 1rem;
            border-radius: 6px;
            transition: all 0.3s ease;
            background-color: rgba(25, 118, 210, 0.1);
        }

        .logout-link:hover {
            background-color: rgba(25, 118, 210, 0.2);
            transform: translateY(-1px);
        }

        .auction-list {
            display: grid;
            grid-template-columns: repeat(5, minmax(200px, 1fr));
            gap: 1rem;
        }

        .auction-card {
            background: white;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 10px 20px rgba(13, 71, 161, 0.1);
            transition: all 0.3s ease;
            display: flex;
            flex-direction: column;
            height: 100%;
            position: relative;
        }

        .auction-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 30px rgba(13, 71, 161, 0.15);
        }

        .auction-status {
            position: absolute;
            top: 10px;
            right: 10px;
            background-color: #a10303;
            color: white;
            padding: 0.25rem 0.5rem;
            border-radius: 4px;
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            z-index: 1;
        }

        .auction-image-container {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 150px;
            padding: 1rem;
            background-color: #f8f9fa;
            border-bottom: 1px solid var(--border-color);
        }

        .auction-image {
            max-width: 80%;
            max-height: 100%;
            object-fit: contain;
            border-radius: 4px;
        }

        .auction-content {
            padding: 1rem;
            flex-grow: 1;
            display: flex;
            flex-direction: column;
        }

        .auction-title {
            font-size: 1rem;
            font-weight: 600;
            margin: 0 0 0.5rem 0;
            color: var(--primary-dark);
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .auction-description {
            color: var(--secondary-color);
            margin-bottom: 0.5rem;
            font-size: 0.8rem;
            line-height: 1.4;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }

        .auction-meta {
            margin: 0.5rem 0;
        }

        .current-bid {
            font-weight: 700;
            font-size: 1rem;
            color: var(--primary-color);
            margin-bottom: 0.5rem;
        }

        .highest-bidder {
            font-size: 0.8rem;
            color: var(--secondary-color);
            font-style: italic;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .end-time {
            font-size: 0.8rem;
            color: var(--secondary-color);
            margin-top: 0.5rem;
            font-weight: 500;
        }

        .bid-form {
            display: flex;
            align-items: center;
            margin-top: auto;
            gap: 0.5rem;
        }

        .bid-input {
            flex: 1;
            padding: 0.5rem;
            border: 1px solid var(--border-color);
            border-radius: 6px;
            font-size: 0.8rem;
            background-color: #f5f7fa;
            transition: all 0.3s ease;
        }

        .bid-input:focus {
            border-color: var(--primary-color);
            outline: none;
            box-shadow: 0 0 0 3px rgba(25, 118, 210, 0.1);
            background-color: white;
        }

        .bid-button {
            background: linear-gradient(to right, var(--primary-color), var(--primary-dark));
            color: white;
            border: none;
            padding: 0.5rem;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 600;
            font-size: 0.8rem;
            white-space: nowrap;
            transition: all 0.3s ease;
            box-shadow: 0 4px 6px rgba(13, 71, 161, 0.15);
        }

        .bid-button:hover {
            transform: translateY(-2px);
            box-shadow: 0 7px 14px rgba(13, 71, 161, 0.2);
        }

        .notification {
            padding: 1rem;
            border-radius: 6px;
            margin-bottom: 1.5rem;
            font-weight: 500;
            animation: slideIn 0.3s ease-out;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .notification i {
            font-size: 1.25rem;
        }

        @keyframes slideIn {
            from {
                transform: translateY(-20px);
                opacity: 0;
            }
            to {
                transform: translateY(0);
                opacity: 1;
            }
        }

        .error {
            background-color: #ffebee;
            color: var(--error-color);
            border-left: 4px solid var(--error-color);
        }

        .success {
            background-color: #e8f5e9;
            color: var(--success-color);
            border-left: 4px solid var(--success-color);
        }

        @media (max-width: 1800px) {
            .auction-list {
                grid-template-columns: repeat(4, minmax(200px, 1fr));
            }
        }

        @media (max-width: 1400px) {
            .auction-list {
                grid-template-columns: repeat(3, minmax(200px, 1fr));
            }
        }

        @media (max-width: 1024px) {
            .auction-list {
                grid-template-columns: repeat(2, minmax(200px, 1fr));
            }
        }

        @media (max-width: 768px) {
            .header {
                flex-direction: column;
                align-items: flex-start;
                gap: 1rem;
            }

            .auction-list {
                grid-template-columns: 1fr;
            }

            .container {
                padding: 1.5rem;
            }
        }
    </style>
</head>
<body>
<div class="container">
    <div class="header">
        <h1>Available Auctions</h1>
        <div class="user-info">
            Welcome, <%= ((User)session.getAttribute("user")).getFullName() %>!
            <a href="logout" class="logout-link">
                <i class="fas fa-sign-out-alt"></i> Logout
            </a>
        </div>
    </div>

    <% if (request.getParameter("error") != null) { %>
    <div class="notification error">
        <i class="fas fa-exclamation-circle"></i>
        <span>Bid failed. Please try again with a higher amount.</span>
    </div>
    <% } %>

    <% if (request.getParameter("success") != null) { %>
    <div class="notification success">
        <i class="fas fa-check-circle"></i>
        <span>Bid placed successfully!</span>
    </div>
    <% } %>

    <div class="auction-list">
        <%
            NumberFormat currencyFormatter = (NumberFormat) request.getAttribute("currencyFormatter");
            for (Auction auction : (List<Auction>)request.getAttribute("auctions")) {
        %>
        <div class="auction-card">
            <div class="auction-status">Active</div>
            <div class="auction-image-container">
                <img src="<%= auction.getImageUrl() %>" alt="<%= auction.getTitle() %>" class="auction-image">
            </div>
            <div class="auction-content">
                <h3 class="auction-title"><%= auction.getTitle() %></h3>
                <p class="auction-description"><%= auction.getDescription() %></p>

                <div class="auction-meta">
                    <div class="current-bid">
                        Current bid: Rs <%= currencyFormatter.format(auction.getCurrentBid()) %>
                    </div>
                    <% if (auction.getHighestBidder() != null) { %>
                    <div class="highest-bidder">Highest bidder: <%= auction.getHighestBidder() %></div>
                    <% } %>
                    <div class="end-time">Ends at: <%= auction.getEndTime() %></div>
                </div>

                <form class="bid-form" action="bid" method="post">
                    <input type="hidden" name="auctionId" value="<%= auction.getId() %>">
                    <input type="number" class="bid-input" name="amount"
                           min="<%= auction.getCurrentBid() + 1 %>" step="0.01"
                           required placeholder="Enter amount (Rs)">
                    <button type="submit" class="bid-button" style="white-space: nowrap;">Place Bid</button>
                </form>
            </div>
        </div>
        <% } %>
    </div>
</div>

<script>
    function showNotification(message) {
        const notificationDiv = document.createElement('div');
        notificationDiv.className = 'notification success';
        notificationDiv.innerHTML = `
            <i class="fas fa-gavel"></i>
            <span>New Bid For Auction Item</span>
        `;
        notificationDiv.style.position = 'fixed';
        notificationDiv.style.bottom = '20px';
        notificationDiv.style.right = '20px';
        notificationDiv.style.zIndex = '1000';
        notificationDiv.style.maxWidth = '300px';
        notificationDiv.style.boxShadow = '0 10px 20px rgba(0,0,0,0.1)';

        document.body.appendChild(notificationDiv);

        setTimeout(() => {
            notificationDiv.style.opacity = '0';
            notificationDiv.style.transform = 'translateY(20px)';
            setTimeout(() => {
                notificationDiv.remove();
            }, 300);
        }, 5000);
    }

    function pollNotifications() {
        fetch('notifications')
            .then(response => response.json())
            .then(notifications => {
                notifications.forEach(notification => {
                    const message = `New Bid Placed`;
                    showNotification(message);
                });
            })
            .catch(error => console.error('Error fetching notifications:', error))
            .finally(() => {
                setTimeout(pollNotifications, 3000);
            });
    }

    document.addEventListener('DOMContentLoaded', pollNotifications);
</script>
</body>
</html>