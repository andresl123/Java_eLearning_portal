<%-- 
    Document   : index
    Created on : Jun 8, 2025, 1:27:41 PM
    Updated on : Jun 25, 2025, 9:29 PM
    Author     : samit
    Description: Main landing page for the E-Learning Platform. Sets up the database, loads the top 3 rated courses, and includes a split banner with the navbar search.
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.elearningplatform.util.DBConnection" %>
<%@ page import="com.elearningplatform.util.MockDataLoader" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ include file="navbar.jsp" %> <!-- Pulling in that navbar with the search bar -->
<%
    // Get the database going and toss in some mock users when it first loads!
    DBConnection db = new DBConnection();
    MockDataLoader mockLoader = new MockDataLoader(db);
    try {
        mockLoader.insertMockUsers(); // Adds some admins, students, and tutors to the database!
        mockLoader.insertMockCoursesAndEnrollments(); // Loads up courses, sections, and enrollments!
        //out.println("✅ Mock users inserted successfully!"); // Uncomment this if you want to see it in the browser
    } catch (Exception e) {
        System.out.println("Oops, the database hit a snag: " + e.getMessage()); // Just log it to the console
    } finally {
        db.closeResources(); // Clean up so we don’t leave things hanging
    }

    // Grab the top 3 courses based on ratings
    ResultSet courseRs = null;
    try {
        db.connect();
        String topCoursesQuery = "SELECT * FROM Course ORDER BY course_rating DESC LIMIT 3";
        courseRs = db.executeQuery(topCoursesQuery);
    } catch (SQLException e) {
        System.out.println("Uh oh, couldn’t grab the top courses: " + e.getMessage());
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>E-Learning Platform</title>
    
    <!-- Bootstrap CSS to make everything look good and responsive -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Bootstrap Icons to spice up the search bar -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    
    <!-- Our custom styles to give it some flair -->
    <link rel="stylesheet" href="css/styles.css">
    
    <!-- Toastr CSS for those nice pop-up messages -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.css" rel="stylesheet" />
    
    <!-- jQuery (needed for Toastr to work) -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    
    <!-- Toastr JS to handle the pop-up action -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js"></script>
    
    <!-- Our custom JS, keeping it easygoing -->
    <script src="js/scripts.js"></script>
    
    <!-- Bootstrap JS for the navbar and other goodies -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
    <!-- Header with a split banner: text on the left, image on the right, purple background -->
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

    <!-- Main section with the top 3 courses by rating -->
    <section class="container my-5">
        <h2 class="text-center mb-4">Featured Courses</h2>
        <div class="row row-cols-1 row-cols-md-3 g-4">
            <%
                if (courseRs != null) {
                    while (courseRs.next() && courseRs.getRow() <= 3) {
                        String courseName = courseRs.getString("course_name");
                        String courseCategory = courseRs.getString("course_category");
                        int courseRating = courseRs.getInt("course_rating");
                        String courseImage = courseRs.getString("course_image");
                        int courseId = courseRs.getInt("course_id");
            %>
            <!-- Dynamic course card, keeping that cool style you liked -->
            <div class="col">
                <div class="card h-100">
                    <img src="<%= courseImage != null ? courseImage : "https://img.freepik.com/premium-psd/school-education-admission-youtube-thumbnail-web-banner-template_475351-410.jpg" %>" class="card-img-top" alt="<%= courseName %>">
                    <div class="card-body">
                        <h5 class="card-title"><%= courseName %></h5>
                        <p class="card-text">Learn the essentials of <%= courseCategory %>.</p>
                        <p class="card-text"><strong>Category:</strong> <%= courseCategory %></p>
                        <a href="courseStudent.jsp?courseId=<%= courseId %>" class="btn btn-primary">View Details</a>
                    </div>
                </div>
            </div>
            <%
                    }
                } else {
                    out.println("<p class='text-danger'>Oops, couldn’t load the courses. Try again later!</p>");
                }
            %>
        </div>
    </section>

    <!-- Footer with some basic legal links -->
    <footer class="bg-dark text-white text-center py-3 mt-5">
        <p>© 2025 E-Learning Platform | <a href="#" class="text-white">About Us</a> | <a href="#" class="text-white">Contact</a></p>
    </footer>

    <%
        if (courseRs != null) {
            courseRs.close();
        }
        db.closeResources(); // Wrap up the database connection
    %>
</body>
</html>