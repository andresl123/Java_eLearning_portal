package com.elearningplatform.servlet;

import com.elearningplatform.util.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.ArrayList;

@WebServlet("/ProgressServlet")
public class ProgressServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        Integer userId = (Integer) request.getSession().getAttribute("userId");
        
        if (userId == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "User not logged in");
            return;
        }
        
        try {
            DBConnection db = new DBConnection();
            db.connect();
            
            if ("markSectionComplete".equals(action)) {
                handleMarkSectionComplete(request, response, db, userId);
            } else if ("updateCourseProgress".equals(action)) {
                handleUpdateCourseProgress(request, response, db, userId);
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
            }
            
            db.closeResources();
        } catch (SQLException e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + e.getMessage());
        }
    }
    
    private void handleMarkSectionComplete(HttpServletRequest request, HttpServletResponse response, 
                                        DBConnection db, Integer userId) throws SQLException, IOException {
        
        int courseId = Integer.parseInt(request.getParameter("courseId"));
        int sectionId = Integer.parseInt(request.getParameter("sectionId"));
        
        // Check if user is enrolled in the course
        if (!db.isStudentEnrolled(userId, courseId)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "User not enrolled in this course");
            return;
        }
        
        // Get total sections for the course
        int totalSections = getTotalSections(db, courseId);
        
        // Get completed sections count (you might want to create a separate table for this)
        int completedSections = getCompletedSections(db, userId, courseId);
        
        // Calculate new progress percentage
        int newProgress = (int) Math.round((double) completedSections / totalSections * 100);
        
        // Update enrollment progress
        boolean success = db.updateEnrollmentProgress(userId, courseId, newProgress);
        
        // Update completion status if progress is 100%
        if (newProgress >= 100) {
            db.updateEnrollmentStatus(userId, courseId, "Completed");
        }
        
        // Send JSON response
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        String jsonResponse = String.format(
            "{\"success\": %s, \"newProgress\": %d, \"completedSections\": %d, \"totalSections\": %d}",
            success, newProgress, completedSections, totalSections
        );
        response.getWriter().write(jsonResponse);
    }
    
    private void handleUpdateCourseProgress(HttpServletRequest request, HttpServletResponse response, 
                                         DBConnection db, Integer userId) throws SQLException, IOException {
        
        int courseId = Integer.parseInt(request.getParameter("courseId"));
        
        // Check if user is enrolled in the course
        if (!db.isStudentEnrolled(userId, courseId)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "User not enrolled in this course");
            return;
        }
        
        // Get total sections for the course
        int totalSections = getTotalSections(db, courseId);
        
        // Get completed sections count
        int completedSections = getCompletedSections(db, userId, courseId);
        
        // Calculate progress percentage
        int progress = totalSections > 0 ? (int) Math.round((double) completedSections / totalSections * 100) : 0;
        
        // Update enrollment progress
        boolean success = db.updateEnrollmentProgress(userId, courseId, progress);
        
        // Update completion status if progress is 100%
        if (progress >= 100) {
            db.updateEnrollmentStatus(userId, courseId, "Completed");
        }
        
        // Send JSON response
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        String jsonResponse = String.format(
            "{\"success\": %s, \"progress\": %d, \"completedSections\": %d, \"totalSections\": %d}",
            success, progress, completedSections, totalSections
        );
        response.getWriter().write(jsonResponse);
    }
    
    private int getTotalSections(DBConnection db, int courseId) throws SQLException {
        String query = "SELECT COUNT(*) FROM Course_details WHERE course_id = ?";
        var pstmt = db.getConn().prepareStatement(query);
        pstmt.setInt(1, courseId);
        var rs = pstmt.executeQuery();
        int count = 0;
        if (rs.next()) {
            count = rs.getInt(1);
        }
        rs.close();
        pstmt.close();
        return count;
    }
    
    private int getCompletedSections(DBConnection db, Integer userId, int courseId) throws SQLException {
        // This is a simplified implementation
        // In a real application, you might want to create a separate table to track completed sections
        // For now, we'll return a random number between 0 and total sections for demonstration
        
        int totalSections = getTotalSections(db, courseId);
        return (int) (Math.random() * (totalSections + 1)); // Random for demo purposes
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "GET method not supported");
    }
} 