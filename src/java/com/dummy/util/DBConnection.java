package com.dummy.util;

import java.sql.Connection;
import java.sql.DriverManager;

// Utility class to manage database connections
public class DBConnection {
    // Database credentials (update with your MySQL details)
    private static final String URL = "jdbc:mysql://localhost:3306/dummy_db";
    private static final String USER = "root";
    private static final String PASS = "1234"; // Replace with your MySQL password

    // Method to get a database connection
    public static Connection getConnection() throws Exception {
        Class.forName("com.mysql.cj.jdbc.Driver"); // Load MySQL driver (requires Connector/J JAR)
        return DriverManager.getConnection(URL, USER, PASS);
    }
    
    public static void main(String[] args) {
        try {
            Connection conn = getConnection();
            System.out.println("Connection successful!");
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}