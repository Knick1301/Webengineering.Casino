package servlet;

import model.User;
import slot.SlotMachine;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/SlotServlet")
public class SlotServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("currentUser");

        if (user == null) {
            response.sendRedirect("LoginPage.html");
            return;
        }

        try {
            int betAmount = Integer.parseInt(request.getParameter("betAmount"));

            if (user.getBalance() >= betAmount && betAmount > 0) {
                user.deductBalance(betAmount);

                SlotMachine slotMachine = new SlotMachine(betAmount);
                slotMachine.spin();

                if (slotMachine.getPayout() > 0) {
                    user.addBalance(slotMachine.getPayout());
                }

                session.setAttribute("slotMachine", slotMachine);
                session.setAttribute("justSpun", true);
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }

        response.sendRedirect("SlotPage.jsp");
    }
}