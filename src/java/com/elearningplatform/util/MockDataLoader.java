package com.elearningplatform.util;

import java.sql.SQLException;

public class MockDataLoader {
    private final DBConnection db;

    public MockDataLoader(DBConnection db) {
        this.db = db;
    }

    // Helper method to check if a table has any data
    public boolean tableHasData(String tableName) throws SQLException {
        db.connect();
        String query = "SELECT COUNT(*) FROM " + tableName;
        var pstmt = db.getConn().prepareStatement(query);
        var rs = pstmt.executeQuery();
        boolean hasData = false;
        if (rs.next()) {
            hasData = rs.getInt(1) > 0;
        }
        rs.close();
        pstmt.close();
        return hasData;
    }

    public void insertMockUsers() throws SQLException {
        db.connect();
        db.createTablesIfNotExist();
        // Only insert mock data if User table is empty
        if (tableHasData("User")) {
            System.out.println("User table already has data. Skipping mock user insertion.");
            return;
        }
        // Insert roles in specific order
        db.insertRole("Admin");    // role_id = 1
        db.insertRole("Student");  // role_id = 2
        db.insertRole("Tutor");    // role_id = 3

        int adminRoleId = 1;
        int studentRoleId = 2;
        int tutorRoleId = 3;

        // Insert 1 admin
        db.insertUser(adminRoleId,
                "Admin",
                "User",
                "admin@elearn.com",
                "admin123",
                null);

        // Realistic student data
        String[][] students = {
            {"Andre", "Lopes", "C0948798@mylambton.ca"},
            {"Hermes", "Castaño", "C0934695@mylambton.ca"},
            {"Abhishek", "Soni", "C0940236@mylambton.ca"},
            {"Ed", "Suelila", "C0934658@mylambton.ca"},
            {"Alex", "Velasquez", "C0937885@mylambton.ca"}
        };

        for (String[] student : students) {
            db.insertUser(studentRoleId, student[0], student[1], student[2], "pass123", null);
        }

        // Realistic tutor data
        String[][] tutors = {
            {"Robin", "Singh", "RobinS@queenscollege.ca", "Expert in Java"},
            {"Sagara", "Samarawickrama", "sagaras@queenscollege.ca", " Expert in Full Stack Technologies"},
            {"Nishant ", "Gupta", "NishantG@queenscollege.ca", "Dr in Algorithms and Data Structres"},
            {"Shivani", "Anand", "ShivaniA@queenscollege.ca", "Expert in Cloud Computing"},
            {"Gautam", "Beri", "Gautamb@queenscollege.ca", "Expert on Agile Methodologies"}
        };

        for (String[] tutor : tutors) {
            db.insertUser(tutorRoleId, tutor[0], tutor[1], tutor[2], "tutorpass", tutor[3]);
        }

        System.out.println("✅ Mock data inserted: 1 Admin, 5 Students, 5 Tutors.");
    }

