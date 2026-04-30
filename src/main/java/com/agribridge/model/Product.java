// File: Product.java
package com.projectmanagement.model;

import java.sql.Timestamp;

public class Product {
    private int id;
    private String name;
    private String category;
    private String description;
    private double price;
    private int stock;
    private String imagePath;
    private boolean publicInCatalog;
    private boolean featuredProduct;
    private Timestamp createdDate;
    
    // Constructors
    public Product() {}
    
    // Getters and Setters
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public String getCategory() {
        return category;
    }
    
    public void setCategory(String category) {
        this.category = category;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public double getPrice() {
        return price;
    }
    
    public void setPrice(double price) {
        this.price = price;
    }
    
    public int getStock() {
        return stock;
    }
    
    public void setStock(int stock) {
        this.stock = stock;
    }
    
    public String getImagePath() {
        return imagePath;
    }
    
    public void setImagePath(String imagePath) {
        this.imagePath = imagePath;
    }
    
    public boolean isPublicInCatalog() {
        return publicInCatalog;
    }
    
    public void setPublicInCatalog(boolean publicInCatalog) {
        this.publicInCatalog = publicInCatalog;
    }
    
    public boolean isFeaturedProduct() {
        return featuredProduct;
    }
    
    public void setFeaturedProduct(boolean featuredProduct) {
        this.featuredProduct = featuredProduct;
    }
    
    public Timestamp getCreatedDate() {
        return createdDate;
    }
    
    public void setCreatedDate(Timestamp createdDate) {
        this.createdDate = createdDate;
    }
    
    // Helper method to get image URL for display
    public String getImageUrl() {
        if (imagePath != null && !imagePath.isEmpty()) {
            return "ProductServlet?action=viewImage&path=" + imagePath;
        }
        return "images/placeholder.png";
    }
}