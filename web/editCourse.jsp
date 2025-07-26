<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.elearningplatform.model.Course" %>
<%
    Course course = (Course) request.getAttribute("course");
    Boolean editMode = (Boolean) request.getAttribute("editMode");
    String message = (String) request.getAttribute("message");
    
    if (course == null) {
        response.sendRedirect("manageCourses.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Course</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <%@ include file="navbar.jsp" %>
    <div class="container mt-5">
        <h2 class="mb-4">Edit Course</h2>
        
        <% if (message != null) { %>
            <div class="alert alert-info"><%= message %></div>
        <% } %>
        
        <form action="CourseServlet" method="post" class="p-4 border rounded">
            <input type="hidden" name="action" value="edit">
            <input type="hidden" name="courseId" value="<%= course.getCourseId() %>">
            
            <div class="mb-3">
                <label class="form-label">Course Name</label>
                <input type="text" class="form-control" name="name" value="<%= course.getName() %>" required>
            </div>
            
            <div class="mb-3">
                <label class="form-label">Price ($)</label>
                <input type="number" class="form-control" name="price" value="<%= course.getPrice() %>" required>
            </div>
            
            <div class="mb-3">
                <label class="form-label">Status</label>
                <select class="form-control" name="status" required>
                    <option value="Active" <%= "Active".equals(course.getStatus()) ? "selected" : "" %>>Active</option>
                    <option value="Hidden" <%= "Hidden".equals(course.getStatus()) ? "selected" : "" %>>Hidden</option>
                    <option value="Draft" <%= "Draft".equals(course.getStatus()) ? "selected" : "" %>>Draft</option>
                </select>
            </div>
            
            <div class="mb-3">
                <label class="form-label">Enrollment Open?</label><br>
                <input type="radio" name="enroll" value="true" <%= course.isEnroll() ? "checked" : "" %>> Yes
                <input type="radio" name="enroll" value="false" <%= !course.isEnroll() ? "checked" : "" %> class="ms-3"> No
            </div>
            
            <div class="mb-3">
                <label class="form-label">Description</label>
                <textarea class="form-control" name="desc" rows="3"><%= course.getDesc() != null ? course.getDesc() : "" %></textarea>
            </div>
            
            <div class="mb-3">
                <label class="form-label">Category</label>
                <input type="text" class="form-control" name="category" value="<%= course.getCategory() %>" required>
            </div>
            
            <div class="mb-3">
                <label class="form-label">Course Image URL</label>
                <input type="url" class="form-control" name="courseImage" value="<%= course.getCourseImage() != null ? course.getCourseImage() : "" %>" placeholder="https://example.com/image.jpg">
                <small class="form-text text-muted">
                    Enter a direct URL to your course image (JPG, PNG, etc.).<br>
                    Examples: https://example.com/course-image.jpg, https://via.placeholder.com/300x200
                </small>
            </div>
            
            <div class="mb-3">
                <label class="form-label">Rating (1–5)</label>
                <input type="number" class="form-control" name="rating" min="1" max="5" value="<%= course.getRating() %>" required>
            </div>
            
            <button type="submit" class="btn btn-primary">Update Course</button>
            <a href="manageCourses.jsp" class="btn btn-secondary ms-2">Cancel</a>
        </form>
    </div>
</body>
</html> 