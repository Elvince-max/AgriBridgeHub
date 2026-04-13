package com.agribridge.model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;
import java.util.Collections;

public class Cart implements Serializable {
    private List<CartItem> items;
    private double total;

    public Cart() {
        items = new ArrayList<>();
        total = 0.0;
    }

    public List<CartItem> getItems() {
        return Collections.unmodifiableList(items);
    }

    public double getTotal() {
        recalculateTotal();
        return total;
    }

    public void addItem(CartItem newItem) {
        for (CartItem item : items) {
            if (item.getProductId() == newItem.getProductId()) {
                item.setQuantity(item.getQuantity() + newItem.getQuantity());
                recalculateTotal();
                return;
            }
        }
        items.add(newItem);
        recalculateTotal();
    }

    public void updateQuantity(int productId, int quantity) {
        for (CartItem item : items) {
            if (item.getProductId() == productId) {
                if (quantity <= 0) {
                    items.remove(item);
                } else {
                    item.setQuantity(quantity);
                }
                recalculateTotal();
                return;
            }
        }
    }

    public void removeItem(int productId) {
        items.removeIf(item -> item.getProductId() == productId);
        recalculateTotal();
    }

    public void clear() {
        items.clear();
        total = 0.0;
    }

    private void recalculateTotal() {
        total = items.stream().mapToDouble(i -> i.getPrice() * i.getQuantity()).sum();
    }

    public boolean isEmpty() {
        return items.isEmpty();
    }
}