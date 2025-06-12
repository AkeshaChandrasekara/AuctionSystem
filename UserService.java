package com.auction.service;

import com.auction.entity.User;
import jakarta.ejb.Stateless;
import java.util.HashMap;
import java.util.Map;

@Stateless
public class UserService {
    private final Map<String, User> users = new HashMap<>();

    public UserService() {
        users.put("akesha", new User("akesha", "akesha@123", "Akesha Chandrasekara"));
        users.put("senulya", new User("senulya", "senu@32", "Senulya Weerasoriya"));
        users.put("chamod", new User("chamod", "chamo89@", "Chamod Pathmasiri"));
        users.put("risindu", new User("risindu", "risi@90", "Risindu Thilakarathna"));
        users.put("admin", new User("admin", "adminlog", "Administrator", true));
    }

    public User authenticate(String username, String password) {
        User user = users.get(username);
        if (user != null && user.getPassword().equals(password)) {
            return user;
        }
        return null;
    }
}