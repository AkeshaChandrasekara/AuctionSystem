<%@ page import="com.auction.entity.User" %>
<%@ page import="com.auction.entity.Auction" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !user.isAdmin()) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }

    List<Auction> winners = (List<Auction>) request.getAttribute("winners");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Auction Winners - Auction System</title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>
<body class="bg-gray-100">
<div class="flex h-screen">

    <div class="sidebar text-white w-64 space-y-6 py-7 px-2 fixed inset-y-0 left-0 transform -translate-x-full md:translate-x-0 transition duration-200 ease-in-out"
         style="background: linear-gradient(135deg, #0655a5, #052797);">
        <div class="text-white flex items-center space-x-2 px-4">
            <i class="fas fa-gavel fa-2x"></i>
            <span class="text-2xl font-extrabold">AuctionX</span>
        </div>
        <nav>
            <a href="<%= request.getContextPath() %>/admin/dashboard" class="block py-2.5 px-4 rounded transition duration-200 hover:bg-[#0d47a1] hover:text-white">
                <i class="fas fa-tachometer-alt mr-2"></i>Dashboard
            </a>
            <a href="<%= request.getContextPath() %>/admin/auctions" class="block py-2.5 px-4 rounded transition duration-200 hover:bg-[#0d47a1] hover:text-white">
                <i class="fas fa-gavel mr-2"></i>Auctions
            </a>
            <a href="<%= request.getContextPath() %>/admin/winners" class="block py-2.5 px-4 rounded transition duration-200 hover:bg-[#0d47a1] hover:text-white">
                <i class="fas fa-trophy mr-2"></i>Winners
            </a>
            <a href="<%= request.getContextPath() %>/logout" class="block py-2.5 px-4 rounded transition duration-200 hover:bg-[#0d47a1] hover:text-white">
                <i class="fas fa-sign-out-alt mr-2"></i>Logout
            </a>
        </nav>
    </div>

    <div class="flex-1 md:ml-64">
        <header class="bg-white shadow-sm py-4 px-6 flex justify-between items-center">
            <div class="flex items-center">
                <button class="md:hidden text-gray-500 focus:outline-none mr-4">
                    <i class="fas fa-bars"></i>
                </button>
                <h1 class="text-xl font-semibold text-gray-800">Dashboard</h1>
            </div>
            <div class="flex items-center space-x-4">
                <span class="text-gray-700">Welcome, <%= user.getFullName() %></span>
                <div class="h-8 w-8 rounded-full bg-indigo-500 flex items-center justify-center text-white">
                    <%= user.getFullName().charAt(0) %>
                </div>
            </div>
        </header>
        <main class="p-6">
            <div class="flex justify-between items-center mb-6">
                <h1 class="text-2xl font-bold text-gray-800">Auction Winners</h1>
            </div>

            <% if (winners.isEmpty()) { %>
            <div class="bg-white rounded-lg shadow p-6 text-center">
                <i class="fas fa-trophy text-4xl text-gray-300 mb-4"></i>
                <h3 class="text-lg font-medium text-gray-700">No completed auctions with winners yet</h3>
                <p class="text-gray-500 mt-2">Completed auctions with winning bids will appear here</p>
            </div>
            <% } else { %>
            <div class="bg-white rounded-lg shadow overflow-hidden">
                <table class="min-w-full divide-y divide-gray-200">
                    <thead class="bg-gray-50">
                    <tr>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Auction Item</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Winner</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Winning Bid</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">End Time</th>
                    </tr>
                    </thead>
                    <tbody class="bg-white divide-y divide-gray-200">
                    <% for (Auction auction : winners) { %>
                    <tr>
                        <td class="px-6 py-4">
                            <div class="flex items-center">
                                <div class="flex-shrink-0 h-10 w-10">
                                    <img class="h-10 w-10 rounded-full object-cover" src="<%= request.getContextPath() %>/<%= auction.getImageUrl() %>" alt="<%= auction.getTitle() %>">
                                </div>
                                <div class="ml-4">
                                    <div class="text-sm font-medium text-gray-900"><%= auction.getTitle() %></div>
                                    <div class="text-sm text-gray-500"><%= auction.getDescription().length() > 30 ? auction.getDescription().substring(0, 30) + "..." : auction.getDescription() %></div>
                                </div>
                            </div>
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap">
                            <div class="text-sm text-gray-900"><%= auction.getHighestBidder() %></div>
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap">
                            <div class="text-sm text-gray-900">LKR <%= String.format("%,.2f", auction.getCurrentBid()) %></div>
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap">
                            <div class="text-sm text-gray-500"><%= new SimpleDateFormat("MMM dd, yyyy HH:mm").format(auction.getEndTime()) %></div>
                        </td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
            <% } %>
        </main>
    </div>
</div>
</body>
</html>