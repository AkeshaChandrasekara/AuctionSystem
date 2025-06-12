package com.auction.web;

import com.auction.entity.Auction;
import com.auction.entity.User;
import com.auction.service.AuctionService;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.text.NumberFormat;
import java.util.List;
import java.util.Locale;

@WebServlet("/auctions")
public class AuctionServlet extends HttpServlet {
    @EJB
    private AuctionService auctionService;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }

        NumberFormat lkrFormat = NumberFormat.getNumberInstance();
        lkrFormat.setMinimumFractionDigits(2);
        lkrFormat.setMaximumFractionDigits(2);

        List<Auction> auctions = auctionService.getAllAuctions();
        request.setAttribute("auctions", auctions);
        request.setAttribute("currencyFormatter", lkrFormat);
        request.getRequestDispatcher("/auctions.jsp").forward(request, response);
    }
}
