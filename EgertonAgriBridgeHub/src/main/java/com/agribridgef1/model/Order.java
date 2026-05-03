package com.agribridgef1.model;

public class Order {
    private int orderId;
    private int userId;
    private String deliveryAddress;
    private String deliveryTime;
    private String orderStatus;
    private double totalAmount;

    public Order() {}

    public Order(int userId, String deliveryAddress, String deliveryTime, String orderStatus, double totalAmount) {
        this.userId = userId;
        this.deliveryAddress = deliveryAddress;
        this.deliveryTime = deliveryTime;
        this.orderStatus = orderStatus;
        this.totalAmount = totalAmount;
    }

    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getDeliveryAddress() { return deliveryAddress; }
    public void setDeliveryAddress(String deliveryAddress) { this.deliveryAddress = deliveryAddress; }

    public String getDeliveryTime() { return deliveryTime; }
    public void setDeliveryTime(String deliveryTime) { this.deliveryTime = deliveryTime; }

    public String getOrderStatus() { return orderStatus; }
    public void setOrderStatus(String orderStatus) { this.orderStatus = orderStatus; }

    public double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }
}