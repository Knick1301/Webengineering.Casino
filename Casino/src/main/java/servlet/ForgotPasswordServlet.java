package servlet;

import model.User;
import util.DataHandler;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/ForgotPasswordServlet")
public class ForgotPasswordServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String usernameInput = request.getParameter("resetUsername");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");


        if (!newPassword.equals(confirmPassword)) {
            response.sendRedirect("ForgotPasswordPage.html?error=mismatch");
            return;
        }

        @SuppressWarnings("unchecked")
        List<User> userList = (List<User>) getServletContext().getAttribute("globalUserList");

        if (userList != null) {
            for (User u : userList) {
                if (u.getUsername().equals(usernameInput)) {

                    u.setPassword(newPassword);

                    DataHandler.saveUserList(userList);

                    response.sendRedirect("LoginPage.html?success=true");
                    return;
                }
            }
        }


        response.sendRedirect("ForgotPasswordPage.html?error=doesnotexist");
    }
}