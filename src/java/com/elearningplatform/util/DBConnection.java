package com.elearningplatform.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

// Utility class to manage database connections
public class DBConnection {
    // Constants for database connection (modify these as needed)
    private static final String DB_URL = "jdbc:mysql://localhost:3306/dummy_db"; // Database URL (change db name here)
    private static final String DB_USER = "root"; // Database username (change here)
    private static final String DB_PASS = "yourpassword"; // Database password (change here)

    // Method to get a database connection
    public static Connection getConnection() throws SQLException {
        try {
            // Load the MySQL JDBC driver (handled by Connector/J JAR)
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("MySQL JDBC Driver not found.", e);
        }
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
    }

    // Main method for testing the connection
    public static void main(String[] args) {
        try (Connection conn = getConnection()) {
            if (conn != null) {
                System.out.println("Connection to " + DB_URL + " successful!");
            } else {
                System.out.println("Failed to connect to the database.");
            }
        } catch (SQLException e) {
            System.out.println("Connection failed: " + e.getMessage());
            e.printStackTrace();
        }
    }
}