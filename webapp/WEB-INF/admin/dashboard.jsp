<%@ page import="com.auction.entity.Auction" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.stream.Collectors" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="com.auction.entity.User" %>
<%@ page import="com.auction.service.AuctionService" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !user.isAdmin()) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Auction System</title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        .sidebar {
            transition: all 0.3s;
        }
        .card {
            transition: transform 0.3s, box-shadow 0.3s;
        }
        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
        }
    </style>
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
            <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-6">

                <div class="card bg-white rounded-lg shadow p-6">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-gray-500">Total Auctions</p>
                            <h3 class="text-2xl font-bold"><%= request.getAttribute("totalAuctions") %></h3>
                        </div>
                        <div class="p-3 rounded-full bg-indigo-100 text-indigo-600">
                            <i class="fas fa-gavel fa-lg"></i>
                        </div>
                    </div>
                </div>

                <div class="card bg-white rounded-lg shadow p-6">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-gray-500">Active Auctions</p>
                            <h3 class="text-2xl font-bold"><%= request.getAttribute("activeAuctions") %></h3>
                        </div>
                        <div class="p-3 rounded-full bg-green-100 text-green-600">
                            <i class="fas fa-bolt fa-lg"></i>
                        </div>
                    </div>
                </div>


                <div class="card bg-white rounded-lg shadow p-6">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-gray-500">Completed Auctions</p>
                            <h3 class="text-2xl font-bold"><%= request.getAttribute("completedAuctions") %></h3>
                        </div>
                        <div class="p-3 rounded-full bg-blue-100 text-blue-600">
                            <i class="fas fa-check-circle fa-lg"></i>
                        </div>
                    </div>
                </div>
            </div>


            <div class="bg-white rounded-lg shadow p-6 mb-6">
                <div class="flex justify-between items-center mb-4">
                    <h2 class="text-lg font-semibold">Recent Auctions</h2>
                    <a href="<%= request.getContextPath() %>/admin/auctions" class="text-indigo-600 hover:text-indigo-800">View All</a>
                </div>
                <div class="overflow-x-auto">
                    <table class="min-w-full divide-y divide-gray-200">
                        <thead class="bg-gray-50">
                        <tr>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Title</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Start Time</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">End Time</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Status</th>
                        </tr>
                        </thead>
                        <tbody class="bg-white divide-y divide-gray-200">
                        <%
                            List<Auction> recentAuctions = (List<Auction>) request.getAttribute("recentAuctions");
                            for (Auction auction : recentAuctions) {
                        %>
                        <tr>
                            <td class="px-6 py-4 whitespace-nowrap"><%= auction.getTitle() %></td>
                            <td class="px-6 py-4 whitespace-nowrap"><%= new SimpleDateFormat("MMM dd, yyyy HH:mm").format(auction.getStartTime()) %></td>
                            <td class="px-6 py-4 whitespace-nowrap"><%= new SimpleDateFormat("MMM dd, yyyy HH:mm").format(auction.getEndTime()) %></td>
                            <td class="px-6 py-4 whitespace-nowrap">
                                        <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full
                                            <%= auction.getEndTime().after(new Date()) ? "bg-green-100 text-green-800" : "bg-gray-100 text-gray-800" %>">
                                            <%= auction.getEndTime().after(new Date()) ? "Active" : "Completed" %>
                                        </span>
                            </td>
                        </tr>
                        <% } %>
                        </tbody>
                    </table>
                </div>
            </div>


            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div class="bg-white rounded-lg shadow p-6">
                    <h2 class="text-lg font-semibold mb-4">Quick Actions</h2>
                    <div class="space-y-4">
                        <a href="<%= request.getContextPath() %>/admin/add-auction" class="block w-full bg-indigo-600 hover:bg-indigo-700 text-white py-2 px-4 rounded text-center transition duration-200">
                            <i class="fas fa-plus mr-2"></i>Add New Auction
                        </a>
                        <a href="<%= request.getContextPath() %>/admin/winners" class="block w-full bg-green-600 hover:bg-green-700 text-white py-2 px-4 rounded text-center transition duration-200">
                            <i class="fas fa-trophy mr-2"></i>View Winners
                        </a>
                    </div>
                </div>

                <div class="bg-white rounded-lg shadow p-6">
                    <h2 class="text-lg font-semibold mb-4">System Overview</h2>
                    <div class="space-y-3">
                        <div class="flex justify-between">
                            <span class="text-gray-600">Total Users</span>
                            <span class="font-medium">4</span>
                        </div>
                        <div class="flex justify-between">
                            <span class="text-gray-600">Active Bids Today</span>
                            <span class="font-medium">12</span>
                        </div>
                        <div class="flex justify-between">
                            <span class="text-gray-600">Revenue This Month</span>
                            <span class="font-medium">LKR 125,000.00</span>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<script>
   
    document.querySelector('.md\\:hidden').addEventListener('click', function() {
        document.querySelector('.sidebar').classList.toggle('-translate-x-full');
    });
</script>
</body>
</html>