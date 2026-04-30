package com.agribridge.model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;
import java.util.Collections;

public class Cart implements Serializable {
    private List<CartItem> items;

    public Cart() {
        items = new ArrayList<>();
    }

    public List<CartItem> getItems() {
        return items;
    }

    public double getTotal() {
        double sum = 0.0;
        for (CartItem item : items) {
            sum += item.getPrice() * item.getQuantity();
        }
        return sum;
    }

    public void addItem(CartItem newItem) {
        for (CartItem existing : items) {
            if (existing.getProductId() == newItem.getProductId()) {
                existing.setQuantity(existing.getQuantity() + newItem.getQuantity());
                return;
            }
        }
        items.add(newItem);
    }

    public void updateQuantity(int productId, int quantity) {
        for (CartItem item : items) {
            if (item.getProductId() == productId) {
                if (quantity <= 0) {
                    items.remove(item);
                } else {
                    item.setQuantity(quantity);
                }
                return;
            }
        }
    }

    public void removeItem(int productId) {
        items.removeIf(item -> item.getProductId() == productId);
    }

    public void clear() {
        items.clear();
    }

    public boolean isEmpty() {
        return items.isEmpty();
    }

    public boolean isEmpty() {
        return items.isEmpty();
    }
}