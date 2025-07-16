/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.elearningplatform.servlet;

import java.sql.SQLException;
import com.elearningplatform.util.DBConnection;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 *
 * @author andre
 */
@WebServlet(name = "EnrollServlet", urlPatterns = {"/EnrollServlet"})
public class EnrollServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet EnrollServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet EnrollServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

            HttpSession session = request.getSession(false);
            Integer role = (Integer) session.getAttribute("role");
            String username = (String) session.getAttribute("username");
            // Retrieve parameters from the form submission
            String userIdStr = request.getParameter("userId");
            String courseIdStr = request.getParameter("courseId");
            // Validate that both IDs are provided
            if (userIdStr == null || courseIdStr == null || userIdStr.trim().isEmpty() || courseIdStr.trim().isEmpty()) {
                // Redirect with an error if parameters are missing or empty
                response.sendRedirect("courseDetailsStudent.jsp?courseId=" + courseIdStr + "&error=invalid_input");
                return;
            }
            
            if (!role.equals(2)) {
                request.setAttribute("error", "Only students can enroll in courses.");
                return;
            }
            int userId;
            int courseId;   
        try {
            // Parse the string IDs to integers, throwing an exception if invalid
            userId = Integer.parseInt(userIdStr);
            courseId = Integer.parseInt(courseIdStr);
        } catch (NumberFormatException e) {
            // Redirect with an error if parsing fails
            response.sendRedirect("courseDetailsStudent.jsp?courseId=" + courseIdStr + "&error=invalid_id");
            return;
        }

        DBConnection db = new DBConnection();
        try {
            db.connect();
            // Call the enrollStudent method from DBConnection to insert into Enrollment table
            boolean enrolled = db.enrollStudent(userId, courseId);
            if (enrolled) {
                // Redirect with success message if enrollment succeeds
                response.sendRedirect("courseDetailsStudent.jsp?courseId=" + courseId + "&message=enrolled_success");
            } else {
                // Redirect with error if enrollment fails (e.g., duplicate entry due to unique constraint)
                response.sendRedirect("courseDetailsStudent.jsp?courseId=" + courseId + "&error=enrollment_failed");
            }
        } catch (SQLException e) {
            // Redirect with SQL error message if database operation fails
            response.sendRedirect("courseDetailsStudent.jsp?courseId=" + courseId + "&error=sql_error&message=" + e.getMessage());
        } finally {
            // Ensure database resources are closed
            db.closeResources();
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}