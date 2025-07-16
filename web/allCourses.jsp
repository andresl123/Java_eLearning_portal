<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.elearningplatform.util.DBConnection" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>All Courses</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/styles.css">
    <link rel="stylesheet" href="css/allCourses.css">
</head>
<body>
    <%@ include file="navbar.jsp" %>
    <div class="container mt-5">
        <h1 class="text-center mb-4 display-4 text-primary">Explore All Courses</h1>
        
        <!-- Filters -->
        <div class="filters mb-4 p-3 bg-light rounded shadow-sm">
            <div class="row">
                <div class="col-md-4">
                    <label for="categoryFilter" class="form-label">Category</label>
                    <select id="categoryFilter" class="form-select" onchange="filterCourses()">
                        <option value="">All Categories</option>
                        <option value="Programming">Programming</option>
                        <option value="Web Development">Web Development</option>
                        <option value="Computer Science">Computer Science</option>
                        <option value="Cloud Computing">Cloud Computing</option>
                        <option value="Project Management">Project Management</option>
                    </select>
                </div>
                <div class="col-md-4">
                    <label for="priceFilter" class="form-label">Price Range</label>
                    <select id="priceFilter" class="form-select" onchange="filterCourses()">
                        <option value="">All Prices</option>
                        <option value="0-100">Under $100</option>
                        <option value="100-150">$100 - $150</option>
                        <option value="150+">Over $150</option>
                    </select>
                </div>
                <div class="col-md-4">
                    <label for="ratingFilter" class="form-label">Rating</label>
                    <select id="ratingFilter" class="form-select" onchange="filterCourses()">
                        <option value="">All Ratings</option>
                        <option value="4">4 Stars & Up</option>
                        <option value="5">5 Stars Only</option>
                    </select>
                </div>
            </div>
        </div>

        <!-- Courses Grid -->
        <div class="row course-grid" id="courseGrid">
            <%
                DBConnection db = new DBConnection();
                try {
                    db.connect();
                    ResultSet rs = db.executeQuery("SELECT course_id, course_name, course_price, course_category, course_rating, course_image FROM Course WHERE course_status = 'Active'");
                    while (rs.next()) {
                        int courseId = rs.getInt("course_id");
                        String courseName = rs.getString("course_name");
                        int coursePrice = rs.getInt("course_price");
                        String courseCategory = rs.getString("course_category");
                        int courseRating = rs.getInt("course_rating");
                        String courseImage = rs.getString("course_image");
            %>
            <div class="col-md-4 mb-4 course-card" data-category="<%= courseCategory %>" data-price="<%= coursePrice %>" data-rating="<%= courseRating %>">
                <div class="card h-100 shadow-sm">
                    <img src="<%= courseImage != null ? courseImage : "https://via.placeholder.com/300x200" %>" class="card-img-top" alt="<%= courseName %>">
                    <div class="card-body">
                        <h5 class="card-title"><%= courseName %></h5>
                        <p class="card-text">Category: <%= courseCategory %></p>
                        <p class="card-text">Price: $<%= coursePrice %></p>
                        <p class="card-text">Rating: <%= courseRating %>/5 <span class="text-warning">★</span></p>
                        <%-- this should send the id of the course to course details page --%>
                        <a href="courseDetailsStudent.jsp?courseId=<%= courseId %>" class="btn btn-primary mt-auto">View Details</a>
                    </div>
                </div>
            </div>
            <%
                    }
                    db.closeResources();
                } catch (SQLException e) {
                    out.println("<p class='text-danger'>Error fetching courses: " + e.getMessage() + "</p>");
                }
            %>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function filterCourses() {
            const category = document.getElementById('categoryFilter').value;
            const price = document.getElementById('priceFilter').value;
            const rating = document.getElementById('ratingFilter').value;

            const cards = document.querySelectorAll('.course-card');
            cards.forEach(card => {
                const cardCategory = card.getAttribute('data-category');
                const cardPrice = parseInt(card.getAttribute('data-price'));
                const cardRating = parseInt(card.getAttribute('data-rating'));

                let show = true;

                if (category && cardCategory !== category) show = false;
                if (price) {
                    const [min, max] = price.split('-').map(Number);
                    if (max) {
                        show = cardPrice >= min && cardPrice <= max;
                    } else if (min) {
                        show = cardPrice > min;
                    }
                }
                if (rating) {
                    show = cardRating >= parseInt(rating);
                }

                card.style.display = show ? 'block' : 'none';
            });
        }
    </script>
</body>
</html>