<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<nav class="navbar navbar-expand-lg navbar-light custom-navbar-bg">
    <div class="container-fluid">
        <!-- Logo and Explore Link on the Left -->
        <div class="d-flex align-items-center">
            <a class="navbar-brand" href="index.jsp">
                <img src="https://shulenihub.com/pluginfile.php/1/theme_moove/logo/1749635087/Logo-Transparent.png" alt="E-Learning Logo" style="width: 50px; height: 50px; margin-right: 10px;">
            </a>
            <a class="nav-link text-dark" href="allCourses.jsp">Explore</a> <!-- Already dark for visibility -->
        </div>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse justify-content-between" id="navbarNav">
            <!-- Modern Centered Search Bar -->
            <form class="search-bar mx-auto w-100" action="SearchServlet" method="get" style="max-width: 900px;" role="search">
                <div class="search-bar-container">
                    <span class="search-icon">
                        <svg width="20" height="20" fill="#7b7b7b" viewBox="0 0 16 16">
                            <path d="M11.742 10.344a6.5 6.5 0 1 0-1.397 1.398h-.001l3.85 3.85a1 1 0 0 0 1.415-1.415l-3.85-3.85zm-5.242 1.656a5.5 5.5 0 1 1 0-11 5.5 5.5 0 0 1 0 11z"/>
                        </svg>
                    </span>
                    <input class="search-input" type="search" name="query" placeholder="Discover courses..." aria-label="Search">
                    <button class="search-btn" type="submit">Search</button>
                </div>
            </form>
            <!-- Role-Based Links and Greeting on the Right -->
            <ul class="navbar-nav ms-auto align-items-center">
                <%
                    Integer navRole = (Integer) session.getAttribute("role");
                    String username = (String) session.getAttribute("username");
                    if (navRole != null) {
                        out.println("<li class='nav-item'><span class='nav-link text-dark'>Hi, " + (username != null ? username : "User") + "</span></li>"); // Changed to text-dark
                        if (navRole.equals(1)) {
                            out.println("<li class='nav-item'><a class='nav-link btn btn-primary' href='adminPanel.jsp'>Admin Panel</a></li>");
                        } else if (navRole.equals(2)) {
                            out.println("<li class='nav-item'><a class='nav-link btn btn-primary' href='studentDashboard.jsp'>My Dashboard</a></li>");
                        } else if (navRole.equals(3)) {
                            out.println("<li class='nav-item'><a class='nav-link btn btn-primary' href='tutorDashboard.jsp'>Tutor Panel</a></li>");
                        }
                        out.println("<li class='nav-item'><a class='nav-link' href='logout'>Logout</a></li>");
                    } else {
                        out.println("<li class='nav-item'><a class='nav-link' href='login.jsp'>Login</a></li>");
                        out.println("<li class='nav-item'><a class='nav-link' href='createAccount.jsp'>Register</a></li>");
                    }
                %>
            </ul>
        </div>
    </div>
</nav> 