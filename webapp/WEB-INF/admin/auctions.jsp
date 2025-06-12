<%@ page import="com.auction.entity.Auction" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="com.auction.entity.User" %>
<%@ page import="java.util.List" %>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !user.isAdmin()) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }

    List<Auction> auctions = (List<Auction>) request.getAttribute("auctions");
    String success = request.getParameter("success");
    String successMessage = (String) session.getAttribute("successMessage");
    session.removeAttribute("successMessage"); // Remove after displaying
%>
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Auctions - Auction System</title>
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
            <% if (successMessage != null) { %>
            <div id="successAlert" class="mb-4 p-4 bg-green-100 text-green-700 rounded flex justify-between items-center">
                <span><%= successMessage %></span>
                <button onclick="document.getElementById('successAlert').style.display='none'"
                        class="text-green-700 hover:text-green-900">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            <% } %>
            <div class="flex justify-between items-center mb-6">
                <h1 class="text-2xl font-bold text-gray-800">Manage Auctions</h1>
                <a href="<%= request.getContextPath() %>/admin/add-auction" class="bg-indigo-600 hover:bg-indigo-700 text-white py-2 px-4 rounded flex items-center">
                    <i class="fas fa-plus mr-2"></i> Add Auction
                </a>
            </div>

            <% if (success != null) { %>
            <div class="mb-4 p-4 bg-green-100 text-green-700 rounded">
                <% if ("added".equals(success)) { %>
                Auction added successfully!
                <% } else if ("updated".equals(success)) { %>
                Auction updated successfully!
                <% } else if ("deleted".equals(success)) { %>
                Auction deleted successfully!
                <% } %>
            </div>
            <% } %>

            <div class="bg-white rounded-lg shadow overflow-hidden">
                <table class="min-w-full divide-y divide-gray-200">
                    <thead class="bg-gray-50">
                    <tr>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Image</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Title</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Current Bid</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">End Time</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Status</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Actions</th>
                    </tr>
                    </thead>
                    <tbody class="bg-white divide-y divide-gray-200">
                    <% for (Auction auction : auctions) { %>
                    <tr>
                        <td class="px-6 py-4 whitespace-nowrap">
                            <img src="<%= request.getContextPath() %>/<%= auction.getImageUrl() %>" alt="<%= auction.getTitle() %>" class="h-12 w-12 object-cover rounded">
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap">
                            <div class="font-medium text-gray-900"><%= auction.getTitle() %></div>
                            <div class="text-sm text-gray-500"><%= auction.getDescription().length() > 50 ? auction.getDescription().substring(0, 50) + "..." : auction.getDescription() %></div>
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap">
                            <div class="text-gray-900">LKR <%= String.format("%,.2f", auction.getCurrentBid()) %></div>
                            <% if (auction.getHighestBidder() != null) { %>
                            <div class="text-sm text-gray-500">by <%= auction.getHighestBidder() %></div>
                            <% } %>
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap">
                            <%= new SimpleDateFormat("MMM dd, yyyy HH:mm").format(auction.getEndTime()) %>
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap">
                                    <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full
                                        <%= auction.getEndTime().after(new Date()) ? "bg-green-100 text-green-800" : "bg-gray-100 text-gray-800" %>">
                                        <%= auction.getEndTime().after(new Date()) ? "Active" : "Completed" %>
                                    </span>
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                            <a href="<%= request.getContextPath() %>/admin/edit-auction?id=<%= auction.getId() %>" class="text-indigo-600 hover:text-indigo-900 mr-3">
                                <i class="fas fa-edit"></i> Edit
                            </a>
                            <a href="<%= request.getContextPath() %>/admin/delete-auction?id=<%= auction.getId() %>" class="text-red-600 hover:text-red-900" onclick="return confirm('Are you sure you want to delete this auction?');">
                                <i class="fas fa-trash"></i> Delete
                            </a>
                        </td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
        </main>
    </div>
</div>
<script>
    setTimeout(function() {
        var alert = document.getElementById('successAlert');
        if (alert) {
            alert.style.display = 'none';
        }
    }, 5000);
</script>
</body>
</html>