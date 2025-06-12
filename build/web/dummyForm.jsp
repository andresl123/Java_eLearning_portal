<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Dummy Item Form</title>
    <!-- Bootstrap for basic styling -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
    <div class="container mt-4">
        <h2>Add Dummy Item</h2>
        <!-- Form submits to DummyServlet -->
        <form action="DummyServlet" method="post">
            <div class="form-group">
                <label for="name">Item Name:</label>
                <input type="text" class="form-control" id="name" name="name" required>
            </div>
            <div class="form-group">
                <label for="description">Description:</label>
                <textarea class="form-control" id="description" name="description" required></textarea>
            </div>
            <button type="submit" class="btn btn-primary">Submit</button>
        </form>
        <!-- Display error or success message if present -->
        <% if (request.getAttribute("message") != null) { %>
            <p class="text-info mt-3"><%= request.getAttribute("message") %></p>
        <% } %>
    </div>
</body>
</html>
