<%-- 
    Document   : index
    Created on : Jun 8, 2025, 1:27:41 PM
    Updated on : Jun 25, 2025, 9:29 PM
    Author     : samit
    Description: Landing page for E-Learning Platform, sets up DB, shows hardcoded courses, with a split banner and navbar search.
--%>



<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.elearningplatform.util.DBConnection" %>
<%@ include file="navbar.jsp" %> <!-- Grab that navbar with search -->
<%
    // Fire up the DB and drop in those mock users on first load!
    DBConnection db = new DBConnection();
    try {
        db.insertMockUsers(); // Populates elearning_db with admins, students, and tutors!
        db.insertMockCoursesAndEnrollments(); // Populates courses, sections, and enrollments!
        //out.println("✅ Mock users inserted successfully!"); // Uncomment for browser debug
    } catch (Exception e) {
        System.out.println("Yikes, DB threw an error: " + e.getMessage()); // Log to console
    } finally {
        db.closeResources(); // Clean up, don't leave a mess!
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>E-Learning Platform</title>
    
    <!-- Bootstrap CSS for that responsive goodness -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Bootstrap Icons just to test the search bar -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    
    <!-- Our custom styles to make it pop -->
    <link rel="stylesheet" href="css/styles.css">
    
    <!-- Toastr CSS for those sweet notifications -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.css" rel="stylesheet" />
    
    <!-- jQuery (Toastr needs it) -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    
    <!-- Toastr JS for pop-up action -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js"></script>
    
    <!-- Our custom JS, keeping it chill -->
    <script src="js/scripts.js"></script>
    
    <!-- Bootstrap JS for navbar and more -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
    <!-- Header with split banner: text left, image right, purple background -->
    <header class="py-5" style="background-color: #6f42c1; color: white;">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-6">
                    <h1>Welcome to E-Learning Platform</h1>
                    <p class="lead">Get started with your online learning journey today! Explore courses, register, or log in to begin.</p>
                    <a href="createAccount.jsp" class="btn btn-light mt-3">Get Started</a>
                </div>
                <div class="col-md-6">
                    <img src="https://i.imgur.com/wRM8o64.jpeg" alt="E-Learning Banner" class="img-fluid rounded">
                </div>
            </div>
        </div>
    </header>

    <!-- Main section with hardcoded courses -->
    <section class="container my-5">
        <h2 class="text-center mb-4">Featured Courses</h2>
        <div class="row row-cols-1 row-cols-md-3 g-4">
            <!-- Course 1 - Hardcoded for now -->
            <div class="col">
                <div class="card h-100">
                    <img src="https://img.freepik.com/premium-psd/school-education-admission-youtube-thumbnail-web-banner-template_475351-410.jpg" class="card-img-top" alt="Introduction to Java">
                    <div class="card-body">
                        <h5 class="card-title">Introduction to Java</h5>
                        <p class="card-text">Learn the basics of Java programming.</p>
                        <p class="card-text"><strong>Category:</strong> Programming</p>
                        <a href="#" class="btn btn-primary">View Details</a>
                    </div>
                </div>
            </div>
            <!-- Course 2 - Hardcoded for now -->
            <div class="col">
                <div class="card h-100">
                    <img src="https://img.freepik.com/premium-psd/school-education-admission-youtube-thumbnail-web-banner-template_1060129-201.jpg" class="card-img-top" alt="Full Stack Development">
                    <div class="card-body">
                        <h5 class="card-title">Full Stack Development</h5>
                        <p class="card-text">Master full stack web development skills.</p>
                        <p class="card-text"><strong>Category:</strong> Web Development</p>
                        <a href="#" class="btn btn-primary">View Details</a>
                    </div>
                </div>
            </div>
            <!-- Course 3 - Hardcoded for now -->
            <div class="col">
                <div class="card h-100">
                    <img src="https://www.skillvertex.com/blog/wp-content/uploads/2023/04/data-science-thumbnail.png" class="card-img-top" alt="Cloud Computing">
                    <div class="card-body">
                        <h5 class="card-title">Cloud Computing</h5>
                        <p class="card-text">Explore the world of cloud technologies.</p>
                        <p class="card-text"><strong>Category:</strong> Cloud</p>
                        <a href="#" class="btn btn-primary">View Details</a>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer with some legal stuff -->
    <footer class="bg-dark text-white text-center py-3 mt-5">
        <h2>Welcome, <%= session.getAttribute("username") %></h2>
        <h2>with Role: <%= session.getAttribute("role") %></h2>
        <p>© 2025 E-Learning Platform | <a href="#" class="text-white">About Us</a> | <a href="#" class="text-white">Contact</a></p>
    </footer>
</body>
</html>