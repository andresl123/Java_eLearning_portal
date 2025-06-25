package com.elearningplatform.model;

// Placeholder: Define User class with properties (e.g., userID, username, password, role) and getters/setters.
// Connects to: UserDAO for database operations, LoginServlet/RegisterServlet for form processing.
public class User {
    private int userId;
    private int roleId;
    private String firstName;
    private String lastName;
    private String email;
    private String password;
    private String tutorDesc;

    // Getters and Setters
    public int getUserId() {
        return userId;
    }
    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getRoleId() {
        return roleId;
    }
    public void setRoleId(int roleId) {
        this.roleId = roleId;
    }

    public String getFirstName() {
        return firstName;
    }
    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }
    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getEmail() {
        return email;
    }
    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }
    public void setPassword(String password) {
        this.password = password;
    }

    public String getTutorDesc() {
        return tutorDesc;
    }
    public void setTutorDesc(String tutorDesc) {
        this.tutorDesc = tutorDesc;
    }
}
