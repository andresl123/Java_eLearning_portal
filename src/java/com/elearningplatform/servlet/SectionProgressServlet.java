package com.elearningplatform.servlet;

import com.elearningplatform.util.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/SectionProgressServlet")
public class SectionProgressServlet extends HttpServlet {
    private DBConnection db;

    @Override
    public void init() {
        db = new DBConnection();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        
        if (userId == null) {
            out.print("{\"success\": false, \"message\": \"User not logged in\"}");
            return;
        }
        
        try {
            String action = request.getParameter("action");
            int courseId = Integer.parseInt(request.getParameter("courseId"));
            int sectionId = Integer.parseInt(request.getParameter("sectionId"));
            
            boolean success = false;
            String message = "";
            
            switch (action) {
                case "complete":
                    success = db.markSectionComplete(userId, courseId, sectionId);
                    message = success ? "Section marked as complete" : "Failed to mark section complete";
                    break;
                    
                case "incomplete":
                    success = db.markSectionIncomplete(userId, sectionId);
                    message = success ? "Section marked as incomplete" : "Failed to mark section incomplete";
                    break;
                    
                default:
                    message = "Invalid action";
                    break;
            }
            
            // Build JSON response
            StringBuilder jsonResponse = new StringBuilder();
            jsonResponse.append("{");
            jsonResponse.append("\"success\": ").append(success).append(",");
            jsonResponse.append("\"message\": \"").append(message).append("\"");
            
            // Get updated progress information
            if (success) {
                // Get current enrollment info for updated progress
                String query = "SELECT progress_percentage, completion_status FROM Enrollment WHERE user_id = ? AND course_id = ?";
                db.connect();
                db.setPstmt(db.getConn().prepareStatement(query));
                db.getPstmt().setInt(1, userId);
                db.getPstmt().setInt(2, courseId);
                db.setRs(db.getPstmt().executeQuery());
                
                if (db.getRs().next()) {
                    int progressPercentage = db.getRs().getInt("progress_percentage");
                    String completionStatus = db.getRs().getString("completion_status");
                    jsonResponse.append(",\"progressPercentage\": ").append(progressPercentage);
                    jsonResponse.append(",\"completionStatus\": \"").append(completionStatus).append("\"");
                }
                
                // Get total sections and completed sections for this course
                String totalQuery = "SELECT COUNT(*) as total FROM Course_details WHERE course_id = ?";
                db.setPstmt(db.getConn().prepareStatement(totalQuery));
                db.getPstmt().setInt(1, courseId);
                db.setRs(db.getPstmt().executeQuery());
                int totalSections = 0;
                if (db.getRs().next()) {
                    totalSections = db.getRs().getInt("total");
                }
                
                String completedQuery = "SELECT COUNT(*) as completed FROM Section_Progress WHERE user_id = ? AND course_id = ? AND is_completed = TRUE";
                db.setPstmt(db.getConn().prepareStatement(completedQuery));
                db.getPstmt().setInt(1, userId);
                db.getPstmt().setInt(2, courseId);
                db.setRs(db.getPstmt().executeQuery());
                int completedSections = 0;
                if (db.getRs().next()) {
                    completedSections = db.getRs().getInt("completed");
                }
                
                jsonResponse.append(",\"totalSections\": ").append(totalSections);
                jsonResponse.append(",\"completedSections\": ").append(completedSections);
            }
            
            jsonResponse.append("}");
            out.print(jsonResponse.toString());
            
        } catch (NumberFormatException e) {
            out.print("{\"success\": false, \"message\": \"Invalid course or section ID\"}");
        } catch (SQLException e) {
            out.print("{\"success\": false, \"message\": \"Database error: " + e.getMessage().replace("\"", "\\\"") + "\"}");
        } catch (Exception e) {
            out.print("{\"success\": false, \"message\": \"Unexpected error: " + e.getMessage().replace("\"", "\\\"") + "\"}");
        } finally {
            db.closeResources();
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        
        if (userId == null) {
            out.print("{\"success\": false, \"message\": \"User not logged in\"}");
            return;
        }
        
        try {
            int courseId = Integer.parseInt(request.getParameter("courseId"));
            
            // Get section progress for the course
            db.connect();
            db.setRs(db.getSectionProgressForCourse(userId, courseId));
            
            StringBuilder jsonResponse = new StringBuilder();
            jsonResponse.append("{\"success\": true, \"sections\": {");
            
            boolean first = true;
            while (db.getRs().next()) {
                if (!first) {
                    jsonResponse.append(",");
                }
                int sectionId = db.getRs().getInt("section_id");
                boolean isCompleted = db.getRs().getBoolean("is_completed");
                jsonResponse.append("\"").append(sectionId).append("\": ").append(isCompleted);
                first = false;
            }
            
            jsonResponse.append("}}");
            out.print(jsonResponse.toString());
            
        } catch (NumberFormatException e) {
            out.print("{\"success\": false, \"message\": \"Invalid course ID\"}");
        } catch (SQLException e) {
            out.print("{\"success\": false, \"message\": \"Database error: " + e.getMessage().replace("\"", "\\\"") + "\"}");
        } catch (Exception e) {
            out.print("{\"success\": false, \"message\": \"Unexpected error: " + e.getMessage().replace("\"", "\\\"") + "\"}");
        } finally {
            db.closeResources();
        }
    }
} 