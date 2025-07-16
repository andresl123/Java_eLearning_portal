<%-- 
    Document   : adminPanel
    Created on : Jun 8, 2025, 1:27:19 PM
    Author     : samit
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Panel</title>
    <!-- Bootstrap CSS CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/adminPanel.css">
        <!-- Toastr CSS -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.css" rel="stylesheet" />

    <!-- jQuery (required by Toastr) -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <!-- Toastr JS -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js"></script>
    
    <script src="js/scripts.js"></script>
</head>
<body>

    <div class="admin-container">
        <h1>Admin - User Management</h1>

        <form action="AdminServlet" method="post">
            <input type="hidden" name="action" value="create_or_update">

            <div class="mb-3">
                <label for="userId" class="form-label">User ID (for edit/delete)</label>
                <input type="text" class="form-control" id="userId" name="userId">
            </div>
            
            <div class="mb-3">
                <label for="roleId" class="form-label">Role</label>
                <select class="form-select" id="roleId" name="roleId" required>
                    <option value="">Select a role</option>
                    <option value="1">Admin</option>
                    <option value="2">Student</option>
                    <option value="3">Tutor</option>
                </select>
            </div>

            <div class="mb-3">
                <label for="username" class="form-label">Username</label>
                <input type="text" class="form-control" id="username" name="username" required>
            </div>
            
            <div class="mb-3">
                <label for="lastName" class="form-label">User last name</label>
                <input type="text" class="form-control" id="lastName" name="lastName" required>
            </div>

            <div class="mb-3">
                <label for="email" class="form-label">Email</label>
                <input type="email" class="form-control" id="email" name="email" required>
            </div>

            <div class="mb-3">
                <label for="password" class="form-label">Password</label>
                <input type="password" class="form-control" id="password" name="password" required>
            </div>

            <div class="mb-3">
                <label for="tutorDesc" class="form-label">Tutor's Description</label>
                <input type="text" class="form-control" id="tutorDesc" name="tutorDesc" required>
            </div>

            <div class="d-grid gap-2 d-md-flex justify-content-md-between">
                <button type="submit" name="submit" value="create" class="btn btn-yellow">Create</button>
                <button type="submit" name="submit" value="edit" class="btn btn-purple">Edit</button>
                <button type="submit" name="submit" value="delete" class="btn btn-danger">Delete</button>
            </div>
        </form>

        <hr class="my-4" style="border-top: 2px solid #ffc107;">

        <form action="AdminServlet" method="get" class="text-center">
            <button type="submit" name="action" value="list" class="btn btn-outline-warning">View All Users</button>
        </form>
    </div>
    <footer>
        <h2>Welcome, <%= session.getAttribute("username") %></h2>
        <h2>with Role: <%= session.getAttribute("role") %></h2>
    </footer>

</body>
</html>
