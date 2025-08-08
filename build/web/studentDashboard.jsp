<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.elearningplatform.util.DBConnection, java.sql.*" %>
<%@ include file="navbar.jsp" %>
<%
    // --- Access control: Only allow students (role == 2) to access this page ---
    Integer role = (Integer) session.getAttribute("role");
    Integer userId = (Integer) session.getAttribute("userId");
    String studentName = (String) session.getAttribute("username");
    if (role == null || userId == null || role != 2) {
        response.sendRedirect("index.jsp"); // Redirect non-students to homepage
        return;
    }

    // --- Query the database for this student's enrolled courses ---
    List<Map<String, Object>> enrolledCourses = new ArrayList<>();
    DBConnection db = new DBConnection();
    try {
        db.connect();
        ResultSet rs = db.getStudentEnrollments(userId);
        while (rs.next()) {
            Map<String, Object> course = new HashMap<>();
            course.put("enrollmentId", rs.getInt("enrollment_id"));
            course.put("courseId", rs.getInt("course_id"));
            course.put("courseName", rs.getString("course_name"));
            course.put("courseDesc", rs.getString("course_desc"));
            course.put("courseImage", rs.getString("course_image"));
            course.put("coursePrice", rs.getInt("course_price"));
            course.put("progressPercentage", rs.getInt("progress_percentage"));
            course.put("completionStatus", rs.getString("completion_status"));
            course.put("enrollmentDate", rs.getTimestamp("enrollment_date"));
            course.put("lastAccessed", rs.getTimestamp("last_accessed"));
            enrolledCourses.add(course);
        }
        db.closeResources();
    } catch (SQLException e) {
        System.out.println("Error fetching enrolled courses: " + e.getMessage());
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Student Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link rel="stylesheet" href="css/studentDashboard.css">
    <link rel="stylesheet" href="css/styles.css">
    <style>
        .course-card {
            transition: transform 0.2s ease-in-out;
        }
        .course-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
        }
        .progress-bar {
            height: 8px;
            border-radius: 4px;
        }
        .status-badge {
            font-size: 0.8rem;
        }
        .welcome-section {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 15px;
            padding: 2rem;
            margin-bottom: 2rem;
        }
        .stats-card {
            background: white;
            border-radius: 10px;
            padding: 1.5rem;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            text-align: center;
        }
        .stats-number {
            font-size: 2.5rem;
            font-weight: bold;
            color: #667eea;
        }
    </style>
