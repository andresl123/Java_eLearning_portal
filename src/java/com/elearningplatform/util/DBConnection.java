package com.elearningplatform.util;

import com.elearningplatform.model.User;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DBConnection {

    private static final String DB_NAME = "elearning_db";
    private static final String DB_URL_WITHOUT_DB = "jdbc:mysql://localhost:3306/";
    private static final String DB_URL = "jdbc:mysql://localhost:3306/" + DB_NAME;
    private static final String DB_USER = "root"; // Update for your MySQL connection
    private static final String DB_PASSWORD = "123456"; // Update for your MySQL connection

    private Connection conn;
    private PreparedStatement pstmt;
    private ResultSet rs;
    
    private String loggedInUserName;
    private Integer roleId;
    
    public Connection getConn() {
        return conn;
    }
    
    // Connect to the database and create it, if it doesn't exist
    public void connect() throws SQLException {
    try {
        Class.forName("com.mysql.cj.jdbc.Driver"); // Register driver
        
        // Try connecting to the actual database
        System.out.println("Trying to connect to DB: " + DB_URL);
        conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
         System.out.println("Connected to existing database");
         
    } catch (SQLException ex) {
        System.out.println("SQLException caught: " + ex.getMessage());
        
        // Check if error is "Unknown database"
        if (ex.getMessage().contains("Unknown database")) {
            System.out.println("Database doesn't exist. Creating...");

            try ( // Connect to MySQL server without database
                    Connection tempConn = DriverManager.getConnection(DB_URL_WITHOUT_DB, DB_USER, DB_PASSWORD); 
                    Statement stmt = tempConn.createStatement()) {
                stmt.executeUpdate("CREATE DATABASE IF NOT EXISTS " + DB_NAME);
                                                                 }

            // Retry connecting to the newly created database
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            System.out.println("Connected to newly created database.");
        } else {
            throw ex; // If it's another error, rethrow it
        }
    }   catch (ClassNotFoundException ex) {
            Logger.getLogger(DBConnection.class.getName()).log(Level.SEVERE, null, ex);
        }
}

    // Create all tables if they don't exist
    public void createTablesIfNotExist() throws SQLException {
        connect();
       
        try (Statement stmt = conn.createStatement()) {
            // Role Table
            stmt.executeUpdate("""
                                           CREATE TABLE IF NOT EXISTS Role (
                                               role_id INT PRIMARY KEY AUTO_INCREMENT,
                                               role_name VARCHAR(100) NOT NULL
                                           )
                                       """);
            
            // User Table
            stmt.executeUpdate("""
                                           CREATE TABLE IF NOT EXISTS User (
                                               user_id INT PRIMARY KEY AUTO_INCREMENT,
                                               role_id INT,
                                               user_name VARCHAR(100) NOT NULL,
                                               user_last_name VARCHAR(100) NOT NULL,
                                               user_email VARCHAR(100) NOT NULL,
                                               user_password VARCHAR(100) NOT NULL,
                                               tutor_desc VARCHAR(255),
                                               FOREIGN KEY (role_id) REFERENCES Role(role_id)
                                           )
                                       """);
            
            // Course Table
            stmt.executeUpdate("""
                                           CREATE TABLE IF NOT EXISTS Course (
                                               course_id INT PRIMARY KEY AUTO_INCREMENT,
                                               user_id INT,
                                               role_id INT,
                                               course_name VARCHAR(150) NOT NULL,
                                               course_price INT,
                                               course_status VARCHAR(50) NOT NULL,
                                               course_enroll BOOLEAN NOT NULL,
                                               course_desc TEXT NOT NULL,
                                               course_category VARCHAR(100) NOT NULL,
                                               course_rating INT NOT NULL,
                                               course_image VARCHAR(255),
                                               FOREIGN KEY (user_id) REFERENCES User(user_id),
                                               FOREIGN KEY (role_id) REFERENCES Role(role_id)
                                           )
                                       """);
            
            // Course_details Table
            stmt.executeUpdate("""
                                           CREATE TABLE IF NOT EXISTS Course_details (
                                               section_id INT PRIMARY KEY AUTO_INCREMENT,
                                               course_id INT,
                                               section_title VARCHAR(150),
                                               section_duration INT,
                                               section_desc TEXT,
                                               section_video_url VARCHAR(255),
                                               FOREIGN KEY (course_id) REFERENCES Course(course_id)
                                           )
                                       """);
            
            // Enrollment Table
            stmt.executeUpdate("""
                                           CREATE TABLE IF NOT EXISTS Enrollment (
                                               enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
                                               user_id INT,
                                               course_id INT,
                                               enrollment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
                                               completion_status VARCHAR(50) DEFAULT 'In Progress',
                                               progress_percentage INT DEFAULT 0,
                                               last_accessed DATETIME DEFAULT CURRENT_TIMESTAMP,
                                               FOREIGN KEY (user_id) REFERENCES User(user_id),
                                               FOREIGN KEY (course_id) REFERENCES Course(course_id),
                                               UNIQUE KEY unique_enrollment (user_id, course_id)
                                           )
                                       """);
        }
    }

    

    //Generic query executor
    public ResultSet executeQuery(String query) throws SQLException {
        pstmt = conn.prepareStatement(query);
        rs = pstmt.executeQuery();
        return rs;
    }

    // USER METHODS
    
    public boolean verifyUserExist(String email) throws SQLException{
        connect();
        String query = "SELECT user_email FROM user WHERE user_email = ?";
        pstmt = conn.prepareStatement(query);
        pstmt.setString(1, email);
        ResultSet rs; 
        rs = pstmt.executeQuery(); 
        
        return rs.next(); 
        }

    public boolean insertUser(int roleId, String firstName, String lastName, String email, String password, String tutorDesc) throws SQLException {
        connect();
        String query = "INSERT INTO User (role_id, user_name, user_last_name, user_email, user_password, tutor_desc) VALUES (?, ?, ?, ?, ?, ?)";
        pstmt = conn.prepareStatement(query);
        pstmt.setInt(1, roleId);
        pstmt.setString(2, firstName);
        pstmt.setString(3, lastName);
        pstmt.setString(4, email);
        pstmt.setString(5, password);
        pstmt.setString(6, tutorDesc);
        return pstmt.executeUpdate() > 0;
    }
    public boolean updateUser(int userId, int roleId, String firstName, String lastName, String email, String password, String tutorDesc) throws SQLException {
        connect();
        String query = "UPDATE User SET role_id = ?, user_name = ?, user_last_name = ?, user_email = ?, user_password = ?, tutor_desc = ? WHERE user_id = ?";
        pstmt = conn.prepareStatement(query);
        pstmt.setInt(1, roleId);
        pstmt.setString(2, firstName);
        pstmt.setString(3, lastName);
        pstmt.setString(4, email);
        pstmt.setString(5, password);
        pstmt.setString(6, tutorDesc);
        pstmt.setInt(7, userId);
        return pstmt.executeUpdate() > 0;
    }
    
    public boolean deleteUser(int userId) throws SQLException {
        connect();
        String query = "DELETE FROM User WHERE user_id = ?";
        pstmt = conn.prepareStatement(query);
        pstmt.setInt(1, userId);
        return pstmt.executeUpdate() > 0;
    }
    
    public List<User> getAllUsers() throws SQLException {
        connect();
        List<User> userList = new ArrayList<>();
        String query = "SELECT * FROM User";
        pstmt = conn.prepareStatement(query);
        rs = pstmt.executeQuery();

        while (rs.next()) {
            User user = new User();
            user.setUserId(rs.getInt("user_id"));
            user.setRoleId(rs.getInt("role_id"));
            user.setFirstName(rs.getString("user_name"));
            user.setLastName(rs.getString("user_last_name"));
            user.setEmail(rs.getString("user_email"));
            user.setPassword(rs.getString("user_password"));
            user.setTutorDesc(rs.getString("tutor_desc"));
            userList.add(user);
    }

    return userList;
    }
       
    public String getUserNameByEmail(String email) throws SQLException {
        String query = "SELECT user_name FROM User WHERE user_email = ?";
        pstmt = conn.prepareStatement(query);
        pstmt.setString(1, email.trim());
        rs = pstmt.executeQuery();
        if (rs.next()) {
            return rs.getString("user_name");
        }
        return null;
    }


    public boolean verifyUserLogin(String email, String password) throws SQLException {
        String query = "SELECT role_id,user_name FROM User WHERE user_email = ? AND user_password = ?";
        pstmt = conn.prepareStatement(query);
        pstmt.setString(1, email.trim());
        pstmt.setString(2, password.trim());

        rs = pstmt.executeQuery();
        if (rs.next()) {
            loggedInUserName = rs.getString("user_name");
            roleId = rs.getInt("role_id");
            return true;
        }
        return false;
        }

    public String getLoggedInUserName() {
            return loggedInUserName;
    }
    public Integer getLoggedInRoleId() {
            return roleId;
    }


    // ROLE METHODS

    public boolean insertRole(String roleName) throws SQLException {
        String query = "INSERT INTO Role (role_name) VALUES (?)";
        pstmt = conn.prepareStatement(query);
        pstmt.setString(1, roleName);
        return pstmt.executeUpdate() > 0;
    }

    public ResultSet getRoleById(int roleId) throws SQLException {
        String query = "SELECT * FROM Role WHERE role_id = ?";
        pstmt = conn.prepareStatement(query);
        pstmt.setInt(1, roleId);
        return pstmt.executeQuery();
    }
    
    public ResultSet getRoleIDByName(String roleName) throws SQLException {
        String query = "SELECT role_id FROM Role WHERE role_name = ?";
        pstmt = conn.prepareStatement(query);
        pstmt.setString(1, roleName);
        return pstmt.executeQuery();
    }

    // COURSE METHODS

    public boolean insertCourse(int userId, int roleId, String name, int price, String status, boolean enroll, String desc, String category, int rating, String courseImage) throws SQLException {
        connect();
        String query = "INSERT INTO Course (user_id, role_id, course_name, course_price, course_status, course_enroll, course_desc, course_category, course_rating, course_image) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        pstmt = conn.prepareStatement(query);
        pstmt.setInt(1, userId);
        pstmt.setInt(2, roleId);
        pstmt.setString(3, name);
        pstmt.setInt(4, price);
        pstmt.setString(5, status);
        pstmt.setBoolean(6, enroll);
        pstmt.setString(7, desc);
        pstmt.setString(8, category);
        pstmt.setInt(9, rating);
        pstmt.setString(10, courseImage);
        return pstmt.executeUpdate() > 0;
    }

    public ResultSet getCourseById(int courseId) throws SQLException {
        connect();
        String query = "SELECT * FROM Course WHERE course_id = ?";
        pstmt = conn.prepareStatement(query);
        pstmt.setInt(1, courseId);
        return pstmt.executeQuery();
    }

    // COURSE DETAILS METHODS

    public boolean insertCourseDetail(int courseId, String sectionTitle, int duration, String sectionDesc, String sectionVideoUrl) throws SQLException {
        String query = "INSERT INTO Course_details (course_id, section_title, section_duration, section_desc, section_video_url) VALUES (?, ?, ?, ?, ?)";
        pstmt = conn.prepareStatement(query);
        pstmt.setInt(1, courseId);
        pstmt.setString(2, sectionTitle);
        pstmt.setInt(3, duration);
        pstmt.setString(4, sectionDesc);
        pstmt.setString(5, sectionVideoUrl);
        return pstmt.executeUpdate() > 0;
    }

    public ResultSet getCourseDetailsByCourseId(int courseId) throws SQLException {
        String query = "SELECT * FROM Course_details WHERE course_id = ?";
        pstmt = conn.prepareStatement(query);
        pstmt.setInt(1, courseId);
        return pstmt.executeQuery();
    }
    
    // ENROLLMENT METHODS
    
    // Enroll a student in a course. Prevents duplicate enrollments due to unique constraint on (user_id, course_id).
    public boolean enrollStudent(int userId, int courseId) throws SQLException {
        connect();
        String query = "INSERT INTO Enrollment (user_id, course_id) VALUES (?, ?)";
        pstmt = conn.prepareStatement(query);
        pstmt.setInt(1, userId);
        pstmt.setInt(2, courseId);
        return pstmt.executeUpdate() > 0;
    }
    
    // Update a student's progress in a course (0-100 percentage).
    public boolean updateEnrollmentProgress(int userId, int courseId, int progressPercentage) throws SQLException {
        connect();
        String query = "UPDATE Enrollment SET progress_percentage = ?, last_accessed = CURRENT_TIMESTAMP WHERE user_id = ? AND course_id = ?";
        pstmt = conn.prepareStatement(query);
        pstmt.setInt(1, progressPercentage);
        pstmt.setInt(2, userId);
        pstmt.setInt(3, courseId);
        return pstmt.executeUpdate() > 0;
    }
    
    // Update a student's completion status (e.g., In Progress, Completed, Dropped).
    public boolean updateEnrollmentStatus(int userId, int courseId, String status) throws SQLException {
        connect();
        String query = "UPDATE Enrollment SET completion_status = ?, last_accessed = CURRENT_TIMESTAMP WHERE user_id = ? AND course_id = ?";
        pstmt = conn.prepareStatement(query);
        pstmt.setString(1, status);
        pstmt.setInt(2, userId);
        pstmt.setInt(3, courseId);
        return pstmt.executeUpdate() > 0;
    }
    
    // Remove a student from a course (unenroll).
    public boolean unenrollStudent(int userId, int courseId) throws SQLException {
        connect();
        String query = "DELETE FROM Enrollment WHERE user_id = ? AND course_id = ?";
        pstmt = conn.prepareStatement(query);
        pstmt.setInt(1, userId);
        pstmt.setInt(2, courseId);
        return pstmt.executeUpdate() > 0;
    }
    
    // Get all courses a student is enrolled in, including course details like name, description, and price.
    public ResultSet getStudentEnrollments(int userId) throws SQLException {
        connect();
        String query = """
            SELECT e.*, c.course_name, c.course_desc, c.course_image, c.course_price 
            FROM Enrollment e 
            JOIN Course c ON e.course_id = c.course_id 
            WHERE e.user_id = ?
            ORDER BY e.enrollment_date DESC
            """;
        pstmt = conn.prepareStatement(query);
        pstmt.setInt(1, userId);
        return pstmt.executeQuery();
    }
    
    // Get all students enrolled in a specific course, including student names and emails.
    public ResultSet getCourseEnrollments(int courseId) throws SQLException {
        connect();
        String query = """
            SELECT e.*, u.user_name, u.user_last_name, u.user_email 
            FROM Enrollment e 
            JOIN User u ON e.user_id = u.user_id 
            WHERE e.course_id = ?
            ORDER BY e.enrollment_date DESC
            """;
        pstmt = conn.prepareStatement(query);
        pstmt.setInt(1, courseId);
        return pstmt.executeQuery();
    }
    
    // Check if a student is already enrolled in a specific course.
    public boolean isStudentEnrolled(int userId, int courseId) throws SQLException {
        connect();
        String query = "SELECT COUNT(*) FROM Enrollment WHERE user_id = ? AND course_id = ?";
        pstmt = conn.prepareStatement(query);
        pstmt.setInt(1, userId);
        pstmt.setInt(2, courseId);
        rs = pstmt.executeQuery();
        if (rs.next()) {
            return rs.getInt(1) > 0;
        }
        return false;
    }
    
    // Get the total number of students enrolled in a course (useful for course popularity).
    public int getEnrollmentCount(int courseId) throws SQLException {
        connect();
        String query = "SELECT COUNT(*) FROM Enrollment WHERE course_id = ?";
        pstmt = conn.prepareStatement(query);
        pstmt.setInt(1, courseId);
        rs = pstmt.executeQuery();
        if (rs.next()) {
            return rs.getInt(1);
        }
        return 0;
    }

    // INSERT MOCK INFORMATION
    
    public void insertMockUsers() throws SQLException {
    connect();
    createTablesIfNotExist();

    // Insert roles in specific order
    insertRole("Admin");    // role_id = 1
    insertRole("Student");  // role_id = 2
    insertRole("Tutor");    // role_id = 3

    int adminRoleId = 1;
    int studentRoleId = 2;
    int tutorRoleId = 3;

    // Insert 1 admin
    insertUser(adminRoleId,
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
        insertUser(studentRoleId, student[0], student[1], student[2], "pass123", null);
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
        insertUser(tutorRoleId, tutor[0], tutor[1], tutor[2], "tutorpass", tutor[3]);
    }

    System.out.println("✅ Mock data inserted: 1 Admin, 5 Students, 5 Tutors.");
}

public void insertMockCoursesAndEnrollments() throws SQLException {
    connect();
    createTablesIfNotExist();
    
    // Course data with realistic information
    Object[][] courses = {
        // userId, roleId, name, price, status, enroll, desc, category, rating, courseImage
        {3, 3, "Java Programming Fundamentals", 99, "Active", true, 
         "Learn the basics of Java programming including variables, loops, and object-oriented concepts. Perfect for beginners.", 
         "Programming", 4, "images/java-fundamentals.jpg"},
        
        {4, 3, "Full Stack Web Development", 149, "Active", true,
         "Master both frontend and backend development with HTML, CSS, JavaScript, and Node.js. Build complete web applications.",
         "Web Development", 5, "images/fullstack-web.jpg"},
        
        {5, 3, "Data Structures and Algorithms", 129, "Active", true,
         "Deep dive into essential data structures and algorithms. Learn to write efficient and optimized code.",
         "Computer Science", 5, "images/dsa-course.jpg"},
        
        {6, 3, "Cloud Computing with AWS", 179, "Active", true,
         "Learn cloud computing fundamentals and AWS services. Deploy and manage applications in the cloud.",
         "Cloud Computing", 4, "images/aws-cloud.jpg"},
        
        {7, 3, "Agile Project Management", 89, "Active", true,
         "Master Agile methodologies including Scrum, Kanban, and Lean. Lead successful project teams.",
         "Project Management", 4, "images/agile-pm.jpg"}
    };
    
    // Insert courses
    for (Object[] course : courses) {
        insertCourse(
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
        insertCourseDetail(
            (Integer) section[0], (String) section[1], (Integer) section[2], 
            (String) section[3], (String) section[4]
        );
    }
    
    // Get student IDs for enrollment
    // First, let's get the student with email C0934658@mylambton.ca (Ed Suelila)
    String query = "SELECT user_id FROM User WHERE user_email = ?";
    pstmt = conn.prepareStatement(query);
    pstmt.setString(1, "C0934658@mylambton.ca");
    rs = pstmt.executeQuery();
    
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
        enrollStudent(userId, courseId);
        
        // Then update their progress and status
        updateEnrollmentProgress(userId, courseId, progress);
        updateEnrollmentStatus(userId, courseId, status);
    }
    
    System.out.println("✅ Mock course data inserted: 5 Courses with 20 Sections");
    System.out.println("✅ Mock enrollment data inserted: 2 Students enrolled in 6 courses total");
    System.out.println("   - Ed Suelila (C0934658@mylambton.ca): 3 courses enrolled");
    System.out.println("   - Andre Lopes (C0948798@mylambton.ca): 3 courses enrolled");
}

	
// Close resources
    public void closeResources() {
        try {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            System.out.print(e);
        }
    }
}