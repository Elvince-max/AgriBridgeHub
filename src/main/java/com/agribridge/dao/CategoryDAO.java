// File: CategoryDAO.java
package com.projectmanagement.dao;

import java.sql.*;
import java.util.HashMap;
import java.util.Map;

import com.projectmanagement.util.DatabaseUtil;

public class CategoryDAO {
    
    public Map<String, Integer> getAllCategories() throws SQLException {
        Map<String, Integer> categories = new HashMap<>();
        // Fix: Use correct column names - if you don't have product_count, calculate it
        String sql = "SELECT category, COUNT(*) as product_count FROM products GROUP BY category ORDER BY category";

        try (Connection conn = DatabaseUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                categories.put(rs.getString("category"), rs.getInt("product_count"));
            }
        }
        return categories;
    }

    public int getTotalCategories() throws SQLException {
        String sql = "SELECT COUNT(DISTINCT category) FROM products";
        try (Connection conn = DatabaseUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }
}