package com.elearningplatform.servlet;

import java.io.IOException;
import java.sql.*;
import java.util.*;

import com.elearningplatform.model.Course;
import com.elearningplatform.util.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/CourseServlet")
public class CourseServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        System.out.println("CourseServlet doPost - action: " + action);

        if ("add".equals(action)) {
            handleAddCourse(request, response);
        } else if ("edit".equals(action)) {
            handleEditCourse(request, response);
        } else if ("delete".equals(action)) {
            handleDeleteCourse(request, response);
        } else if ("toggleVisibility".equals(action)) {
            handleToggleVisibility(request, response);
        } else {
            response.sendRedirect("tutorDashboard.jsp");
        }
    }

    private void handleAddCourse(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Read and parse form data
            int userId = Integer.parseInt(request.getParameter("userId"));
            int roleId = Integer.parseInt(request.getParameter("roleId"));
            String name = request.getParameter("name");
            int price = Integer.parseInt(request.getParameter("price"));
            String status = request.getParameter("status");
            boolean enroll = Boolean.parseBoolean(request.getParameter("enroll"));
            String desc = request.getParameter("desc");
            String category = request.getParameter("category");
            String courseImage = request.getParameter("courseImage");
            int rating = Integer.parseInt(request.getParameter("rating"));

            // Create and connect to DB
            DBConnection db = new DBConnection();
            db.connect();

            String query = "INSERT INTO Course (user_id, role_id, course_name, course_price, course_status, course_enroll, course_desc, course_category, course_image, course_rating) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement pstmt = db.getConn().prepareStatement(query);
            pstmt.setInt(1, userId);
            pstmt.setInt(2, roleId);
            pstmt.setString(3, name);
            pstmt.setInt(4, price);
            pstmt.setString(5, status);
            pstmt.setBoolean(6, enroll);
            pstmt.setString(7, desc);
            pstmt.setString(8, category);
            pstmt.setString(9, courseImage);
            pstmt.setInt(10, rating);
            pstmt.executeUpdate();

            request.setAttribute("message", "Course created successfully.");
        } catch (Exception e) {
            request.setAttribute("message", "Error creating course: " + e.getMessage());
        }

        request.getRequestDispatcher("tutorDashboard.jsp").forward(request, response);
    }

    private void handleEditCourse(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int courseId = Integer.parseInt(request.getParameter("courseId"));
            String name = request.getParameter("name");
            int price = Integer.parseInt(request.getParameter("price"));
            String status = request.getParameter("status");
            boolean enroll = Boolean.parseBoolean(request.getParameter("enroll"));
            String desc = request.getParameter("desc");
            String category = request.getParameter("category");
            String courseImage = request.getParameter("courseImage");
            int rating = Integer.parseInt(request.getParameter("rating"));

            DBConnection db = new DBConnection();
            db.connect();

            String query = "UPDATE Course SET course_name = ?, course_price = ?, course_status = ?, course_enroll = ?, course_desc = ?, course_category = ?, course_image = ?, course_rating = ? WHERE course_id = ?";
            PreparedStatement pstmt = db.getConn().prepareStatement(query);
            pstmt.setString(1, name);
            pstmt.setInt(2, price);
            pstmt.setString(3, status);
            pstmt.setBoolean(4, enroll);
            pstmt.setString(5, desc);
            pstmt.setString(6, category);
            pstmt.setString(7, courseImage);
            pstmt.setInt(8, rating);
            pstmt.setInt(9, courseId);
            pstmt.executeUpdate();

            request.setAttribute("message", "Course updated successfully.");
        } catch (Exception e) {
            request.setAttribute("message", "Error updating course: " + e.getMessage());
        }

        response.sendRedirect("tutorDashboard.jsp");
    }

    private void handleDeleteCourse(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int courseId = Integer.parseInt(request.getParameter("courseId"));

            DBConnection db = new DBConnection();
            db.connect();

            // First delete related records (enrollments, course details)
            String deleteEnrollments = "DELETE FROM Enrollment WHERE course_id = ?";
            PreparedStatement pstmt1 = db.getConn().prepareStatement(deleteEnrollments);
            pstmt1.setInt(1, courseId);
            pstmt1.executeUpdate();

            String deleteCourseDetails = "DELETE FROM Course_details WHERE course_id = ?";
            PreparedStatement pstmt2 = db.getConn().prepareStatement(deleteCourseDetails);
            pstmt2.setInt(1, courseId);
            pstmt2.executeUpdate();

            // Then delete the course
            String deleteCourse = "DELETE FROM Course WHERE course_id = ?";
            PreparedStatement pstmt3 = db.getConn().prepareStatement(deleteCourse);
            pstmt3.setInt(1, courseId);
            pstmt3.executeUpdate();

            request.setAttribute("message", "Course deleted successfully.");
        } catch (Exception e) {
            request.setAttribute("message", "Error deleting course: " + e.getMessage());
        }

        response.sendRedirect("tutorDashboard.jsp");
    }

    private void handleToggleVisibility(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int courseId = Integer.parseInt(request.getParameter("courseId"));

            DBConnection db = new DBConnection();
            db.connect();

            // Get current status
            String getStatusQuery = "SELECT course_status FROM Course WHERE course_id = ?";
            PreparedStatement pstmt1 = db.getConn().prepareStatement(getStatusQuery);
            pstmt1.setInt(1, courseId);
            ResultSet rs = pstmt1.executeQuery();

            if (rs.next()) {
                String currentStatus = rs.getString("course_status");
                String newStatus = "Hidden".equalsIgnoreCase(currentStatus) ? "Active" : "Hidden";

                // Update status
                String updateQuery = "UPDATE Course SET course_status = ? WHERE course_id = ?";
                PreparedStatement pstmt2 = db.getConn().prepareStatement(updateQuery);
                pstmt2.setString(1, newStatus);
                pstmt2.setInt(2, courseId);
                pstmt2.executeUpdate();

                request.setAttribute("message", "Course visibility toggled successfully.");
            }
        } catch (Exception e) {
            request.setAttribute("message", "Error toggling course visibility: " + e.getMessage());
        }

        response.sendRedirect("tutorDashboard.jsp");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String userIdParam = request.getParameter("userId");

        System.out.println("CourseServlet doGet - action: " + action + ", userId: " + userIdParam);

        if ("edit".equals(action)) {
            handleGetEditCourse(request, response);
        } else if (userIdParam != null) {
            handleGetCoursesByUser(request, response);
        } else {
            response.sendRedirect("tutorDashboard.jsp");
        }
    }

    private void handleGetEditCourse(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int courseId = Integer.parseInt(request.getParameter("courseId"));
            
            DBConnection db = new DBConnection();
            db.connect();

            String query = "SELECT * FROM Course WHERE course_id = ?";
            PreparedStatement pstmt = db.getConn().prepareStatement(query);
            pstmt.setInt(1, courseId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                Course course = new Course();
                course.setCourseId(rs.getInt("course_id"));
                course.setUserId(rs.getInt("user_id"));
                course.setRoleId(rs.getInt("role_id"));
                course.setName(rs.getString("course_name"));
                course.setPrice(rs.getInt("course_price"));
                course.setStatus(rs.getString("course_status"));
                course.setEnroll(rs.getBoolean("course_enroll"));
                course.setDesc(rs.getString("course_desc"));
                course.setCategory(rs.getString("course_category"));
                course.setCourseImage(rs.getString("course_image"));
                course.setRating(rs.getInt("course_rating"));
                
                request.setAttribute("course", course);
                request.setAttribute("editMode", true);
            }
        } catch (Exception e) {
            request.setAttribute("message", "Error fetching course: " + e.getMessage());
        }

        request.getRequestDispatcher("editCourse.jsp").forward(request, response);
    }

    private void handleGetCoursesByUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int userId = Integer.parseInt(request.getParameter("userId"));
            DBConnection db = new DBConnection();
            db.connect();

            String query = "SELECT * FROM Course WHERE user_id = ?";
            PreparedStatement pstmt = db.getConn().prepareStatement(query);
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();

            List<Course> courseList = new ArrayList<>();
            while (rs.next()) {
                Course c = new Course();
                c.setCourseId(rs.getInt("course_id"));
                c.setUserId(rs.getInt("user_id"));
                c.setRoleId(rs.getInt("role_id"));
                c.setName(rs.getString("course_name"));
                c.setPrice(rs.getInt("course_price"));
                c.setStatus(rs.getString("course_status"));
                c.setEnroll(rs.getBoolean("course_enroll"));
                                    c.setDesc(rs.getString("course_desc"));
                    c.setCategory(rs.getString("course_category"));
                    c.setCourseImage(rs.getString("course_image"));
                    c.setRating(rs.getInt("course_rating"));
                courseList.add(c);
            }

            request.setAttribute("courseList", courseList);
        } catch (Exception e) {
            request.setAttribute("message", "Error fetching courses: " + e.getMessage());
        }

        request.getRequestDispatcher("courseDetails.jsp").forward(request, response);
    }
}
