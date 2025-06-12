package com.auction.service;

import com.auction.entity.BidMessage;
import jakarta.ejb.Singleton;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;

@Singleton
public class NotificationService {
    private final ConcurrentMap<String, List<BidMessage>> userNotifications = new ConcurrentHashMap<>();

    public void addNotification(String username, BidMessage bidMessage) {
        userNotifications.computeIfAbsent(username, k -> new ArrayList<>()).add(bidMessage);
    }

    public List<BidMessage> getNotifications(String username) {
        return userNotifications.getOrDefault(username, new ArrayList<>());
    }

    public void clearNotifications(String username) {
        userNotifications.remove(username);
    }
}


