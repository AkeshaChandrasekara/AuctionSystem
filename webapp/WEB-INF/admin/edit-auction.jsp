<%@ page import="com.auction.entity.User" %>
<%@ page import="com.auction.entity.Auction" %>
<%@ page import="java.util.concurrent.TimeUnit" %><%--
  Created by IntelliJ IDEA.
  User: akesh
  Date: 6/8/2025
  Time: 9:57 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !user.isAdmin()) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }

    Auction auction = (Auction) request.getAttribute("auction");
    if (auction == null) {
        response.sendRedirect(request.getContextPath() + "/admin/auctions");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Auction - Auction System</title>
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
                <h1 class="text-2xl font-bold text-gray-800">Edit Auction</h1>
                <a href="<%= request.getContextPath() %>/admin/auctions" class="text-gray-600 hover:text-gray-800">
                    <i class="fas fa-arrow-left mr-1"></i> Back to Auctions
                </a>
            </div>

            <div class="bg-white rounded-lg shadow p-6">
                <form action="<%= request.getContextPath() %>/admin/edit-auction" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="id" value="<%= auction.getId() %>">

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <div>
                            <label for="title" class="block text-sm font-medium text-gray-700 mb-1">Title</label>
                            <input type="text" id="title" name="title" value="<%= auction.getTitle() %>" required class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500">
                        </div>

                        <div>
                            <label for="startingBid" class="block text-sm font-medium text-gray-700 mb-1">Starting Bid (LKR)</label>
                            <input type="number" id="startingBid" name="startingBid" value="<%= auction.getStartingPrice() %>" min="0" step="0.01" required class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500">
                        </div>

                        <div class="md:col-span-2">
                            <label for="description" class="block text-sm font-medium text-gray-700 mb-1">Description</label>
                            <textarea id="description" name="description" rows="3" required class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500"><%= auction.getDescription() %></textarea>
                        </div>

                        <%
                            long duration = auction.getEndTime().getTime() - auction.getStartTime().getTime();
                            long hours = TimeUnit.MILLISECONDS.toHours(duration);
                            long minutes = TimeUnit.MILLISECONDS.toMinutes(duration) - TimeUnit.HOURS.toMinutes(hours);
                        %>

                        <div>
                            <label for="durationHours" class="block text-sm font-medium text-gray-700 mb-1">Duration (Hours)</label>
                            <input type="number" id="durationHours" name="durationHours" value="<%= hours %>" min="1" max="720" required class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500">
                        </div>

                        <div>
                            <label for="durationMinutes" class="block text-sm font-medium text-gray-700 mb-1">Duration (Minutes)</label>
                            <input type="number" id="durationMinutes" name="durationMinutes" value="<%= minutes %>" min="0" max="59" required class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500">
                        </div>

                        <div class="md:col-span-2">
                            <label class="block text-sm font-medium text-gray-700 mb-1">Current Image</label>
                            <img src="<%= request.getContextPath() %>/<%= auction.getImageUrl() %>" alt="Current Image" class="h-32 w-32 object-cover rounded-md">

                            <label for="image" class="block text-sm font-medium text-gray-700 mt-4 mb-1">Change Image (Optional)</label>
                            <input type="file" id="image" name="image" accept="image/*" class="py-2 px-3 border border-gray-300 rounded-md shadow-sm text-sm leading-4 font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
                        </div>
                    </div>

                    <div class="mt-6 flex justify-end space-x-3">
                        <button type="submit" class="bg-indigo-600 hover:bg-indigo-700 text-white py-2 px-4 rounded-md shadow-sm">
                            <i class="fas fa-save mr-2"></i> Save Changes
                        </button>
                        <a href="<%= request.getContextPath() %>/admin/auctions" class="bg-gray-200 hover:bg-gray-300 text-gray-800 py-2 px-4 rounded-md shadow-sm">
                            Cancel
                        </a>
                    </div>
                </form>
            </div>
        </main>
    </div>
</div>
</body>
</html>