package com.elearningplatform.servlet;

import com.elearningplatform.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;


// Placeholder: Implement doPost to handle login form submission, validate user via UserDAO, and redirect.
// Connects to: UserDAO for authentication, login.jsp for form input, studentDashboard.jsp/adminPanel.jsp for redirect.
@WebServlet("/Login")
public class LoginServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String userEmail = request.getParameter("userEmail");
        String password = request.getParameter("password");
        try {
            
            DBConnection db = new DBConnection();
            db.connect();
            
            boolean loginSuccess = db.verifyUserLogin(userEmail, password);

            if (loginSuccess) {
                response.sendRedirect("index.jsp?login=success");
            } else {
                response.sendRedirect("login_student.jsp?login=fail");
            }

            
        } catch (SQLException ex) {
            System.out.print(ex);
            response.sendRedirect("login_student.jsp?login=error");
            }
        }
}