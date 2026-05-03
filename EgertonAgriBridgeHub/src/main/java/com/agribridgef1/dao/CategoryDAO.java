package com.agribridgef1.dao;

import com.agribridgef1.util.DBConnection;

import java.sql.*;
import java.util.*;

public class CategoryDAO {

    public Map<Integer, String> getAllCategories() {
        Map<Integer, String> categories = new LinkedHashMap<>();

        String sql = "SELECT * FROM categories";

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                categories.put(
                    rs.getInt("category_id"),
                    rs.getString("category_name")
                );
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return categories;
    }
}