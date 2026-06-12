package servlet;

import model.User;
import util.DataHandler;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/DeleteUserServlet")
public class DeleteUserServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");

        if (currentUser == null) {
            response.sendRedirect("LoginPage.html");
            return;
        }

        if (!"admin".equals(currentUser.getUsername())) {
            response.sendRedirect("Lobby.jsp");
            return;
        }

        String userToDelete = request.getParameter("usernameToDelete");

        @SuppressWarnings("unchecked")
        List<User> userList = (List<User>) getServletContext().getAttribute("globalUserList");

        if (userList != null && userToDelete != null) {
            if (!currentUser.getUsername().equals(userToDelete)) {

                userList.removeIf(u -> u.getUsername().equals(userToDelete));

                DataHandler.saveUserList(userList);
            }
        }

        response.sendRedirect("AdminPage.jsp");
    }
}