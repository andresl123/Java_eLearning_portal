<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.elearningplatform.util.DBConnection" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Course Details for Students</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/courseDetails.css">
</head>
<body>
    <%@ include file="navbar.jsp" %>
    <div class="container mt-5">
        <%
            String message = request.getParameter("message");
            String error = request.getParameter("error");
            if (message != null) {
                out.println("<p class='text-success'>" + message + "</p>");
            } else if (error != null) {
                out.println("<p class='text-danger'>Error: " + error + "</p>");
            }
        %>
        <%
            String courseIdStr = request.getParameter("courseId");
            if (courseIdStr == null || courseIdStr.trim().isEmpty()) {
                out.println("<p class='text-danger'>No course selected. Please try again.</p>");
            } else {
                int courseId = 0;
                try {
                    courseId = Integer.parseInt(courseIdStr);
                } catch (NumberFormatException e) {
                    out.println("<p class='text-danger'>Invalid course ID. Please try again.</p>");
                    return; // Exit early to avoid further processing
                }

                DBConnection db = new DBConnection();
                ResultSet courseRs = null;
                ResultSet sectionsRs = null;
                try {
                    db.connect();
                    // Use executeQuery method with parameterized query
                    String courseQuery = "SELECT * FROM Course WHERE course_id = ?";
                    courseRs = db.executeQuery(courseQuery.replace("?", Integer.toString(courseId)));

                    if (courseRs.next()) {
                        String courseName = courseRs.getString("course_name");
                        int coursePrice = courseRs.getInt("course_price");
                        String courseCategory = courseRs.getString("course_category");
                        int courseRating = courseRs.getInt("course_rating");
                        String courseDesc = courseRs.getString("course_desc");
                        String courseImage = courseRs.getString("course_image");
                        Integer userId = (Integer) session.getAttribute("userId"); // Assume from session
        %>
        <!-- Hero Section -->
        <div class="course-hero bg-light p-4 rounded shadow-sm mb-4">
            <div class="row">
                <div class="col-md-4">
                    <img src="<%= courseImage != null ? courseImage : "https://via.placeholder.com/300x200" %>" alt="<%= courseName %>" class="img-fluid rounded">
                </div>
                <div class="col-md-8">
                    <h1 class="display-5"><%= courseName %></h1>
                    <p class="text-muted">Category: <%= courseCategory %></p>
                    <p class="h3 text-success">Price: $<%= coursePrice %></p>
                    <p class="h5">Rating: <%= courseRating %>/5 <span class="text-warning">★</span></p>
                                <!-- ✅ Enroll Button Form -->
            <form action="EnrollServlet" method="post" class="mt-3">
                <input type="hidden" name="courseId" value="<%= courseId %>">
                <% 
                    if (userId != null) {
                %>
                    <input type="hidden" name="userId" value="<%= userId %>">
                    <button type="submit" class="btn btn-success">Enroll in this Course</button>
                <% } else { %>
                    <p class="text-warning mt-2">Please <a href="login.jsp">log in</a> to enroll in this course.</p>
                <% } %>
            </form>
                </div>
            </div>
        </div>

        <!-- Course Overview -->
        <div class="course-overview p-4 bg-white rounded shadow-sm mb-4">
            <h2 class="mb-3">Course Overview</h2>
            <p><%= courseDesc %></p>
        </div>

        <!-- Sections Accordion -->
        <div class="accordion" id="sectionsAccordion">
            <%
                        // Fetch sections for the specific course
                        String sectionsQuery = "SELECT * FROM Course_details WHERE course_id = ?";
                        sectionsRs = db.executeQuery(sectionsQuery.replace("?", Integer.toString(courseId)));
                        int sectionIndex = 0;
                        while (sectionsRs.next()) {
                            String sectionTitle = sectionsRs.getString("section_title");
                            int sectionDuration = sectionsRs.getInt("section_duration");
                            String sectionDesc = sectionsRs.getString("section_desc");
                            String sectionVideoUrl = sectionsRs.getString("section_video_url");
            %>
            <div class="accordion-item">
                <h2 class="accordion-header" id="heading<%= sectionIndex %>">
                    <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapse<%= sectionIndex %>" aria-expanded="false" aria-controls="collapse<%= sectionIndex %>">
                        <%= sectionTitle %> (<%= sectionDuration %> mins)
                    </button>
                </h2>
                <div id="collapse<%= sectionIndex %>" class="accordion-collapse collapse" aria-labelledby="heading<%= sectionIndex %>" data-bs-parent="#sectionsAccordion">
                    <div class="accordion-body">
                        <p><%= sectionDesc %></p>
                        <a href="<%= sectionVideoUrl != null ? sectionVideoUrl : "#" %>" class="btn btn-info mt-2" target="_blank">Watch Video</a>
                    </div>
                </div>
            </div>
            <%
                            sectionIndex++;
                        }
                    }
                } catch (SQLException e) {
                    out.println("<p class='text-danger'>Error fetching course details: " + e.getMessage() + "</p>");
                } finally {
                    if (courseRs != null) courseRs.close();
                    if (sectionsRs != null) sectionsRs.close();
                    db.closeResources();
                }
            }
        %>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 