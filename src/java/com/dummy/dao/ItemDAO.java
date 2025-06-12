package com.dummy.dao;

import com.dummy.model.Item;
import com.dummy.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;

// DAO class to handle database operations for Items
public class ItemDAO {
    // Method to add a new item to the database
    public boolean addItem(Item item) {
        String sql = "INSERT INTO Items (name, description) VALUES (?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            // Set parameters for the SQL query
            stmt.setString(1, item.getName());
            stmt.setString(2, item.getDescription());
            // Execute the query
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0; // Return true if insertion was successful
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Database error: " + e.getMessage());
            return false;
        }
    }
}