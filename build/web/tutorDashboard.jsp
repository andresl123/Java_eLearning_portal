<%-- 
    Document   : tutorDashboard
    Created on : Jun 8, 2025, 1:26:59 PM
    Author     : samit
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.elearningplatform.util.DBConnection, java.sql.*" %>
<%@ include file="navbar.jsp" %> <!-- Pulling in that navbar with the search bar -->
<%
    // --- Access control: Only allow tutors (role == 3) to access this page ---
    Integer role = (Integer) session.getAttribute("role");
    Integer userId = (Integer) session.getAttribute("userId");
    String tutorName = (String) session.getAttribute("username");
    if (role == null || role != 3) {
        response.sendRedirect("index.jsp"); // Redirect non-tutors to homepage
        return;
    }

    // --- Query the database for this tutor's courses ---
    List<Map<String, Object>> myCourses = new ArrayList<>();
    DBConnection db = new DBConnection();
    db.connect();
    ResultSet rs = db.executeQuery("SELECT * FROM Course WHERE user_id = " + userId);
    while (rs.next()) {
        Map<String, Object> course = new HashMap<>();
        course.put("id", rs.getInt("course_id"));
        course.put("name", rs.getString("course_name"));
        course.put("status", rs.getString("course_status"));
        myCourses.add(course);
    }
    db.closeResources();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Tutor Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Our custom JS, keeping it easygoing -->
    <script src="js/scripts.js"></script>
</head>
<body>
    <div class="container mt-5">
        <!-- Welcome section for the tutor -->
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card shadow-lg p-4">
                    <h2 class="mb-4 text-center">Welcome, <%= tutorName != null ? tutorName : "Tutor" %>!</h2>
                    <p class="lead text-center">This is your dashboard. You can create new courses or manage your existing ones.</p>
                    <div class="d-flex justify-content-center gap-3 mt-4">
                        <!-- Button to go to the create course page -->
                        <a href="createCourse.jsp" class="btn btn-primary btn-lg">Create New Course</a>
                    </div>
                </div>
            </div>
        </div>

        <!-- Manage My Courses Table: Shows all courses created by this tutor -->
        <h3 class="mt-5">Manage My Courses</h3>
        <table class="table table-bordered">
            <thead>
                <tr>
                    <th>Course Name</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
            <% for (Map<String, Object> course : myCourses) { 
                String status = (String) course.get("status");
                boolean isHidden = "Hidden".equalsIgnoreCase(status);
            %>
                <tr>
                    <td><%= course.get("name") %></td>
                    <td><%= status %></td>
                    <td>
                        <!-- Edit, Delete, Hide/Unhide, and Add Sections buttons for each course -->
                        <form action="CourseServlet" method="get" style="display:inline;">
                            <input type="hidden" name="action" value="edit">
                            <input type="hidden" name="courseId" value="<%= course.get("id") %>">
                            <button class="btn btn-sm btn-warning">Edit</button>
                        </form>
                        <form action="CourseServlet" method="post" style="display:inline;" onsubmit="return confirm('Are you sure you want to delete this course? This will also delete all enrollments and sections.');">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="courseId" value="<%= course.get("id") %>">
                            <button class="btn btn-sm btn-danger">Delete</button>
                        </form>
                        <form action="CourseServlet" method="post" style="display:inline;">
                            <input type="hidden" name="action" value="toggleVisibility">
                            <input type="hidden" name="courseId" value="<%= course.get("id") %>">
                            <button class="btn btn-sm btn-secondary">
                                <%= isHidden ? "Unhide" : "Hide" %>
                            </button>
                        </form>
                        <form action="manageSections.jsp" method="get" style="display:inline;">
                            <input type="hidden" name="courseId" value="<%= course.get("id") %>">
                            <button class="btn btn-sm btn-info">Add Sections</button>
                        </form>
                    </td>
                </tr>
            <% } %>
            </tbody>
        </table>
    </div>
</body>
</html>
