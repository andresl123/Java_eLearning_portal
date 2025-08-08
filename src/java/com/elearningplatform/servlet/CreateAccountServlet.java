package com.elearningplatform.servlet;

import com.elearningplatform.util.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/CreateAccountServlet")
public class CreateAccountServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String firstName = request.getParameter("userName");
        String lastName = request.getParameter("userLastName");
        String email = request.getParameter("userEmail");
        String password = request.getParameter("userPassword");
        String roleName = request.getParameter("roleName");
        String tutorDesc = request.getParameter("tutorDesc");

        int roleId = 2; // default to Student
        if ("Tutor".equalsIgnoreCase(roleName)) {
            roleId = 3;
        }

        DBConnection db = new DBConnection();
        try {
            db.connect();

            // Check if user already exists by email
            if (db.verifyUserExist(email)) {
                request.setAttribute("error", "Email already registered. Try logging in or use another email.");
                request.getRequestDispatcher("createAccount.jsp").forward(request, response);
                return;
            }

            // Insert the user (tutorDesc only for tutors)
            boolean inserted = db.insertUser(roleId, firstName, lastName, email, password, roleId == 3 ? tutorDesc : null);

            if (inserted) {
                request.setAttribute("message", "Account created successfully!");
            } else {
                request.setAttribute("error", "Account creation failed. Please try again.");
            }

            db.closeResources();

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error occurred: " + e.getMessage());
        }

        request.getRequestDispatcher("login.jsp").forward(request, response);
    }
}
