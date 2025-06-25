import com.elearningplatform.model.User;
import com.elearningplatform.util.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;


@WebServlet("/AdminServlet")
public class AdminServlet extends HttpServlet {
    private DBConnection userDAO;

    @Override
    public void init() {
        userDAO = new DBConnection(); // Ensure this initializes the DB connection
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("submit");

        try {
            switch (action) {
                case "create":
                    insertUser(request, response);
                    break;
                case "edit":
                    updateUser(request, response);
                    break;
                case "delete":
                    deleteUser(request, response);
                    break;
                default:
                    response.sendRedirect("adminPanel.jsp");
            }
        } catch (SQLException e) {
            throw new ServletException("Database error: " + e.getMessage(), e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("list".equals(action)) {
            List<User> userList = null;
            try {
                userList = userDAO.getAllUsers();
            } catch (SQLException ex) {
                System.getLogger(AdminServlet.class.getName()).log(System.Logger.Level.ERROR, (String) null, ex);
            }
            request.setAttribute("users", userList);
            request.getRequestDispatcher("userList.jsp").forward(request, response);
        } else {
            response.sendRedirect("adminPanel.jsp");
        }
    }

    private void insertUser(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        int roleId = Integer.parseInt(request.getParameter("roleId"));
        String firstName = request.getParameter("username");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String tutorDesc = request.getParameter("tutorDesc");

        userDAO.insertUser(roleId, firstName, lastName, email, password, tutorDesc);
        response.sendRedirect("adminPanel.jsp");
    }

    private void updateUser(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        int userId = Integer.parseInt(request.getParameter("userId"));
        int roleId = Integer.parseInt(request.getParameter("roleId"));
        String firstName = request.getParameter("username");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String tutorDesc = request.getParameter("tutorDesc");

        userDAO.updateUser(userId, roleId, firstName, lastName, email, password, tutorDesc);
        response.sendRedirect("adminPanel.jsp");
    }

    private void deleteUser(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        int userId = Integer.parseInt(request.getParameter("userId"));
        userDAO.deleteUser(userId);
        response.sendRedirect("adminPanel.jsp");
    }
}
