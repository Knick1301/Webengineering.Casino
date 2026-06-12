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

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String usernameInput = request.getParameter("regUsername");
        String passwordInput = request.getParameter("regPassword");
        String passwordConfirm = request.getParameter("regPasswordConfirm");


        if (!passwordInput.equals(passwordConfirm)) {
            response.sendRedirect("RegisterPage.html?error=mismatch");
            return;
        }


        @SuppressWarnings("unchecked")
        List<User> userList = (List<User>) getServletContext().getAttribute("globalUserList");

        if (userList != null) {

            for (User u : userList) {
                if (u.getUsername().equals(usernameInput)) {
                    response.sendRedirect("RegisterPage.html?error=exists");
                    return;
                }
            }

            int newId = userList.size() + 1;
            User newUser = new User(newId, usernameInput, passwordInput);


            newUser.setMoney("1000");


            userList.add(newUser);


            DataHandler.saveUserList(userList);


            response.sendRedirect("LoginPage.html");
        }
    }
}