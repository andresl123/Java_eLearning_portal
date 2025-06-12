package com.dummy.servlet;

import com.dummy.model.Item;
import com.dummy.dao.ItemDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

// Servlet to handle form submission
@WebServlet("/DummyServlet")
public class DummyServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get form parameters with null check
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        System.out.println("Received: name=" + name + ", description=" + description);

        // Validate input
        if (name == null || name.trim().isEmpty() || description == null || description.trim().isEmpty()) {
            System.out.println("Error: Name or description is empty or null");
            request.setAttribute("message", "Error: Name and description are required.");
            request.getRequestDispatcher("dummyForm.jsp").forward(request, response);
            return;
        }

        // Create Item object
        Item item = new Item(name.trim(), description.trim());
        ItemDAO itemDAO = new ItemDAO();

        // Attempt to add item to database
        boolean success = false;
        try {
            success = itemDAO.addItem(item);
            System.out.println("Add item success: " + success);
        } catch (Exception e) {
            System.out.println("Exception in DummyServlet: " + e.getMessage());
            e.printStackTrace();
        }

        // Set message based on result
        request.setAttribute("message", success ? "Item added successfully!" : "Failed to add item.");

        // Always forward back to the form
        request.getRequestDispatcher("dummyForm.jsp").forward(request, response);
    }
}