package com.agribridge.model;

import java.util.ArrayList;
import java.util.List;

public class Cart {
    private List<CartItem> items = new ArrayList<>();
    private double total = 0.0;

    public List<CartItem> getItems() {
        return items;
    }

    public void setItems(List<CartItem> items) {
        this.items = items;
        recalculateTotal();
    }

    public void addItem(CartItem item) {
        items.add(item);
        recalculateTotal();
    }

    public void removeItem(int productId) {
        items.removeIf(i -> i.getProductId() == productId);
        recalculateTotal();
    }

    public double getTotal() {
        return total;
    }

    private void recalculateTotal() {
        total = items.stream().mapToDouble(i -> i.getPrice() * i.getQuantity()).sum();
    }
}