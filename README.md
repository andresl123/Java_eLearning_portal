## DummyProject (DAO + JSP + Servlet + MySQL Demo)

This is a simple Java web app to demonstrate how to:
- Use **JSP** for forms and front-end
- Handle input with a **Servlet**
- Interact with a **MySQL database** through a **DAO (Data Access Object)**
- Keep your app structured with **Model**, **DAO**, and **Utility classes**

## 🔧 Technologies Used
- Apache Tomcat 10
- JSP / Servlet (Jakarta EE)
- MySQL
- NetBeans IDE
- JDBC (with MySQL Connector/J)

## 📂 Project Structure

| File / Class         | Purpose                                                                 |
|----------------------|-------------------------------------------------------------------------|
| `dummyForm.jsp`      | The input form users see. Sends form data to `DummyServlet`.           |
| `DummyServlet.java`  | Handles form submission. Validates data and calls the DAO.             |
| `Item.java`          | The **Model** class. Represents an item with fields like name, desc.   |
| `ItemDAO.java`       | The **DAO** class. Handles SQL logic, inserts data into the DB.         |
| `DBConnection.java`  | Utility class to manage JDBC connection to MySQL.                      |
| `web.xml`            | Declares the welcome page and servlet routing config.                  |

## 🧪 How to Run It

1. Make sure MySQL is running.
2. Create the database by running this SQL:

   ```sql
   CREATE DATABASE dummy_db;
   USE dummy_db;

   CREATE TABLE Items (
       itemID INT PRIMARY KEY AUTO_INCREMENT,
       name VARCHAR(50),
       description TEXT,
       created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
   );
   ```

3. Update the `DBConnection.java` file with your own MySQL username and password.
4. Make sure `mysql-connector-j-*.jar` is in your project libraries.
5. Deploy the project to Apache Tomcat 10 (via NetBeans or manually).
6. Open this in your browser:
   ```
   http://localhost:8080/DummyProject/
   ```

## 📚 What You'll Learn
- How **data flows** from a JSP form ➝ Servlet ➝ DAO ➝ MySQL
- How to structure a Java web app into Model-View-Controller style
- How to display real-time form success or error feedback using JSP

## ✅ Quick Notes
- This project is for learning purposes only
- Easy to extend with update/delete functionality
- Follow good practices by separating concerns (form, logic, database)

## 🙌 Feel free to fork, modify, or share with classmates. Enjoy coding!