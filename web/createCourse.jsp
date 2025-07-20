<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // --- Access control: Only allow tutors (role == 3) to access this page ---
    Integer role = (Integer) session.getAttribute("role");
    Integer userId = (Integer) session.getAttribute("userId");
    if (role == null || userId == null || role != 3) {
        response.sendRedirect("index.jsp"); // Redirect non-tutors to homepage
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Create Course</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/courseStyle.css">
</head>
<body>
    <%@ include file="navbar.jsp" %>
    <div class="container mt-5">
        <h2 class="mb-4 text-center">Create New Course</h2>
        <!-- Course creation form: tutors can fill this out to add a new course -->
        <form action="CourseServlet" method="post" class="p-4 border rounded">
            <input type="hidden" name="action" value="add">
            <input type="hidden" name="userId" value="<%= userId %>">
            <input type="hidden" name="roleId" value="<%= role %>">

            <div class="mb-3">
                <label class="form-label">Course Name</label>
                <input type="text" class="form-control" name="name" required>
            </div>

            <div class="mb-3">
                <label class="form-label">Price ($)</label>
                <input type="number" class="form-control" name="price" required>
            </div>

            <div class="mb-3">
                <label class="form-label">Status</label>
                <input type="text" class="form-control" name="status" value="Active" required>
            </div>

            <div class="mb-3">
                <label class="form-label">Enrollment Open?</label><br>
                <input type="radio" name="enroll" value="true" checked> Yes
                <input type="radio" name="enroll" value="false" class="ms-3"> No
            </div>

            <div class="mb-3">
                <label class="form-label">Description</label>
                <textarea class="form-control" name="desc" rows="3"></textarea>
            </div>

            <div class="mb-3">
                <label class="form-label">Category</label>
                <input type="text" class="form-control" name="category" required>
            </div>

            <div class="mb-3">
                <label class="form-label">Rating (1–5)</label>
                <input type="number" class="form-control" name="rating" min="1" max="5" required>
            </div>

            <button type="submit" class="btn btn-primary">Create Course</button>
        </form>

        <!-- Feedback message after form submission -->
        <% String message = (String) request.getAttribute("message");
           if (message != null) { %>
            <div class="alert alert-info mt-4"><%= message %></div>
        <% } %>
    </div>
</body>
</html> 