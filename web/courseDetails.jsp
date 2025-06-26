<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.elearningplatform.model.CourseDetail" %> <%-- Update this package to match yours --%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Create and View Courses</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/courseStyle.css">
</head>
<body>
<div class="container mt-5">

    <!-- ✅ Course Creation Form -->
    <h2 class="mb-4 text-center">Create New Course</h2>
    <form action="CourseServlet" method="post" class="p-4 border rounded">
        <input type="hidden" name="action" value="add">

        <div class="mb-3">
            <label class="form-label">User ID</label>
            <input type="number" class="form-control" name="userId" required>
        </div>

        <div class="mb-3">
            <label class="form-label">Role ID</label>
            <input type="number" class="form-control" name="roleId" required>
        </div>

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
            <input type="text" class="form-control" name="status" required>
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

    <!-- ✅ Message -->
    <%
        String message = (String) request.getAttribute("message");
        if (message != null) {
    %>
        <div class="alert alert-info mt-4"><%= message %></div>
    <%
        }
    %>

    <hr class="my-5">

    <!-- ✅ Course Retrieval Form -->
    <h2 class="mb-4 text-center">View Courses by User ID</h2>
    <form action="CourseServlet" method="get" class="mb-4">
        <div class="input-group">
            <input type="number" class="form-control" name="userId" placeholder="Enter User ID" required>
            <button type="submit" class="btn btn-secondary">Get Courses</button>
        </div>
    </form>

    <!-- ✅ Course Table -->
    <%
        List<CourseDetail> courseList = (List<CourseDetail>) request.getAttribute("courseList");
        if (courseList != null && !courseList.isEmpty()) {
    %>
        <table class="table table-bordered table-striped">
            <thead>
                <tr>
                    <th>Course ID</th>
                    <th>User ID</th>
                    <th>Role ID</th>
                    <th>Name</th>
                    <th>Price</th>
                    <th>Status</th>
                    <th>Enroll</th>
                    <th>Description</th>
                    <th>Category</th>
                    <th>Rating</th>
                </tr>
            </thead>
            <tbody>
            <%
                for (CourseDetail c : courseList) {
            %>
                <tr>
                    <td><%= c.getCourseId() %></td>
                    <td><%= c.getUserId() %></td>
                    <td><%= c.getRoleId() %></td>
                    <td><%= c.getName() %></td>
                    <td>$<%= c.getPrice() %></td>
                    <td><%= c.getStatus() %></td>
                    <td><%= c.isEnroll() ? "Yes" : "No" %></td>
                    <td><%= c.getDesc() %></td>
                    <td><%= c.getCategory() %></td>
                    <td><%= c.getRating() %></td>
                </tr>
            <%
                }
            %>
            </tbody>
        </table>
    <%
        } else if (request.getParameter("userId") != null) {
    %>
        <div class="alert alert-warning">No courses found for this user.</div>
    <%
        }
    %>
</div>
</body>
</html>
