package com.agribridge.model;

import java.sql.Timestamp;

public class Order {
    private int orderId;
    private int userId;
    private String orderNumber;
    private Timestamp orderDate;
    private double totalAmount;
    private double deliveryFee;
    private String status;
    private String paymentStatus;
    private String deliveryAddress;

    // Constructors
    public Order() {}

    public Order(int userId, String orderNumber, double totalAmount, double deliveryFee, 
                 String status, String paymentStatus, String deliveryAddress) {
        this.userId = userId;
        this.orderNumber = orderNumber;
        this.totalAmount = totalAmount;
        this.deliveryFee = deliveryFee;
        this.status = status;
        this.paymentStatus = paymentStatus;
        this.deliveryAddress = deliveryAddress;
    }

    // Getters and Setters
    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public String getOrderNumber() { return orderNumber; }
    public void setOrderNumber(String orderNumber) { this.orderNumber = orderNumber; }
    public Timestamp getOrderDate() { return orderDate; }
    public void setOrderDate(Timestamp orderDate) { this.orderDate = orderDate; }
    public double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }
    public double getDeliveryFee() { return deliveryFee; }
    public void setDeliveryFee(double deliveryFee) { this.deliveryFee = deliveryFee; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getPaymentStatus() { return paymentStatus; }
    public void setPaymentStatus(String paymentStatus) { this.paymentStatus = paymentStatus; }
    public String getDeliveryAddress() { return deliveryAddress; }
    public void setDeliveryAddress(String deliveryAddress) { this.deliveryAddress = deliveryAddress; }
}