</head>
<body class="bg-light">
    <div class="container mt-4">
        <!-- Welcome Section -->
        <div class="welcome-section">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <h1 class="display-5 mb-3">Welcome back, <%= studentName != null ? studentName : "Student" %>!</h1>
                    <p class="lead mb-0">Continue your learning journey and track your progress across all enrolled courses.</p>
                </div>
                <div class="col-md-4 text-end">
                    <i class="bi bi-mortarboard-fill" style="font-size: 4rem; opacity: 0.8;"></i>
                </div>
            </div>
        </div>

        <!-- Statistics Cards -->
        <div class="row mb-4">
            <div class="col-md-3">
                <div class="stats-card">
                    <i class="bi bi-book-fill text-primary mb-2" style="font-size: 2rem;"></i>
                    <div class="stats-number"><%= enrolledCourses.size() %></div>
                    <p class="text-muted mb-0">Enrolled Courses</p>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stats-card">
                    <i class="bi bi-check-circle-fill text-success mb-2" style="font-size: 2rem;"></i>
                    <div class="stats-number">
                        <% 
                            long completedCount = enrolledCourses.stream()
                                .filter(course -> "Completed".equals(course.get("completionStatus")))
                                .count();
                        %>
                        <%= completedCount %>
                    </div>
                    <p class="text-muted mb-0">Completed</p>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stats-card">
                    <i class="bi bi-clock-fill text-warning mb-2" style="font-size: 2rem;"></i>
                    <div class="stats-number">
                        <% 
                            long inProgressCount = enrolledCourses.stream()
                                .filter(course -> "In Progress".equals(course.get("completionStatus")))
                                .count();
                        %>
                        <%= inProgressCount %>
                    </div>
                    <p class="text-muted mb-0">In Progress</p>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stats-card">
                    <i class="bi bi-graph-up text-info mb-2" style="font-size: 2rem;"></i>
                    <div class="stats-number">
                        <% 
                            double avgProgress = enrolledCourses.isEmpty() ? 0 : 
                                enrolledCourses.stream()
                                    .mapToInt(course -> (Integer) course.get("progressPercentage"))
                                    .average()
                                    .orElse(0.0);
                        %>
                        <%= Math.round(avgProgress) %>%
                    </div>
                    <p class="text-muted mb-0">Avg Progress</p>
                </div>
            </div>
        </div>

        <!-- Enrolled Courses Section -->
        <div class="row">
            <div class="col-12">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h2 class="mb-0">My Enrolled Courses</h2>
                    <a href="allCourses.jsp" class="btn btn-primary">
                        <i class="bi bi-plus-circle me-2"></i>Browse More Courses
                    </a>
                </div>
            </div>
        </div>

        <% if (enrolledCourses.isEmpty()) { %>
            <div class="row">
                <div class="col-12">
                    <div class="card text-center py-5">
                        <div class="card-body">
                            <i class="bi bi-book text-muted mb-3" style="font-size: 4rem;"></i>
                            <h4 class="text-muted">No courses enrolled yet</h4>
                            <p class="text-muted">Start your learning journey by exploring our course catalog.</p>
                            <a href="allCourses.jsp" class="btn btn-primary">
                                <i class="bi bi-search me-2"></i>Explore Courses
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        <% } else { %>
            <div class="row">
                <% for (Map<String, Object> course : enrolledCourses) { 
                    String status = (String) course.get("completionStatus");
                    int progress = (Integer) course.get("progressPercentage");
                    String statusClass = "Completed".equals(status) ? "success" : 
                                       "In Progress".equals(status) ? "warning" : "secondary";
                %>
                <div class="col-md-6 col-lg-4 mb-4">
                    <div class="card h-100 course-card">
                        <img src="<%= course.get("courseImage") != null ? course.get("courseImage") : "https://via.placeholder.com/300x200" %>" 
                             class="card-img-top" alt="<%= course.get("courseName") %>" style="height: 200px; object-fit: cover;">
                        <div class="card-body d-flex flex-column">
                            <h5 class="card-title"><%= course.get("courseName") %></h5>
                            <p class="card-text text-muted">
                                <%= course.get("courseDesc") != null ? 
                                    ((String) course.get("courseDesc")).length() > 100 ? 
                                    ((String) course.get("courseDesc")).substring(0, 100) + "..." : 
                                    course.get("courseDesc") : "No description available" %>
                            </p>
                            
                            <!-- Progress Section -->
                            <div class="mb-3">
                                <div class="d-flex justify-content-between align-items-center mb-2">
                                    <small class="text-muted">Progress</small>
                                    <small class="text-muted"><%= progress %>%</small>
                                </div>
                                <div class="progress progress-bar">
                                    <div class="progress-bar bg-<%= statusClass %>" 
                                         role="progressbar" 
                                         style="width: <%= progress %>%" 
                                         aria-valuenow="<%= progress %>" 
                                         aria-valuemin="0" 
                                         aria-valuemax="100"></div>
                                </div>
                            </div>
                            
                            <!-- Status and Actions -->
                            <div class="mt-auto">
                                <div class="d-flex justify-content-between align-items-center mb-3">
                                    <span class="badge bg-<%= statusClass %> status-badge">
                                        <i class="bi bi-<%= "Completed".equals(status) ? "check-circle" : "clock" %> me-1"></i>
                                        <%= status %>
                                    </span>
                                    <small class="text-muted">
                                        Enrolled: <%= course.get("enrollmentDate") != null ? 
                                            ((Timestamp) course.get("enrollmentDate")).toLocalDateTime().toLocalDate() : "N/A" %>
                                    </small>
                                </div>
                                
                                                        <div class="d-grid gap-2">
                            <a href="courseDetailsStudent.jsp?courseId=<%= course.get("courseId") %>"
                               class="btn btn-primary btn-sm">
                                <i class="bi bi-play-circle me-2"></i>Continue Learning
                            </a>
                            <button class="btn btn-outline-secondary btn-sm"
                                    onclick="showCourseDetails(<%= course.get("courseId") %>)">
                                <i class="bi bi-info-circle me-2"></i>Course Details
                            </button>
                        </div>
                            </div>
                        </div>
                    </div>
                </div>
                <% } %>
            </div>
        <% } %>
    </div>

    <!-- Course Details Modal -->
    <div class="modal fade" id="courseDetailsModal" tabindex="-1" aria-labelledby="courseDetailsModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="courseDetailsModalLabel">Course Details</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body" id="courseDetailsContent">
                    <!-- Content will be loaded here -->
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="js/studentDashboard.js"></script>
    <script>
        function showCourseDetails(courseId) {
            const modal = document.getElementById('courseDetailsModal');
            const content = document.getElementById('courseDetailsContent');
            
            // Show loading state
            content.innerHTML = `
                <div class="text-center py-4">
                    <div class="spinner-border text-primary" role="status">
                        <span class="visually-hidden">Loading...</span>
                    </div>
                    <p class="mt-2 text-muted">Loading course details...</p>
                </div>
            `;
            
            // Show modal
            const bootstrapModal = new bootstrap.Modal(modal);
            bootstrapModal.show();
            
            // Load course details via AJAX
            fetch('courseDetailsStudent.jsp?courseId=' + courseId)
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Network response was not ok');
                    }
                    return response.text();
                })
                .then(html => {
                    // Extract only the content from the course details page
                    const parser = new DOMParser();
                    const doc = parser.parseFromString(html, 'text/html');
                    const courseContent = doc.querySelector('.course-details-container');
                    
                    if (courseContent) {
                        content.innerHTML = courseContent.innerHTML;
                    } else {
                        content.innerHTML = `
                            <div class="text-center text-muted py-4">
                                <i class="bi bi-exclamation-triangle" style="font-size: 3rem;"></i>
                                <h5 class="mt-3">Course Details Not Found</h5>
                                <p>Unable to load course information. Please try again later.</p>
                            </div>
                        `;
                    }
                })
                .catch(error => {
                    console.error('Error loading course details:', error);
                    content.innerHTML = `
                        <div class="text-center text-muted py-4">
                            <i class="bi bi-exclamation-triangle" style="font-size: 3rem;"></i>
                            <h5 class="mt-3">Error Loading Course Details</h5>
                            <p>Unable to load course information. Please try again later.</p>
                            <button class="btn btn-primary" onclick="showCourseDetails(' + courseId + ')">
                                <i class="bi bi-arrow-clockwise me-2"></i>Retry
                            </button>
                        </div>
                    `;
                });
        }
    </script>
</body>
</html> 