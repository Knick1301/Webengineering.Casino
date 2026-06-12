package servlet;

import blackjack.BlackjackGame;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/BlackjackServlet")
public class BlackjackServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("currentUser");
        BlackjackGame game = (BlackjackGame) session.getAttribute("blackjackGame");

        if (user == null) {
            response.sendRedirect("LoginPage.html");
            return;
        }

        String action = request.getParameter("action");

        if ("start".equals(action)) {
            int betAmount = Integer.parseInt(request.getParameter("betAmount"));
            if (user.getBalance() >= betAmount && betAmount > 0) {
                user.deductBalance(betAmount);
                game = new BlackjackGame(betAmount);
                session.setAttribute("blackjackGame", game);
            }
        } else if (game != null && !game.isGameOver()) {
            boolean wasGameOver = game.isGameOver();
            int currentHandBet = game.getHandBets().get(game.getCurrentHandIndex());

            if ("hit".equals(action)) {
                game.playerHit();
            } else if ("stand".equals(action)) {
                game.stand();
            } else if ("double".equals(action)) {
                if (user.getBalance() >= currentHandBet) {
                    user.deductBalance(currentHandBet);
                    game.doubleDown();
                }
            } else if ("split".equals(action)) {
                if (user.getBalance() >= currentHandBet) {
                    user.deductBalance(currentHandBet);
                    game.split();
                }
            }

            if (!wasGameOver && game.isGameOver()) {
                int dealerScore = game.calculateScore(game.getDealerHand());
                List<List<blackjack.Card>> hands = game.getPlayerHands();
                List<Integer> bets = game.getHandBets();

                for (int i = 0; i < hands.size(); i++) {
                    int playerScore = game.calculateScore(hands.get(i));
                    int bet = bets.get(i);

                    if (playerScore <= 21) {
                        if (dealerScore > 21 || playerScore > dealerScore) {
                            user.addBalance(bet * 2);
                        } else if (playerScore == dealerScore) {
                            user.addBalance(bet);
                        }
                    }
                }
            }
        }

        response.sendRedirect("BlackjackPage.jsp");
    }
}