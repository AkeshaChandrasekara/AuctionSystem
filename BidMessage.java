package com.auction.entity;

import java.io.Serializable;

public class BidMessage implements Serializable {
    private Long auctionId;
    private String bidder;
    private double amount;

    public BidMessage() {
    }

    public BidMessage(Long auctionId, String bidder, double amount) {
        this.auctionId = auctionId;
        this.bidder = bidder;
        this.amount = amount;
    }

    public Long getAuctionId() {
        return auctionId;
    }

    public void setAuctionId(Long auctionId) {
        this.auctionId = auctionId;
    }

    public String getBidder() {
        return bidder;
    }

    public void setBidder(String bidder) {
        this.bidder = bidder;
    }

    public double getAmount() {
        return amount;
    }

    public void setAmount(double amount) {
        this.amount = amount;
    }
}