    public void insertMockCoursesAndEnrollments() throws SQLException {
        db.connect();
        db.createTablesIfNotExist();
        // Only insert mock data if Course table is empty
        if (tableHasData("Course")) {
            System.out.println("Course table already has data. Skipping mock course and enrollment insertion.");
            return;
        }
        // Course data with realistic information
        Object[][] courses = {
            // userId, roleId, name, price, status, enroll, desc, category, rating, courseImage
            {7, 3, "Java Programming Fundamentals", 99, "Active", true, 
             "Learn the basics of Java programming including variables, loops, and object-oriented concepts. Perfect for beginners.", 
             "Programming", 4, "https://img.freepik.com/premium-psd/school-education-admission-youtube-thumbnail-web-banner-template_475351-410.jpg"},
            
            {8, 3, "Full Stack Web Development", 149, "Active", true,
             "Master both frontend and backend development with HTML, CSS, JavaScript, and Node.js. Build complete web applications.",
             "Web Development", 5, "https://www.codingbytes.com/wp-content/uploads/2022/03/full-stack-web-development.jpg"},
            
            {9, 3, "Data Structures and Algorithms", 129, "Active", true,
             "Deep dive into essential data structures and algorithms. Learn to write efficient and optimized code.",
             "Computer Science", 5, "https://learncraftacademy.com/wp-content/uploads/2024/12/https___dev-to-uploads.s3.amazonaws.com_uploads_articles_6gsw2jl53ye6aabdndqg.png"},
            
            {10, 3, "Cloud Computing with AWS", 179, "Active", true,
             "Learn cloud computing fundamentals and AWS services. Deploy and manage applications in the cloud.",
             "Cloud Computing", 4, "https://www.skillvertex.com/blog/wp-content/uploads/2023/04/data-science-thumbnail.png"},
            
            {11, 3, "Agile Project Management", 89, "Active", true,
             "Master Agile methodologies including Scrum, Kanban, and Lean. Lead successful project teams.",
             "Project Management", 4, "https://i0.wp.com/visionateacademy.com/wp-content/uploads/2023/05/Lean-Agile-Project-Management-Course-by-Visionate-Academy.jpg"}
        };
        // Insert courses
        for (Object[] course : courses) {
            db.insertCourse(
                (Integer) course[0], (Integer) course[1], (String) course[2], 
                (Integer) course[3], (String) course[4], (Boolean) course[5], 
                (String) course[6], (String) course[7], (Integer) course[8], 
                (String) course[9]
            );
        }
        // Course sections data
        Object[][] sections = {
            // courseId, sectionTitle, duration, sectionDesc, sectionVideoUrl
            {1, "Introduction to Java", 45, "Overview of Java programming language and setting up development environment", "videos/java-intro.mp4"},
            {1, "Variables and Data Types", 60, "Learn about different data types and variable declaration in Java", "videos/java-variables.mp4"},
            {1, "Control Structures", 75, "Understanding if-else statements, loops, and switch cases", "videos/java-control.mp4"},
            {1, "Object-Oriented Programming", 90, "Classes, objects, inheritance, and polymorphism", "videos/java-oop.mp4"},
            
            {2, "HTML and CSS Basics", 60, "Learn HTML structure and CSS styling fundamentals", "videos/html-css-basics.mp4"},
            {2, "JavaScript Fundamentals", 75, "Variables, functions, and DOM manipulation", "videos/js-fundamentals.mp4"},
            {2, "Backend with Node.js", 90, "Server-side programming with Node.js and Express", "videos/nodejs-backend.mp4"},
            {2, "Database Integration", 60, "Connecting to databases and handling data", "videos/database-integration.mp4"},
            
            {3, "Arrays and Linked Lists", 75, "Understanding basic data structures", "videos/arrays-linkedlists.mp4"},
            {3, "Stacks and Queues", 60, "Stack and queue implementations and applications", "videos/stacks-queues.mp4"},
            {3, "Trees and Graphs", 90, "Tree and graph data structures and traversal", "videos/trees-graphs.mp4"},
            {3, "Sorting Algorithms", 75, "Bubble sort, quick sort, merge sort, and their complexities", "videos/sorting-algorithms.mp4"},
            
            {4, "AWS Fundamentals", 60, "Introduction to AWS services and cloud concepts", "videos/aws-fundamentals.mp4"},
            {4, "EC2 and VPC", 75, "Virtual machines and networking in AWS", "videos/ec2-vpc.mp4"},
            {4, "S3 and Database Services", 60, "Storage and database services in AWS", "videos/s3-database.mp4"},
            {4, "Deployment and Monitoring", 45, "Deploying applications and monitoring with CloudWatch", "videos/deployment-monitoring.mp4"},
            
            {5, "Agile Principles", 45, "Understanding Agile values and principles", "videos/agile-principles.mp4"},
            {5, "Scrum Framework", 75, "Scrum roles, events, and artifacts", "videos/scrum-framework.mp4"},
            {5, "Kanban and Lean", 60, "Kanban methodology and Lean principles", "videos/kanban-lean.mp4"},
            {5, "Agile Tools and Practices", 45, "Using tools like Jira and best practices", "videos/agile-tools.mp4"}
        };
        // Insert course sections
        for (Object[] section : sections) {
            db.insertCourseDetail(
                (Integer) section[0], (String) section[1], (Integer) section[2], 
                (String) section[3], (String) section[4]
            );
        }
        // Get student IDs for enrollment
        // First, let's get the student with email C0934658@mylambton.ca (Ed Suelila)
        String query = "SELECT user_id FROM User WHERE user_email = ?";
        var pstmt = db.getConn().prepareStatement(query);
        pstmt.setString(1, "C0934658@mylambton.ca");
        var rs = pstmt.executeQuery();
        int edStudentId = 0;
        if (rs.next()) {
            edStudentId = rs.getInt("user_id");
        }
        // Get another student (Andre Lopes)
        pstmt.setString(1, "C0948798@mylambton.ca");
        rs = pstmt.executeQuery();
        int andreStudentId = 0;
        if (rs.next()) {
            andreStudentId = rs.getInt("user_id");
        }
        rs.close();
        pstmt.close();
        // Enrollment data
        Object[][] enrollments = {
            // userId, courseId, progressPercentage, completionStatus
            {edStudentId, 1, 75, "In Progress"},      // Ed enrolled in Java Programming (75% complete)
            {edStudentId, 2, 100, "Completed"},       // Ed completed Full Stack Web Development
            {edStudentId, 4, 25, "In Progress"},      // Ed enrolled in AWS Cloud Computing (25% complete)
            
            {andreStudentId, 1, 100, "Completed"},    // Andre completed Java Programming
            {andreStudentId, 3, 50, "In Progress"},   // Andre enrolled in Data Structures (50% complete)
            {andreStudentId, 5, 0, "In Progress"}     // Andre just enrolled in Agile Project Management
        };
        // Insert enrollments
        for (Object[] enrollment : enrollments) {
            int userId = (Integer) enrollment[0];
            int courseId = (Integer) enrollment[1];
            int progress = (Integer) enrollment[2];
            String status = (String) enrollment[3];
            // First enroll the student
            db.enrollStudent(userId, courseId);
            // Then update their progress and status
            db.updateEnrollmentProgress(userId, courseId, progress);
            db.updateEnrollmentStatus(userId, courseId, status);
        }
        System.out.println("✅ Mock course data inserted: 5 Courses with 20 Sections");
        System.out.println("✅ Mock enrollment data inserted: 2 Students enrolled in 6 courses total");
        System.out.println("   - Ed Suelila (C0934658@mylambton.ca): 3 courses enrolled");
        System.out.println("   - Andre Lopes (C0948798@mylambton.ca): 3 courses enrolled");
    }
} 