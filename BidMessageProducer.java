package com.auction.service;

import com.auction.entity.BidMessage;
import jakarta.annotation.Resource;
import jakarta.ejb.Stateless;
import jakarta.jms.ConnectionFactory;
import jakarta.jms.JMSContext;
import jakarta.jms.Topic;

@Stateless
public class BidMessageProducer {
    @Resource(lookup = "jms/AuctionConnectionFactory")
    private ConnectionFactory connectionFactory;

    @Resource(lookup = "jms/AuctionTopic")
    private Topic topic;

    public void sendBidMessage(Long auctionId, String bidder, double amount) {
        try (JMSContext context = connectionFactory.createContext()) {
            BidMessage bidMessage = new BidMessage(auctionId, bidder, amount);
            context.createProducer().send(topic, bidMessage);
        }
    }
}


