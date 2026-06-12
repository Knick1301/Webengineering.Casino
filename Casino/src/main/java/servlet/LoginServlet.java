package servlet;

import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;


@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {


        String usernameInput = request.getParameter("loginUsername");
        String passwordInput = request.getParameter("loginPassword");


        @SuppressWarnings("unchecked")
        List<User> userList = (List<User>) getServletContext().getAttribute("globalUserList");

        User loggedInUser = null;


        if (userList != null) {
            for (User u : userList) {
                if (u.getUsername().equals(usernameInput) && u.getPassword().equals(passwordInput)) {
                    loggedInUser = u;
                    break;
                }
            }
        }


        if (loggedInUser != null) {

            HttpSession session = request.getSession();


            session.setAttribute("currentUser", loggedInUser);


            response.sendRedirect("LobbyPage.jsp");
        } else {

            response.sendRedirect("LoginPage.html?error=true");
        }
    }
}