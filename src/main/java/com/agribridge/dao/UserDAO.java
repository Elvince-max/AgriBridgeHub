package com.agribridge.dao;

import com.agribridge.model.User;
import com.agribridge.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    // -------------------- Existing methods --------------------
    public boolean isEmailExists(String email) throws SQLException {
        String sql = "SELECT user_id FROM users WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        }
    }

    public boolean registerUser(User user) throws SQLException {
        String sql = "INSERT INTO users (name, email, phone, password_hash) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, user.getName());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, user.getPhone());
            stmt.setString(4, user.getPasswordHash());
            int rows = stmt.executeUpdate();
            return rows > 0;
        }
    }

    public User getUserByEmail(String email) throws SQLException {
        String sql = "SELECT user_id, name, email, phone, password_hash, reset_token, token_expiry FROM users WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    User user = new User();
                    user.setUserId(rs.getInt("user_id"));
                    user.setName(rs.getString("name"));
                    user.setEmail(rs.getString("email"));
                    user.setPhone(rs.getString("phone"));
                    user.setPasswordHash(rs.getString("password_hash"));
                    user.setResetToken(rs.getString("reset_token"));
                    user.setTokenExpiry(rs.getTimestamp("token_expiry"));
                    return user;
                }
            }
        }
        return null;
    }

    // -------------------- New password reset methods --------------------
    /**
     * Save a reset token for a user, with an expiry in hours.
     * @param email user's email
     * @param token random UUID token
     * @param expiryHours number of hours the token is valid
     * @return true if update succeeded
     */
    public boolean saveResetToken(String email, String token, int expiryHours) throws SQLException {
        String sql = "UPDATE users SET reset_token = ?, token_expiry = DATE_ADD(NOW(), INTERVAL ? HOUR) WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, token);
            stmt.setInt(2, expiryHours);
            stmt.setString(3, email);
            return stmt.executeUpdate() > 0;
        }
    }

    /**
     * Retrieve a user by a valid reset token (not expired).
     * @param token the reset token
     * @return User object if token exists and not expired, else null
     */
    public User getUserByResetToken(String token) throws SQLException {
        String sql = "SELECT user_id, name, email, phone, password_hash, reset_token, token_expiry FROM users WHERE reset_token = ? AND token_expiry > NOW()";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, token);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    User user = new User();
                    user.setUserId(rs.getInt("user_id"));
                    user.setName(rs.getString("name"));
                    user.setEmail(rs.getString("email"));
                    user.setPhone(rs.getString("phone"));
                    user.setPasswordHash(rs.getString("password_hash"));
                    user.setResetToken(rs.getString("reset_token"));
                    user.setTokenExpiry(rs.getTimestamp("token_expiry"));
                    return user;
                }
            }
        }
        return null;
    }

    /**
     * Update a user's password and clear the reset token fields.
     * @param userId the user ID
     * @param newHashedPassword new password (already hashed with BCrypt)
     * @return true if update succeeded
     */
    public boolean updatePassword(int userId, String newHashedPassword) throws SQLException {
        String sql = "UPDATE users SET password_hash = ?, reset_token = NULL, token_expiry = NULL WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, newHashedPassword);
            stmt.setInt(2, userId);
            return stmt.executeUpdate() > 0;
        }
    }
}