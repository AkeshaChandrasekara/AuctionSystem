package com.auction.service;

import com.auction.entity.BidMessage;
import jakarta.ejb.ActivationConfigProperty;
import jakarta.ejb.EJB;
import jakarta.ejb.MessageDriven;
import jakarta.jms.JMSException;
import jakarta.jms.Message;
import jakarta.jms.MessageListener;
import jakarta.jms.ObjectMessage;

@MessageDriven(
        activationConfig = {
                @ActivationConfigProperty(propertyName = "destinationLookup", propertyValue = "jms/AuctionTopic"),
                @ActivationConfigProperty(propertyName = "destinationType", propertyValue = "jakarta.jms.Topic"),
        }
)
public class BidMessageConsumer implements MessageListener {
    @EJB
    private NotificationService notificationService;

    @Override
    public void onMessage(Message message) {
        try {
            if (message instanceof ObjectMessage) {
                ObjectMessage objectMessage = (ObjectMessage) message;
                BidMessage bidMessage = (BidMessage) objectMessage.getObject();

                notificationService.addNotification(bidMessage.getBidder(), bidMessage);

                System.out.println("Received bid message: " + bidMessage.getBidder() +
                        " bid " + bidMessage.getAmount() +
                        " on auction " + bidMessage.getAuctionId());
            }
        } catch (JMSException e) {
            e.printStackTrace();
        }
    }
}

