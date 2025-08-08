
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.elearningplatform.util.DBConnection, java.sql.*" %>
<%@ include file="navbar.jsp" %>
<%
    Integer courseId = null;
    Integer userId = (Integer) session.getAttribute("userId");
    Map<String, Object> courseInfo = new HashMap<>();
    List<Map<String, Object>> sections = new ArrayList<>();
    Map<String, Object> enrollmentInfo = new HashMap<>();
    
    try {
        courseId = Integer.parseInt(request.getParameter("courseId"));
        
        DBConnection db = new DBConnection();
        db.connect();
        
        // Get course information
        ResultSet courseRs = db.getCourseById(courseId);
        if (courseRs.next()) {
            courseInfo.put("courseId", courseRs.getInt("course_id"));
            courseInfo.put("courseName", courseRs.getString("course_name"));
            courseInfo.put("courseDesc", courseRs.getString("course_desc"));
            courseInfo.put("courseImage", courseRs.getString("course_image"));
            courseInfo.put("coursePrice", courseRs.getInt("course_price"));
            courseInfo.put("courseCategory", courseRs.getString("course_category"));
            courseInfo.put("courseRating", courseRs.getInt("course_rating"));
            courseInfo.put("courseStatus", courseRs.getString("course_status"));
        }
        
        // Get course sections
        ResultSet sectionsRs = db.getCourseDetailsByCourseId(courseId);
        while (sectionsRs.next()) {
            Map<String, Object> section = new HashMap<>();
            section.put("sectionId", sectionsRs.getInt("section_id"));
            section.put("sectionTitle", sectionsRs.getString("section_title"));
            section.put("sectionDuration", sectionsRs.getInt("section_duration"));
            section.put("sectionDesc", sectionsRs.getString("section_desc"));
            section.put("sectionVideoUrl", sectionsRs.getString("section_video_url"));
            sections.add(section);
        }
        
        // Get enrollment information if user is enrolled
        if (userId != null) {
            boolean isEnrolled = db.isStudentEnrolled(userId, courseId);
            if (isEnrolled) {
                String query = "SELECT * FROM Enrollment WHERE user_id = ? AND course_id = ?";
                PreparedStatement pstmt = db.getConn().prepareStatement(query);
                pstmt.setInt(1, userId);
                pstmt.setInt(2, courseId);
                ResultSet enrollmentRs = pstmt.executeQuery();
                if (enrollmentRs.next()) {
                    enrollmentInfo.put("enrollmentId", enrollmentRs.getInt("enrollment_id"));
                    enrollmentInfo.put("progressPercentage", enrollmentRs.getInt("progress_percentage"));
                    enrollmentInfo.put("completionStatus", enrollmentRs.getString("completion_status"));
                    enrollmentInfo.put("enrollmentDate", enrollmentRs.getTimestamp("enrollment_date"));
                    enrollmentInfo.put("lastAccessed", enrollmentRs.getTimestamp("last_accessed"));
                }
                
                // Get section completion status for this user and course
                Map<Integer, Boolean> sectionCompletion = new HashMap<>();
                ResultSet sectionProgressRs = db.getSectionProgressForCourse(userId, courseId);
                while (sectionProgressRs.next()) {
                    int sectionId = sectionProgressRs.getInt("section_id");
                    boolean isCompleted = sectionProgressRs.getBoolean("is_completed");
                    sectionCompletion.put(sectionId, isCompleted);
                }
                request.setAttribute("sectionCompletion", sectionCompletion);
            }
        }
        
        db.closeResources();
    } catch (Exception e) {
        System.out.println("Error loading course details: " + e.getMessage());
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Course Details</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link rel="stylesheet" href="css/styles.css">
    <!-- Custom CSS -->
    
    <link rel="stylesheet" href="css/courseDetails.css">
</head>
<body>

<div class="course-details-container">
    <% if (!courseInfo.isEmpty()) { %>
        <!-- Course Header -->
        <div class="course-header">
            <div class="row">
                <div class="col-md-4">
                    <img src="<%= courseInfo.get("courseImage") != null ? courseInfo.get("courseImage") : "https://via.placeholder.com/400x250" %>" 
                         class="img-fluid rounded course-image" alt="<%= courseInfo.get("courseName") %>">
                </div>
                <div class="col-md-8">
                    <h3 class="course-title"><%= courseInfo.get("courseName") %></h3>
                    <p class="course-description"><%= courseInfo.get("courseDesc") %></p>
                    
                    <!-- Course Stats -->
                    <div class="course-stats">
                        <div class="row">
                            <div class="col-md-3">
                                <div class="stat-item">
                                    <div class="stat-label">Category</div>
                                    <div class="stat-value"><%= courseInfo.get("courseCategory") %></div>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="stat-item">
                                    <div class="stat-label">Rating</div>
                                    <div class="stat-value">
                                        <%= courseInfo.get("courseRating") %>/5 
                                        <span class="rating-stars">★</span>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="stat-item">
                                    <div class="stat-label">Price</div>
                                    <div class="stat-value price-highlight">$<%= courseInfo.get("coursePrice") %></div>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="stat-item">
                                    <div class="stat-label">Sections</div>
                                    <div class="stat-value"><%= sections.size() %></div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Progress Section (if enrolled) -->
                    <% if (!enrollmentInfo.isEmpty()) { %>
                        <div class="progress-section">
                            <h6 class="progress-title">Your Progress</h6>
                            <div class="row align-items-center">
                                <div class="col-md-6">
                                    <div class="d-flex justify-content-between align-items-center mb-2">
                                        <small class="text-muted">Progress</small>
                                        <small class="text-muted progress-percentage"><%= enrollmentInfo.get("progressPercentage") %>%</small>
                                    </div>
                                    <div class="progress-bar-custom">
                                        <div class="progress-fill" 
                                             style="width: <%= enrollmentInfo.get("progressPercentage") %>%"></div>
                                    </div>
                                </div>
                                <div class="col-md-6 text-end">
                                    <span class="status-badge bg-<%= "Completed".equals(enrollmentInfo.get("completionStatus")) ? "success" : "warning" %>">
                                        <%= enrollmentInfo.get("completionStatus") %>
                                    </span>
                                    <br>
                                    <small class="text-muted">
                                        Enrolled: <%= enrollmentInfo.get("enrollmentDate") != null ? 
                                            ((Timestamp) enrollmentInfo.get("enrollmentDate")).toLocalDateTime().toLocalDate() : "N/A" %>
                                    </small>
                                </div>
                            </div>
                        </div>
                    <% } %>
                </div>
            </div>
        </div>
        
        <!-- Course Sections -->
        <div class="sections-container">
            <h5 class="sections-title">Course Content (<%= sections.size() %> sections)</h5>
            
            <% if (sections.isEmpty()) { %>
                <div class="empty-state">
                    <i class="bi bi-book"></i>
                    <h5>No sections available yet.</h5>
                    <p>Course content will be added soon.</p>
                </div>
            <% } else { %>
                <div class="accordion" id="sectionsAccordion">
                    <% for (int i = 0; i < sections.size(); i++) { 
                        Map<String, Object> section = sections.get(i);
                    %>
                    <div class="accordion-item">
                        <h2 class="accordion-header" id="heading<%= i %>">
                            <button class="accordion-button <%= i > 0 ? "collapsed" : "" %>" 
                                    type="button" 
                                    data-bs-toggle="collapse" 
                                    data-bs-target="#collapse<%= i %>" 
                                    aria-expanded="<%= i == 0 ? "true" : "false" %>" 
                                    aria-controls="collapse<%= i %>">
                                <div class="d-flex justify-content-between align-items-center w-100 me-3">
                                    <span><%= section.get("sectionTitle") %></span>
                                    <small class="text-muted"><%= section.get("sectionDuration") %> min</small>
                                </div>
                            </button>
                        </h2>
                        <div id="collapse<%= i %>" 
                             class="accordion-collapse collapse <%= i == 0 ? "show" : "" %>" 
                             aria-labelledby="heading<%= i %>" 
                             data-bs-parent="#sectionsAccordion">
                            <div class="accordion-body">
                                <p class="text-muted mb-3"><%= section.get("sectionDesc") %></p>
                                
                                <%
                                    String videoUrl = (String) section.get("sectionVideoUrl");
                                    if (videoUrl != null && !videoUrl.trim().isEmpty()) {
                                        String embedUrl = null;

                                        // Check if it's a YouTube long URL
                                        if (videoUrl.contains("youtube.com/watch?v=")) {
                                            String videoId = videoUrl.substring(videoUrl.indexOf("v=") + 2);
                                            int ampIndex = videoId.indexOf("&");
                                            if (ampIndex != -1) {
                                                videoId = videoId.substring(0, ampIndex);
                                            }
                                            embedUrl = "https://www.youtube.com/embed/" + videoId;

                                            // Check if it's a YouTube short URL
                                        } else if (videoUrl.contains("youtu.be/")) {
                                            String videoId = videoUrl.substring(videoUrl.lastIndexOf("/") + 1);
                                            embedUrl = "https://www.youtube.com/embed/" + videoId;
                                        }
                                %>
                                <div class="ratio ratio-16x9 mb-3">
                                    <% if (embedUrl != null) {%>
                                    <iframe src="<%= embedUrl%>" 
                                            title="YouTube video player" frameborder="0"
                                            allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
                                            allowfullscreen>
                                    </iframe>
                                    <% } else {%>
                                    <video controls>
                                        <source src="<%= videoUrl%>" type="video/mp4">
                                        Your browser does not support the video tag.
                                    </video>
                                    <% } %>
                                </div>
                                <%
                                } else {
                                %>
                                <div class="alert alert-info">
                                    <i class="bi bi-info-circle me-2"></i>
                                    Video content will be available soon.
                                </div>
                                <% }%>
                                
                                <div class="d-flex justify-content-between align-items-center">
                                    <small class="text-muted">Section <%= i + 1 %> of <%= sections.size() %></small>
                                    <%
                                        Map<Integer, Boolean> sectionCompletion = (Map<Integer, Boolean>) request.getAttribute("sectionCompletion");
                                        boolean isCompleted = sectionCompletion != null && sectionCompletion.get((Integer) section.get("sectionId")) != null && sectionCompletion.get((Integer) section.get("sectionId"));
                                        String buttonClass = isCompleted ? "btn-success" : "btn-outline-primary";
                                        String buttonText = isCompleted ? "Completed" : "Mark Complete";
                                        String buttonIcon = isCompleted ? "bi-check-circle-fill" : "bi-check-circle";
                                        boolean isDisabled = isCompleted;
                                    %>
                                    <button class="btn btn-sm <%= buttonClass %>" 
                                            onclick="markSectionComplete(<%= section.get("sectionId") %>)"
                                            <%= isDisabled ? "disabled" : "" %>>
                                        <i class="bi <%= buttonIcon %> me-1"></i><%= buttonText %>
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                    <% } %>
                </div>
            <% } %>
        </div>
        
        <!-- Action Buttons -->
        <div class="action-buttons">
            <div class="d-flex gap-2 flex-wrap">
                <% if (enrollmentInfo.isEmpty()) { %>
                    <form action="EnrollServlet" method="post" class="d-inline">
                        <input type="hidden" name="courseId" value="<%= courseInfo.get("courseId") %>">
                        <input type="hidden" name="userId" value="<%= userId %>">
                        <button type="submit" class="btn btn-custom btn-primary-custom">
                            <i class="bi bi-plus-circle me-2"></i>Enroll in Course
                        </button>
                    </form>
                <% } %>
                <a href="allCourses.jsp" class="btn btn-custom btn-outline-custom">
                    <i class="bi bi-arrow-left me-2"></i>Back to Courses
                </a>
            </div>
        </div>
    <% } else { %>
        <div class="empty-state">
            <i class="bi bi-exclamation-triangle"></i>
            <h5>Course Not Found</h5>
            <p>The requested course could not be found or is no longer available.</p>
            <a href="allCourses.jsp" class="btn btn-custom btn-primary-custom">Browse Courses</a>
        </div>
    <% } %>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
// Mark section complete function
function markSectionComplete(sectionId) {
    const courseId = <%= courseInfo.get("courseId") %>;
    const button = event.target.closest('button');
    
    // Check if already completed
    if (button.classList.contains('btn-success')) {
        showToast('Section already completed!', 'info');
        return;
    }
    
    // Show loading state
    const originalText = button.innerHTML;
    button.innerHTML = '<span class="spinner-border spinner-border-sm me-1"></span>Updating...';
    button.disabled = true;
    
    // Make AJAX call to save progress
    fetch('SectionProgressServlet', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: new URLSearchParams({
            'action': 'complete',
            'courseId': courseId,
            'sectionId': sectionId
        })
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            // Update UI to show completion
            button.innerHTML = '<i class="bi bi-check-circle-fill me-1"></i>Completed';
            button.classList.remove('btn-outline-primary');
            button.classList.add('btn-success');
            button.disabled = true;
            
            // Update progress section with real data from server
            updateProgressSection(data.progressPercentage, data.completedSections, data.totalSections);
            
            // Add completion animation
            button.classList.add('progress-animation');
            setTimeout(() => {
                button.classList.remove('progress-animation');
            }, 500);
            
            showToast('Section marked as complete! Progress: ' + data.progressPercentage + '%', 'success');
        } else {
            // Revert button state on error
            button.innerHTML = originalText;
            button.disabled = false;
            showToast('Error: ' + data.message, 'error');
        }
    })
    .catch(error => {
        console.error('Error:', error);
        // Revert button state on error
        button.innerHTML = originalText;
        button.disabled = false;
        showToast('Network error occurred. Please try again.', 'error');
    });
}

