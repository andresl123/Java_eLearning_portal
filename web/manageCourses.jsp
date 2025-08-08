<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.elearningplatform.util.DBConnection, java.sql.*" %>
<%
    // --- Access control: Only allow admins (role == 1) and tutors (role == 3) ---
    Integer role = (Integer) session.getAttribute("role");
    Integer userId = (Integer) session.getAttribute("userId");
    if (role == null || (role != 1 && role != 3)) {
        response.sendRedirect("index.jsp"); // Redirect others to homepage
        return;
    }

    // --- Query the database for courses ---
    // Admins see all courses; tutors see only their own
    List<Map<String, Object>> courses = new ArrayList<>();
    DBConnection db = new DBConnection();
    db.connect();
    String query = (role == 1)
        ? "SELECT * FROM Course"
        : "SELECT * FROM Course WHERE user_id = " + userId;
    ResultSet rs = db.executeQuery(query);
    while (rs.next()) {
        Map<String, Object> course = new HashMap<>();
        course.put("id", rs.getInt("course_id"));
        course.put("name", rs.getString("course_name"));
        course.put("status", rs.getString("course_status"));
        course.put("owner", rs.getInt("user_id"));
        courses.add(course);
    }
    db.closeResources();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Courses</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/styles.css">
</head>
<body>
    <%@ include file="navbar.jsp" %>
    <div class="container mt-5">
        <!-- Table listing all courses for admins, or only own courses for tutors -->
        <h3 class="mb-4">Manage Courses</h3>
        
        <%
            String message = (String) request.getAttribute("message");
            if (message != null) {
        %>
            <div class="alert alert-info"><%= message %></div>
        <%
            }
        %>
        <table class="table table-bordered">
            <thead>
                <tr>
                    <th>Course Name</th>
                    <th>Status</th>
                    <th>Owner ID</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
            <% for (Map<String, Object> course : courses) { 
                String status = (String) course.get("status");
                boolean isHidden = "Hidden".equalsIgnoreCase(status);
            %>
                <tr>
                    <td><%= course.get("name") %></td>
                    <td><%= status %></td>
                    <td><%= course.get("owner") %></td>
                    <td>
                        <!-- Edit, Delete, and Hide/Unhide buttons for each course -->
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
                    </td>
                </tr>
            <% } %>
            </tbody>
        </table>
    </div>
</body>
</html> 