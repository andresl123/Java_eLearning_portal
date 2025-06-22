<%-- 
    Document   : index
    Created on : Jun 8, 2025, 1:27:41 PM
    Author     : samit
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="com.elearningplatform.util.DBConnection"  %>

<%
    DBConnection db = new DBConnection();
    try {
        db.insertMockUsers();
        out.println("✅ Mock users inserted successfully!");
    } catch (Exception e) {
        System.out.print(e);
    } finally {
        db.closeResources();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>E-Learning Platform</title>
    
     <!-- Style Sheet CSS -->
    <link rel="stylesheet" href="css/style.css">
    
    <!-- Toastr CSS -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.css" rel="stylesheet" />

    <!-- jQuery (required by Toastr) -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <!-- Toastr JS -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js"></script>
    
    <script src="js/scripts.js"></script>
    


</head>
<body>
    <!-- Placeholder: Add landing page with links to login.jsp and register.jsp.
         Connects to: login.jsp and register.jsp for navigation, style.css for styling, script.js for interactivity. -->
    <a href="login_student.jsp">Go to Login Page</a>
    
</body>

</html>