// Update progress section function
function updateProgressSection(newProgress, completedSections, totalSections) {
    // Update progress percentage text
    const progressPercentage = document.querySelector('.progress-percentage');
    if (progressPercentage) {
        progressPercentage.textContent = newProgress + '%';
    }
    
    // Update progress bar
    const progressFill = document.querySelector('.progress-fill');
    if (progressFill) {
        progressFill.style.width = newProgress + '%';
        progressFill.setAttribute('aria-valuenow', newProgress);
    }
    
    // Update completion status if 100%
    if (newProgress >= 100) {
        const statusBadge = document.querySelector('.status-badge');
        if (statusBadge) {
            statusBadge.textContent = 'Completed';
            statusBadge.className = 'status-badge bg-success';
        }
    }
    
    // Add progress animation
    const progressSection = document.querySelector('.progress-section');
    if (progressSection) {
        progressSection.classList.add('progress-animation');
        setTimeout(() => {
            progressSection.classList.remove('progress-animation');
        }, 500);
    }
}



// Show toast notification
function showToast(message, type) {
    // Create toast container if it doesn't exist
    let toastContainer = document.querySelector('.toast-container');
    if (!toastContainer) {
        toastContainer = document.createElement('div');
        toastContainer.className = 'toast-container position-fixed top-0 end-0 p-3';
        toastContainer.style.zIndex = '1055';
        document.body.appendChild(toastContainer);
    }
    
    // Create toast element
    const toastElement = document.createElement('div');
    const bgClass = type === 'error' ? 'danger' : type;
    toastElement.className = 'toast align-items-center text-white bg-' + bgClass + ' border-0';
    toastElement.setAttribute('role', 'alert');
    toastElement.setAttribute('aria-live', 'assertive');
    toastElement.setAttribute('aria-atomic', 'true');
    
    toastElement.innerHTML = 
        '<div class="d-flex">' +
            '<div class="toast-body">' + message + '</div>' +
            '<button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>' +
        '</div>';
    
    toastContainer.appendChild(toastElement);
    
    // Show toast
    const toast = new bootstrap.Toast(toastElement);
    toast.show();
    
    // Remove toast element after it's hidden
    toastElement.addEventListener('hidden.bs.toast', function() {
        toastElement.remove();
    });
}

