package model;


import java.io.Serializable;

public class User implements Serializable {

    private static final long serialVersionUID = 1L;

    private int id;
    private String username;
    private String password;
    private int balance;


    public User(int id, String username, String password) {
        this.id = id;
        this.username = username;
        this.password = password;
        this.balance = 1000;
    }


    public int getBalance() {
        return balance;
    }

    public void setBalance(int balance) {
        this.balance = balance;
    }

    public void addBalance(int balance) {
        this.balance += balance;
    }

    public void deductBalance(int balance) {
        this.balance -= balance;
    }

    public User() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
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
}
