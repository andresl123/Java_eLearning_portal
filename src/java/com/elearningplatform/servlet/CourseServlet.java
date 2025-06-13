package com.elearningplatform.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

// Placeholder: Implement doPost to handle course-related actions (e.g., view, enroll) via CourseDAO.
// Connects to: CourseDAO for course data, tutorCourses.jsp/studentDashboard.jsp for display.
@WebServlet("/CourseServlet")
public class CourseServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    }
}