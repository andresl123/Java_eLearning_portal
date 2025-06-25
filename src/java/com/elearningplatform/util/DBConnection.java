package com.elearningplatform.util;

import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DBConnection {

    private static final String DB_NAME = "elearning_db";
    private static final String DB_URL_WITHOUT_DB = "jdbc:mysql://localhost:3306/";
    private static final String DB_URL = "jdbc:mysql://localhost:3306/" + DB_NAME;
    private static final String DB_USER = "mayerlin"; // Update for your MySQL connection
    private static final String DB_PASSWORD = "MySQL123"; // Update for your MySQL connection

    private Connection conn;
    private PreparedStatement pstmt;
    private ResultSet rs;
    
    private String loggedInUserName;
            
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

    // Create all tables if they don’t exist
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
                                               FOREIGN KEY (course_id) REFERENCES Course(course_id)
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

    public boolean insertUser(int roleId, String firstName, String lastName, String email, String password, String tutorDesc) throws SQLException {
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
    String query = "SELECT user_name FROM User WHERE user_email = ? AND user_password = ?";
    pstmt = conn.prepareStatement(query);
    pstmt.setString(1, email.trim());
    pstmt.setString(2, password.trim());
    
    rs = pstmt.executeQuery();
    if (rs.next()) {
        loggedInUserName = rs.getString("user_name");
        return true;
    }
    return false;
    }

public String getLoggedInUserName() {
    return loggedInUserName;
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

    // COURSE METHODS

    public boolean insertCourse(int userId, int roleId, String name, int price, String status, boolean enroll, String desc, String category, int rating) throws SQLException {
        String query = "INSERT INTO Course (user_id, role_id, course_name, course_price, course_status, course_enroll, course_desc, course_category, course_rating) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
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
        return pstmt.executeUpdate() > 0;
    }

    public ResultSet getCourseById(int courseId) throws SQLException {
        String query = "SELECT * FROM Course WHERE course_id = ?";
        pstmt = conn.prepareStatement(query);
        pstmt.setInt(1, courseId);
        return pstmt.executeQuery();
    }

    // COURSE DETAILS METHODS

    public boolean insertCourseDetail(int courseId, String sectionTitle, int duration, String sectionDesc) throws SQLException {
        String query = "INSERT INTO Course_details (course_id, section_title, section_duration, section_desc) VALUES (?, ?, ?, ?)";
        pstmt = conn.prepareStatement(query);
        pstmt.setInt(1, courseId);
        pstmt.setString(2, sectionTitle);
        pstmt.setInt(3, duration);
        pstmt.setString(4, sectionDesc);
        return pstmt.executeUpdate() > 0;
    }

    public ResultSet getCourseDetailsByCourseId(int courseId) throws SQLException {
        String query = "SELECT * FROM Course_details WHERE course_id = ?";
        pstmt = conn.prepareStatement(query);
        pstmt.setInt(1, courseId);
        return pstmt.executeQuery();
    }
    
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