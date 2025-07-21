package com.elearningplatform.servlet;

import com.elearningplatform.util.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/SectionServlet")
public class SectionServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("add".equals(action)) {
            try {
                int courseId = Integer.parseInt(request.getParameter("courseId"));
                String sectionTitle = request.getParameter("sectionTitle");
                int duration = Integer.parseInt(request.getParameter("duration"));
                String sectionDesc = request.getParameter("sectionDesc");
                String sectionVideoUrl = request.getParameter("sectionVideoUrl");

                DBConnection db = new DBConnection();
                db.connect();
                boolean success = db.insertCourseDetail(courseId, sectionTitle, duration, sectionDesc, sectionVideoUrl);
                db.closeResources();
                if (success) {
                    request.setAttribute("message", "Section added successfully.");
                } else {
                    request.setAttribute("message", "Failed to add section.");
                }
            } catch (Exception e) {
                request.setAttribute("message", "Error: " + e.getMessage());
            }
            request.getRequestDispatcher("manageSections.jsp?courseId=" + request.getParameter("courseId")).forward(request, response);
            return;
        }
        if ("delete".equals(action)) {
            try {
                int sectionId = Integer.parseInt(request.getParameter("sectionId"));
                int courseId = Integer.parseInt(request.getParameter("courseId"));
                DBConnection db = new DBConnection();
                db.connect();
                boolean success = db.deleteCourseDetail(sectionId);
                db.closeResources();
                if (success) {
                    request.setAttribute("message", "Section deleted successfully.");
                } else {
                    request.setAttribute("message", "Failed to delete section.");
                }
                request.getRequestDispatcher("manageSections.jsp?courseId=" + courseId).forward(request, response);
                return;
            } catch (Exception e) {
                request.setAttribute("message", "Error: " + e.getMessage());
                request.getRequestDispatcher("manageSections.jsp").forward(request, response);
                return;
            }
        }
        if ("edit".equals(action)) {
            try {
                int sectionId = Integer.parseInt(request.getParameter("sectionId"));
                int courseId = Integer.parseInt(request.getParameter("courseId"));
                String sectionTitle = request.getParameter("sectionTitle");
                int duration = Integer.parseInt(request.getParameter("duration"));
                String sectionDesc = request.getParameter("sectionDesc");
                String sectionVideoUrl = request.getParameter("sectionVideoUrl");

                DBConnection db = new DBConnection();
                db.connect();
                boolean success = db.updateCourseDetail(sectionId, sectionTitle, duration, sectionDesc, sectionVideoUrl);
                db.closeResources();
                if (success) {
                    request.setAttribute("message", "Section updated successfully.");
                } else {
                    request.setAttribute("message", "Failed to update section.");
                }
                request.getRequestDispatcher("manageSections.jsp?courseId=" + courseId).forward(request, response);
                return;
            } catch (Exception e) {
                request.setAttribute("message", "Error: " + e.getMessage());
                request.getRequestDispatcher("manageSections.jsp").forward(request, response);
                return;
            }
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Forwards to manageSections.jsp (JSP loads sections directly)
        request.getRequestDispatcher("manageSections.jsp").forward(request, response);
    }
} 