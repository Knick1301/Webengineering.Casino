package servlet;

import blackjack.BlackjackGame;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/BlackjackServlet")
public class BlackjackServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        BlackjackGame game = (BlackjackGame) session.getAttribute("blackjackGame");


        if (game == null) {
            game = new BlackjackGame();
            session.setAttribute("blackjackGame", game);
        }

        String action = request.getParameter("action");

        if ("hit".equals(action)) {
            game.playerHit();
        } else if ("stand".equals(action)) {
            game.stand();
        } else if ("reset".equals(action)) {
            game = new BlackjackGame();
            session.setAttribute("blackjackGame", game);
        }else if("double".equals(action)){
            game.doubleDown();
        } else if ("split".equals(action)){
            game.split();
        }


        response.sendRedirect("CasinoPage.jsp");
    }
}