<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.HashSet" %>
<%@ page import="java.util.Set" %>
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
                @SuppressWarnings("unchecked")
                List<String[]> results = (List<String[]>) request.getAttribute("searchResults");
                String searchQuery = (String) request.getAttribute("searchQuery");
                DBConnection db = new DBConnection();
                ResultSet rs = null;
                Set<String> displayedCourses = new HashSet<>(); // Track unique course names

                if (results != null && !results.isEmpty()) {
                    // Display search results, showing each course name only once
                    for (String[] course : results) {
                        String courseName = course[1];
                        if (!displayedCourses.contains(courseName)) {
                            // Only display the first instance of a course name
                            displayedCourses.add(courseName);
                            int courseId = Integer.parseInt(course[0]);
                            int coursePrice = Integer.parseInt(course[2]);
                            String courseCategory = course[3];
                            int courseRating = Integer.parseInt(course[4]);
                            String courseImage = course[5];
            %>
            <div class="col-md-4 mb-4 course-card" data-category="<%= courseCategory %>" data-price="<%= coursePrice %>" data-rating="<%= courseRating %>">
                <div class="card h-100 shadow-sm">
                    <img src="<%= courseImage != null ? courseImage : "https://via.placeholder.com/300x200" %>" class="card-img-top" alt="<%= courseName %>">
                    <div class="card-body">
                        <h5 class="card-title"><%= courseName %></h5>
                        <p class="card-text">Category: <%= courseCategory %></p>
                        <p class="card-text">Price: $<%= coursePrice %></p>
                        <p class="card-text">Rating: <%= courseRating %>/5 <span class="text-warning">★</span></p>
                        <a href="courseStudent.jsp?courseId=<%= courseId %>" class="btn btn-primary mt-auto">View Details</a>
                    </div>
                </div>
            </div>
            <%
                        }
                    }
                } else {
                    // Fall back to all courses if no search or no results, showing each course name only once
                    try {
                        db.connect();
                        String sql = "SELECT course_id, course_name, course_price, course_category, course_rating, course_image FROM Course WHERE course_status = 'Active'";
                        rs = db.executeQuery(sql);
                        while (rs.next()) {
                            String courseName = rs.getString("course_name");
                            if (!displayedCourses.contains(courseName)) {
                                // Only display the first instance of a course name
                                displayedCourses.add(courseName);
                                int courseId = rs.getInt("course_id");
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
                        <a href="courseStudent.jsp?courseId=<%= courseId %>" class="btn btn-primary mt-auto">View Details</a>
                    </div>
                </div>
            </div>
            <%
                            }
                        }
                    } catch (SQLException e) {
                        out.println("<p class='text-danger'>Error fetching courses: " + e.getMessage() + "</p>");
                    } finally {
                        if (rs != null) rs.close();
                        db.closeResources();
                    }
                }
            %>
        </div>
        <% if (searchQuery != null && !searchQuery.trim().isEmpty() && (results == null || results.isEmpty())) { %>
            <p class="text-center text-warning">No courses found for "<%= searchQuery %>".</p>
        <% } %>
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