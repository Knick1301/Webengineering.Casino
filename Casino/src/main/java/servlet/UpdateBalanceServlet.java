package servlet;

import model.User;
import util.DataHandler;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/UpdateBalanceServlet")
public class UpdateBalanceServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");

        if (currentUser == null || !"admin".equals(currentUser.getUsername())) {
            response.sendRedirect("Lobby.jsp");
            return;
        }

        String username = request.getParameter("username");
        int newBalance = Integer.parseInt(request.getParameter("newBalance"));

        @SuppressWarnings("unchecked")
        List<User> userList = (List<User>) getServletContext().getAttribute("globalUserList");

        if (userList != null) {
            for (User u : userList) {
                if (u.getUsername().equals(username)) {
                    u.setBalance(newBalance);
                    break;
                }
            }
            DataHandler.saveUserList(userList);
        }
        response.sendRedirect("AdminPage.jsp");
    }
}