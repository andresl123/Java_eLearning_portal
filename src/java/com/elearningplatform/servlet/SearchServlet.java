package com.elearningplatform.servlet;

import com.elearningplatform.util.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * Servlet to handle course search based on title keywords.
 * Mapped to /SearchServlet and forwards results to allCourses.jsp.
 */
@WebServlet("/SearchServlet")
public class SearchServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * Handles GET requests to search for courses.
     * @param request Contains the search query parameter.
     * @param response Forwards to allCourses.jsp with search results.
     * @throws ServletException If a servlet-specific error occurs.
     * @throws IOException If an I/O error occurs.
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String query = request.getParameter("query");
        List<String[]> results = new ArrayList<>();
        DBConnection db = new DBConnection();

        try {
            db.connect(); // Establish the connection
            Connection conn = db.getConn(); // Get the connection from DBConnection
            if (conn != null) {
                if (query != null && !query.trim().isEmpty()) {
                    // Use prepared statement to prevent SQL injection
                    String sql = "SELECT course_id, course_name, course_price, course_category, course_rating, course_image " +
                                 "FROM Course WHERE course_status = 'Active' AND LOWER(course_name) LIKE ? ORDER BY course_rating DESC";
                    try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                        pstmt.setString(1, "%" + query.toLowerCase() + "%");
                        try (ResultSet rs = pstmt.executeQuery()) {
                            while (rs.next()) {
                                int courseId = rs.getInt("course_id");
                                String courseName = rs.getString("course_name");
                                int coursePrice = rs.getInt("course_price");
                                String courseCategory = rs.getString("course_category");
                                int courseRating = rs.getInt("course_rating");
                                String courseImage = rs.getString("course_image");
                                results.add(new String[]{String.valueOf(courseId), courseName, String.valueOf(coursePrice), courseCategory, String.valueOf(courseRating), courseImage});
                            }
                        }
                    }
                }
            }
        } catch (SQLException e) {
            System.out.println("Search failed: " + e.getMessage());
        } finally {
            db.closeResources(); // Clean up resources using DBConnection's method
        }

        // Pass results to allCourses.jsp
        request.setAttribute("searchResults", results);
        request.setAttribute("searchQuery", query);
        request.getRequestDispatcher("allCourses.jsp").forward(request, response);
    }
}