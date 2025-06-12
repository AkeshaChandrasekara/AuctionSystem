package com.auction.web;

import com.auction.entity.Auction;
import com.auction.entity.BidMessage;
import com.auction.entity.User;
import com.auction.service.AuctionService;
import com.auction.service.NotificationService;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/notifications")
public class NotificationServlet extends HttpServlet {
    @EJB
    private NotificationService notificationService;
    @EJB
    private AuctionService auctionService;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        User user = (User) session.getAttribute("user");
        List<BidMessage> notifications = notificationService.getNotifications(user.getUsername());

        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        out.print("[");
        for (int i = 0; i < notifications.size(); i++) {
            BidMessage msg = notifications.get(i);
            Auction auction = auctionService.getAuctionById(msg.getAuctionId());
            String auctionTitle = auction != null ? auction.getTitle() : "Auction " + msg.getAuctionId();

            out.print("{");
            out.print("\"auctionId\":\"" + msg.getAuctionId() + "\",");
            out.print("\"auctionTitle\":\"" + auctionTitle + "\",");
            out.print("\"bidder\":\"" + msg.getBidder() + "\",");
            out.print("\"amount\":\"" + msg.getAmount() + "\"");
            out.print("}");
            if (i < notifications.size() - 1) {
                out.print(",");
            }
        }
        out.print("]");
        notificationService.clearNotifications(user.getUsername());
    }
}