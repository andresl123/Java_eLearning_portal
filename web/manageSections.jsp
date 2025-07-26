<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.ResultSet, java.sql.SQLException, com.elearningplatform.util.DBConnection" %>
<%
    Integer courseId = null;
    Integer sectionId = null;
    boolean editMode = false;
    String sectionTitle = "";
    String sectionDuration = "";
    String sectionDesc = "";
    String sectionVideoUrl = "";
    String courseTitle = "";
    try {
        courseId = Integer.parseInt(request.getParameter("courseId"));
        // Fetch course title
        DBConnection db = new DBConnection();
        db.connect();
        ResultSet courseRs = db.getCourseById(courseId);
        if (courseRs.next()) {
            courseTitle = courseRs.getString("course_name");
        }
        courseRs.close();
        db.closeResources();
    } catch (Exception e) {
        courseId = null;
    }
    try {
        if (request.getParameter("editMode") != null && "1".equals(request.getParameter("editMode"))) {
            editMode = true;
            sectionId = Integer.parseInt(request.getParameter("sectionId"));
            // Fetch section details from DB
            DBConnection db = new DBConnection();
            db.connect();
            ResultSet editRs = db.executeQuery("SELECT * FROM Course_details WHERE section_id = " + sectionId);
            if (editRs.next()) {
                sectionTitle = editRs.getString("section_title");
                sectionDuration = String.valueOf(editRs.getInt("section_duration"));
                sectionDesc = editRs.getString("section_desc");
                sectionVideoUrl = editRs.getString("section_video_url");
            }
            editRs.close();
            db.closeResources();
        }
    } catch (Exception e) {
        // ignore, show blank form
    }
    String message = (String) request.getAttribute("message");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Sections</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <%@ include file="navbar.jsp" %>
    <div class="container mt-5">
        <h2 class="mb-4">Manage Sections for Course: <%= courseTitle %> (ID: <%= courseId != null ? courseId : "N/A" %>)</h2>
        <% if (message != null) { %>
            <div class="alert alert-info"><%= message %></div>
        <% } %>
        <% if (courseId != null) { %>
        <!-- Section creation/edit form -->
        <form action="SectionServlet" method="post" class="mb-4 p-4 border rounded">
            <input type="hidden" name="courseId" value="<%= courseId %>">
            <% if (editMode) { %>
                <input type="hidden" name="action" value="edit">
                <input type="hidden" name="sectionId" value="<%= sectionId %>">
            <% } else { %>
                <input type="hidden" name="action" value="add">
            <% } %>
            <div class="mb-3">
                <label class="form-label">Section Title</label>
                <input type="text" class="form-control" name="sectionTitle" value="<%= sectionTitle %>" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Duration (minutes)</label>
                <input type="number" class="form-control" name="duration" value="<%= sectionDuration %>" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Description</label>
                <textarea class="form-control" name="sectionDesc" rows="2"><%= sectionDesc %></textarea>
            </div>
            <div class="mb-3">
                <label class="form-label">Video URL</label>
                <input type="url" class="form-control" name="sectionVideoUrl" value="<%= sectionVideoUrl %>" placeholder="https://example.com/video.mp4">
                <small class="form-text text-muted">
                    Enter the direct URL to your video file (MP4, WebM, etc.) or streaming URL.<br>
                    Examples: https://example.com/video.mp4, https://youtube.com/watch?v=VIDEO_ID
                </small>
            </div>
            <button type="submit" class="btn btn-primary"><%= editMode ? "Update Section" : "Add Section" %></button>
            <% if (editMode) { %>
                <a href="manageSections.jsp?courseId=<%= courseId %>" class="btn btn-secondary ms-2">Cancel</a>
            <% } %>
        </form>
        <!-- Table of existing sections -->
        <h4>Sections for this Course</h4>
        <table class="table table-bordered">
            <thead>
                <tr>
                    <th>Section Title</th>
                    <th>Duration</th>
                    <th>Description</th>
                    <th>Video URL</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
            <%
                DBConnection db = new DBConnection();
                ResultSet rs = null;
                try {
                    db.connect();
                    rs = db.getCourseDetailsByCourseId(courseId);
                    while (rs.next()) {
                        int currentSectionId = rs.getInt("section_id");
            %>
                <tr>
                    <td><%= rs.getString("section_title") %></td>
                    <td><%= rs.getInt("section_duration") %> min</td>
                    <td><%= rs.getString("section_desc") %></td>
                    <td>
                        <% if (rs.getString("section_video_url") != null && !rs.getString("section_video_url").trim().isEmpty()) { %>
                            <button class="btn btn-sm btn-info preview-video-btn" data-video-url="<%= rs.getString("section_video_url") %>">Preview Video</button>
                        <% } else { %>
                            <span class="text-muted">No video</span>
                        <% } %>
                    </td>
                    <td>
                        <form action="manageSections.jsp" method="get" style="display:inline;">
                            <input type="hidden" name="courseId" value="<%= courseId %>">
                            <input type="hidden" name="sectionId" value="<%= currentSectionId %>">
                            <input type="hidden" name="editMode" value="1">
                            <button class="btn btn-sm btn-warning">Edit</button>
                        </form>
                        <form action="SectionServlet" method="post" style="display:inline;" onsubmit="return confirm('Are you sure you want to delete this section?');">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="courseId" value="<%= courseId %>">
                            <input type="hidden" name="sectionId" value="<%= currentSectionId %>">
                            <button class="btn btn-sm btn-danger">Delete</button>
                        </form>
                    </td>
                </tr>
            <%
                    }
                } catch (SQLException e) {
            %>
                <tr><td colspan="4" class="text-danger">Error loading sections: <%= e.getMessage() %></td></tr>
            <%
                } finally {
                    if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
                    db.closeResources();
                }
            %>
            </tbody>
        </table>
        <% } else { %>
            <div class="alert alert-danger">No course selected. Please return to the dashboard.</div>
        <% } %>
        <a href="tutorDashboard.jsp" class="btn btn-secondary mt-3">Back to Dashboard</a>
    </div>

    <!-- Video Preview Modal -->
    <div class="modal fade" id="videoPreviewModal" tabindex="-1" aria-labelledby="videoPreviewModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="videoPreviewModalLabel">Video Preview</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div id="videoContainer" style="width: 100%; height: 400px;"></div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Handle video preview buttons
            document.querySelectorAll('.preview-video-btn').forEach(function(button) {
                button.addEventListener('click', function() {
                    const videoUrl = this.getAttribute('data-video-url');
                    console.log('Video URL:', videoUrl); // Debug log
                    
                    const videoContainer = document.getElementById('videoContainer');
                    if (!videoContainer) {
                        console.error('Video container not found!');
                        return;
                    }
                    
                    videoContainer.innerHTML = '<video controls style="width: 100%; height: 100%;"><source src="' + videoUrl + '" type="video/mp4">Your browser does not support the video tag.</video>';
                    
                    // Show the modal
                    const modalElement = document.getElementById('videoPreviewModal');
                    if (!modalElement) {
                        console.error('Modal element not found!');
                        return;
                    }
                    
                    const modal = new bootstrap.Modal(modalElement);
                    modal.show();
                });
            });

            // Clear video container when modal is hidden
            document.getElementById('videoPreviewModal').addEventListener('hidden.bs.modal', function() {
                document.getElementById('videoContainer').innerHTML = '';
            });
        });
    </script>
</body>
</html> 