// Initialize page
document.addEventListener('DOMContentLoaded', function() {
    // Add form submission handler for enrollment
    const enrollForm = document.querySelector('form[action="EnrollServlet"]');
    if (enrollForm) {
        enrollForm.addEventListener('submit', function(e) {
            const button = this.querySelector('button[type="submit"]');
            button.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>Enrolling...';
            button.disabled = true;
        });
    }
    
    // Load section progress on page load (for enrolled users)
    <% if (!enrollmentInfo.isEmpty()) { %>
    loadSectionProgress();
    <% } %>
});

// Load section progress from server
function loadSectionProgress() {
    const courseId = <%= courseInfo.get("courseId") %>;
    
    fetch(`SectionProgressServlet?courseId=${courseId}`)
    .then(response => response.json())
    .then(data => {
        if (data.success && data.sections) {
            // Update UI based on loaded progress
            Object.keys(data.sections).forEach(sectionId => {
                const isCompleted = data.sections[sectionId];
                const button = document.querySelector(`button[onclick*="${sectionId}"]`);
                if (button) {
                    if (isCompleted) {
                        button.innerHTML = '<i class="bi bi-check-circle-fill me-1"></i>Completed';
                        button.classList.remove('btn-outline-primary');
                        button.classList.add('btn-success');
                        button.disabled = true;
                    }
                }
            });
        }
    })
    .catch(error => {
        console.error('Error loading section progress:', error);
    });
}
</script>

</body>
</html>