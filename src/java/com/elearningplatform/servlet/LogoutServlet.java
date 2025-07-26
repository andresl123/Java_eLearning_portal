package com.elearningplatform.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Servlet implementation class LogoutServlet
 * Handles user logout by invalidating the session and redirecting to the login page.
 * Mapped to the URL /logout and responds to GET requests.
 */
@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * Handles the GET request to log out the user.
     * @param request The HttpServletRequest object.
     * @param response The HttpServletResponse object.
     * @throws ServletException If a servlet-specific error occurs.
     * @throws IOException If an I/O error occurs.
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get the current session
        HttpSession session = request.getSession(false); // false to avoid creating a new session
        if (session != null) {
            // Invalidate the session to log out the user
            session.invalidate();
        }
        // Redirect to the login page after logout
        response.sendRedirect("login.jsp?logout=success");
    }
}