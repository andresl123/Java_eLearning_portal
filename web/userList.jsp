<%@page import="com.elearningplatform.model.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>User List</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-5">
    <h2 class="mb-4 text-center">Registered Users</h2>

    <table class="table table-bordered table-striped">
        <thead class="table-dark">
            <tr>
                <th>ID</th>
                <th>Role ID</th>
                <th>First Name</th>
                <th>Last Name</th>
                <th>Email</th>
                <th>Tutor Description</th>
            </tr>
        </thead>
        <tbody>
            <%
                List<User> users = (List<User>) request.getAttribute("users");
                if (users != null && !users.isEmpty()) {
                    for (User user : users) {
            %>
                <tr>
                    <td><%= user.getUserId() %></td>
                    <td><%= user.getRoleId() %></td>
                    <td><%= user.getFirstName() %></td>
                    <td><%= user.getLastName() %></td>
                    <td><%= user.getEmail() %></td>
                    <td><%= user.getTutorDesc() %></td>
                </tr>
            <%
                    }
                } else {
            %>
                <tr><td colspan="6" class="text-center">No users found.</td></tr>
            <%
                }
            %>
        </tbody>
    </table>

    <div class="text-center mt-4">
        <a href="adminPanel.jsp" class="btn btn-secondary">Back to Admin Panel</a>
    </div>
</div>
</body>
</html>
