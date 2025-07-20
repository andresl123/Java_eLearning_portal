import java.io.IOException;
import java.sql.*;
import java.util.*;

import com.elearningplatform.model.Course; // Make sure this matches your package
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

        if ("add".equals(action)) {
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
                int rating = Integer.parseInt(request.getParameter("rating"));

                // Create and connect to DB
                DBConnection db = new DBConnection();
                db.connect();

                String query = "INSERT INTO Course (user_id, role_id, course_name, course_price, course_status, course_enroll, course_desc, course_category, course_rating) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
                PreparedStatement pstmt = db.getConn().prepareStatement(query);
                pstmt.setInt(1, userId);
                pstmt.setInt(2, roleId);
                pstmt.setString(3, name);
                pstmt.setInt(4, price);
                pstmt.setString(5, status);
                pstmt.setBoolean(6, enroll);
                pstmt.setString(7, desc);
                pstmt.setString(8, category);
                pstmt.setInt(9, rating);
                pstmt.executeUpdate();

                request.setAttribute("message", "Course created successfully.");
            } catch (Exception e) {
                request.setAttribute("message", "Error creating course: " + e.getMessage());
            }

            request.getRequestDispatcher("courseDetails.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String userIdParam = request.getParameter("userId");

        if (userIdParam != null) {
            try {
                int userId = Integer.parseInt(userIdParam);
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
                    c.setRating(rs.getInt("course_rating"));
                    courseList.add(c);
                }

                request.setAttribute("courseList", courseList);
            } catch (Exception e) {
                request.setAttribute("message", "Error fetching courses: " + e.getMessage());
            }
        }

        request.getRequestDispatcher("courseDetails.jsp").forward(request, response);
    }
}
