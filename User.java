package com.auction.entity;

import java.io.Serializable;

public class User implements Serializable {
    private String username;
    private String password;
    private String fullName;
    private boolean admin;

    public User() {
    }



    public User(String username, String password, String fullName) {
        this(username, password, fullName, false);
    }

    public User(String username, String password, String fullName, boolean admin) {
        this.username = username;
        this.password = password;
        this.fullName = fullName;
        this.admin = admin;
    }
    public boolean isAdmin() {
        return admin;
    }

    public void setAdmin(boolean admin) {
        this.admin = admin;
    }
    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }
}