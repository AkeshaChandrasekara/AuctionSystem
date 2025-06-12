package com.auction.web;

import com.auction.entity.Auction;
import com.auction.entity.User;
import com.auction.service.AuctionService;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.UUID;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;

@WebServlet("/admin/*")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 50
)
public class AdminServlet extends HttpServlet {
    @EJB
    private AuctionService auctionService;

    private static final String UPLOAD_DIRECTORY = "images";

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/auctions");
            return;
        }

        String action = request.getPathInfo();
        if (action == null) {
            action = "/dashboard";
        }

        try {
            switch (action) {
                case "/dashboard":
                    showDashboard(request, response);
                    break;
                case "/auctions":
                    showAuctions(request, response);
                    break;
                case "/add-auction":
                    showAddAuctionForm(request, response);
                    break;
                case "/edit-auction":
                    showEditAuctionForm(request, response);
                    break;
                case "/winners":
                    showWinners(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/auctions");
            return;
        }

        String action = request.getPathInfo();
        if (action == null) {
            action = "/dashboard";
        }

        try {
            switch (action) {
                case "/add-auction":
                    addAuction(request, response);
                    break;
                case "/edit-auction":
                    updateAuction(request, response);
                    break;
                case "/delete-auction":
                    deleteAuction(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    private void showDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Auction> allAuctions = auctionService.getAllAuctions();
        long activeAuctions = allAuctions.stream()
                .filter(a -> a.getEndTime().after(new Date()))
                .count();
        long completedAuctions = allAuctions.size() - activeAuctions;

        List<Auction> recentAuctions = allAuctions.stream()
                .sorted((a1, a2) -> a2.getStartTime().compareTo(a1.getStartTime()))
                .limit(5)
                .collect(Collectors.toList());

        request.setAttribute("totalAuctions", allAuctions.size());
        request.setAttribute("activeAuctions", activeAuctions);
        request.setAttribute("completedAuctions", completedAuctions);
        request.setAttribute("recentAuctions", recentAuctions); // Add this line
        request.getRequestDispatcher("/WEB-INF/admin/dashboard.jsp").forward(request, response);
    }

    private void showAuctions(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Auction> auctions = auctionService.getAllAuctions();
        request.setAttribute("auctions", auctions);
        request.getRequestDispatcher("/WEB-INF/admin/auctions.jsp").forward(request, response);
    }

    private void showAddAuctionForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/admin/add-auction.jsp").forward(request, response);
    }

    private void showEditAuctionForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Long id = Long.parseLong(request.getParameter("id"));
        Auction auction = auctionService.getAuctionById(id);
        if (auction == null) {
            response.sendRedirect(request.getContextPath() + "/admin/auctions");
            return;
        }
        request.setAttribute("auction", auction);
        request.getRequestDispatcher("/WEB-INF/admin/edit-auction.jsp").forward(request, response);
    }

    private void showWinners(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Auction> completedAuctions = auctionService.getAllAuctions().stream()
                .filter(a -> a.getEndTime().before(new Date()) && a.getHighestBidder() != null)
                .toList();
        request.setAttribute("winners", completedAuctions);
        request.getRequestDispatcher("/WEB-INF/admin/winners.jsp").forward(request, response);
    }

    private void addAuction(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            double startingBid = Double.parseDouble(request.getParameter("startingBid"));
            int hours = Integer.parseInt(request.getParameter("durationHours"));
            int minutes = Integer.parseInt(request.getParameter("durationMinutes"));

            String imagePath;
            try {
                imagePath = handleFileUpload(request);
            } catch (ServletException e) {
                request.setAttribute("error", e.getMessage());
                showAddAuctionForm(request, response);
                return;
            }

            Date now = new Date();
            long durationMillis = TimeUnit.HOURS.toMillis(hours) + TimeUnit.MINUTES.toMillis(minutes);
            Date endTime = new Date(now.getTime() + durationMillis);

            Auction auction = new Auction(
                    auctionService.getNextId(),
                    title,
                    description,
                    startingBid,
                    now,
                    endTime,
                    imagePath
            );

            auctionService.addAuction(auction);
            request.getSession().setAttribute("successMessage", "Auction added successfully!");
            response.sendRedirect(request.getContextPath() + "/admin/auctions?success=added");
        } catch (Exception e) {
            request.setAttribute("error", "Failed to create auction: " + e.getMessage());
            showAddAuctionForm(request, response);
        }
    }
    private void updateAuction(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Long id = Long.parseLong(request.getParameter("id"));
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        double startingBid = Double.parseDouble(request.getParameter("startingBid"));
        int hours = Integer.parseInt(request.getParameter("durationHours"));
        int minutes = Integer.parseInt(request.getParameter("durationMinutes"));

        Auction existingAuction = auctionService.getAuctionById(id);
        if (existingAuction == null) {
            response.sendRedirect(request.getContextPath() + "/admin/auctions");
            return;
        }

        Part filePart = request.getPart("image");
        String imagePath = existingAuction.getImageUrl();
        if (filePart != null && filePart.getSize() > 0) {
            imagePath = handleFileUpload(request);
        }

        Date now = new Date();
        long durationMillis = TimeUnit.HOURS.toMillis(hours) + TimeUnit.MINUTES.toMillis(minutes);
        Date endTime = new Date(now.getTime() + durationMillis);

        Auction updatedAuction = new Auction(
                id,
                title,
                description,
                startingBid,
                existingAuction.getStartTime(),
                endTime,
                imagePath,
                existingAuction.getCurrentBid(),
                existingAuction.getHighestBidder()
        );

        auctionService.updateAuction(updatedAuction);
        response.sendRedirect(request.getContextPath() + "/admin/auctions?success=updated");
    }

    private void deleteAuction(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Long id = Long.parseLong(request.getParameter("id"));
        auctionService.deleteAuction(id);
        response.sendRedirect(request.getContextPath() + "/admin/auctions?success=deleted");
    }

    private String handleFileUpload(HttpServletRequest request) throws IOException, ServletException {
        String uploadPath = getServletContext().getRealPath("");
        if (uploadPath == null) {
            uploadPath = System.getProperty("user.dir");
        }

        uploadPath = new File(uploadPath).getCanonicalPath();
        uploadPath = uploadPath + File.separator + UPLOAD_DIRECTORY;

        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        Part filePart = request.getPart("image");
        if (filePart == null || filePart.getSize() == 0) {
            return null;
        }

        long fileSize = filePart.getSize();
        if (fileSize > 10 * 1024 * 1024) { // 10MB
            throw new ServletException("File size exceeds 10MB limit");
        }

        String contentType = filePart.getContentType();
        if (!contentType.startsWith("image/")) {
            throw new ServletException("Only image files are allowed");
        }

        String fileName = UUID.randomUUID().toString() + "-" + getFileName(filePart);
        File file = new File(uploadDir, fileName);

        try {
            filePart.write(file.getAbsolutePath());
            return UPLOAD_DIRECTORY + "/" + fileName;
        } catch (IOException e) {
            throw new ServletException("Failed to save uploaded file", e);
        }
    }

    private String getFileName(Part part) {
        for (String content : part.getHeader("content-disposition").split(";")) {
            if (content.trim().startsWith("filename")) {
                return content.substring(content.indexOf('=') + 1).trim().replace("\"", "");
            }
        }
        return null;
    }
}