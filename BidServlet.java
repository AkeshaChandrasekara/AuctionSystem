package com.auction.web;

import com.auction.entity.User;
import com.auction.service.AuctionService;
import com.auction.service.BidMessageProducer;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/bid")
public class BidServlet extends HttpServlet {
    @EJB
    private AuctionService auctionService;
    @EJB
    private BidMessageProducer bidMessageProducer;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }

        User user = (User) session.getAttribute("user");
        Long auctionId = Long.parseLong(request.getParameter("auctionId"));
        double amount = Double.parseDouble(request.getParameter("amount"));

        boolean success = auctionService.placeBid(auctionId, user.getUsername(), amount);
        if (success) {
            bidMessageProducer.sendBidMessage(auctionId, user.getUsername(), amount);
            response.sendRedirect("auctions?success=true");
        } else {
            response.sendRedirect("auctions?error=bid_failed");
        }
    }
}
