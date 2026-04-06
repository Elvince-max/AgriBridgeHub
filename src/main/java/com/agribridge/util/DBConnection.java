package com.agribridge.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Utility class to manage MySQL Database Connection using Singleton Pattern.
 * @author Elvince
 */
public class DBConnection {

    // Database Configuration - Tell your team to edit these to match their local XAMPP/MySQL
    private static final String URL = "jdbc:mysql://localhost:3306/agribridge_db?useSSL=false&allowPublicKeyRetrieval=true";
    private static final String USER = "root"; 
    private static final String PASSWORD = ""; // Default is empty for XAMPP

    private static Connection connection = null;

    /**
     * Returns a single instance of the database connection.
     * @return Connection object
     */
    public static Connection getConnection() {
        try {
            // Check if connection is null or closed before creating a new one
            if (connection == null || connection.isClosed()) {
                // Register the MySQL Driver
                Class.forName("com.mysql.cj.jdbc.Driver");
                
                // Establish Connection
                connection = DriverManager.getConnection(URL, USER, PASSWORD);
                System.out.println("Database Connected Successfully!");
            }
        } catch (ClassNotFoundException | SQLException e) {
            System.out.println("Connection Failed! Check your MySQL service or credentials.");
            e.printStackTrace();
        }
        return connection;
    }

    /**
     * Utility method to close the connection properly.
     */
    public static void closeConnection() {
        if (connection != null) {
            try {
                connection.close();
                System.out.println("Connection Closed.");
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}