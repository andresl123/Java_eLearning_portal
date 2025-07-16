<%-- 
    Document   : studentDashboard
    Created on : Jun 8, 2025, 1:26:42 PM
    Author     : samit
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
    <title>Student Dashboard</title>
         <!-- navbar style -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/styles.css">
    <link rel="stylesheet" href="css/allCourses.css">
    <meta charset="UTF-8">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body style="background-color: #f9f9f9;">
    <div class="container mt-5">
        <h2 class="mb-4">Welcome, <%= session.getAttribute("username") %>!</h2>
        
            <form action="allCourses.jsp" method="get">
                <button type="submit" class="btn btn-primary">Show All Courses</button>
            </form>

        <hr>
        <%-- You can display a message or content here when courses are shown --%>
    </div>
</body>
</html>
