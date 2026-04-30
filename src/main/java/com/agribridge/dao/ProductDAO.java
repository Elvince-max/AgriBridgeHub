package com.agribridge.dao;

import com.agribridge.model.Product;
import com.agribridge.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO {

    // Fetch all products with category name and first image URL
    public List<Product> getAllProducts() throws SQLException {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT p.*, c.category_name, " +
                     "(SELECT pi.image_url FROM product_images pi WHERE pi.product_id = p.product_id LIMIT 1) AS image_url " +
                     "FROM products p " +
                     "LEFT JOIN categories c ON p.category_id = c.category_id " +
                     "ORDER BY p.product_id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Product p = new Product();
                p.setProductId(rs.getInt("product_id"));
                p.setName(rs.getString("name"));
                p.setDescription(rs.getString("description"));
                p.setPrice(rs.getDouble("price"));
                p.setStockQuantity(rs.getInt("stock_quantity"));
                p.setCategoryId(rs.getInt("category_id"));
                p.setCategoryName(rs.getString("category_name"));
                p.setImageUrl(rs.getString("image_url")); // from subquery
                p.setWeight(rs.getString("weight"));
                p.setCreatedAt(rs.getString("created_at"));
                products.add(p);
            }
        }
        return products;
    }

    // Fetch a single product by ID with category name and first image
    public Product getProductById(int productId) throws SQLException {
        String sql = "SELECT p.*, c.category_name, " +
                     "(SELECT pi.image_url FROM product_images pi WHERE pi.product_id = p.product_id LIMIT 1) AS image_url " +
                     "FROM products p " +
                     "LEFT JOIN categories c ON p.category_id = c.category_id " +
                     "WHERE p.product_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, productId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Product p = new Product();
                    p.setProductId(rs.getInt("product_id"));
                    p.setName(rs.getString("name"));
                    p.setDescription(rs.getString("description"));
                    p.setPrice(rs.getDouble("price"));
                    p.setStockQuantity(rs.getInt("stock_quantity"));
                    p.setCategoryId(rs.getInt("category_id"));
                    p.setCategoryName(rs.getString("category_name"));
                    p.setImageUrl(rs.getString("image_url"));
                    p.setWeight(rs.getString("weight"));
                    p.setCreatedAt(rs.getString("created_at"));
                    return p;
                }
            }
        }
        return null;
    }
    
    // In ProductDAO.java
public List<Product> searchProducts(String searchTerm) throws SQLException {
    List<Product> products = new ArrayList<>();
    String sql = "SELECT p.*, c.category_name, " +
                 "(SELECT pi.image_url FROM product_images pi WHERE pi.product_id = p.product_id LIMIT 1) AS image_url " +
                 "FROM products p " +
                 "LEFT JOIN categories c ON p.category_id = c.category_id " +
                 "WHERE p.name LIKE ? OR p.description LIKE ? " +
                 "ORDER BY p.product_id DESC";
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        String likePattern = "%" + searchTerm + "%";
        stmt.setString(1, likePattern);
        stmt.setString(2, likePattern);
        try (ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Product p = new Product();
                p.setProductId(rs.getInt("product_id"));
                p.setName(rs.getString("name"));
                p.setDescription(rs.getString("description"));
                p.setPrice(rs.getDouble("price"));
                p.setStockQuantity(rs.getInt("stock_quantity"));
                p.setCategoryId(rs.getInt("category_id"));
                p.setCategoryName(rs.getString("category_name"));
                p.setImageUrl(rs.getString("image_url"));
                p.setWeight(rs.getString("weight"));
                products.add(p);
            }
        }
    }
    return products;
}
}