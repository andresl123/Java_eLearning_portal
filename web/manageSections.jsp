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
                <label class="form-label">Video URL or Local File Path</label>
                <input type="text" class="form-control" name="sectionVideoUrl" value="<%= sectionVideoUrl %>" placeholder="Web URL (https://...) or local file path (C:\... or file:///...)" >
                <small class="form-text text-muted">
                  Enter a web URL (https://...) or a local file path (C:\... or file:///...).
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
                    <td><a href="<%= rs.getString("section_video_url") %>" target="_blank">View Video</a></td>
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
</body>
</html> 