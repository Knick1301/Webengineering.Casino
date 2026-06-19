<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%@ page import="blackjack.BlackjackGame" %>
<%@ page import="blackjack.Card" %>
<%@ page import="java.util.List" %>

<%
    User user = (User) session.getAttribute("currentUser");
    if (user == null) {
        response.sendRedirect("LoginPage.html");
        return;
    }
    BlackjackGame game = (BlackjackGame) session.getAttribute("blackjackGame");

    Integer prevPlayerCount = (Integer) session.getAttribute("prevPlayerCount");
    Integer prevDealerCount = (Integer) session.getAttribute("prevDealerCount");
    Boolean prevGameOver = (Boolean) session.getAttribute("prevGameOver");

    if (prevGameOver == null) prevGameOver = false;

    int currentTotalPlayerCards = 0;
    int currentTotalDealerCards = 0;

    if (game != null) {
        for (List<Card> h : game.getPlayerHands()) { currentTotalPlayerCards += h.size(); }
        currentTotalDealerCards = game.getDealerHand().size();

        if (prevPlayerCount == null || currentTotalPlayerCards < prevPlayerCount
                || (currentTotalPlayerCards == 2 && game.getPlayerHands().size() == 1 && !game.isGameOver())) {
            prevPlayerCount = 0;
            prevDealerCount = 0;
            prevGameOver = false;
        }
    }

    boolean gameJustEnded = game != null && game.isGameOver() && !prevGameOver;
    int renderedPlayerCards = 0;
    int renderedDealerCards = 0;
%>

<!doctype html>
<html lang="de">
<head>
    <meta charset="UTF-8" />
    <title>Casino - Blackjack</title>
    <link rel="stylesheet" href="jsp-style.css"/>
</head>
<body class="blackjack">
<div class="container">
    <h1>Willkommen, <%= user.getUsername() %>!</h1>
    <h2>
        Guthaben:
        <strong class="textGreen"><%= user.getBalance() %> Chips</strong>
    </h2>

    <% if (game != null) { %>
    <div class="gameBox">
        <h3 class="dealerTitle">Dealer</h3>

        <div class="hand">
            <%
                List<Card> dHand = game.getDealerHand();
                for (int i = 0; i < dHand.size(); i++) {
                    renderedDealerCards++;
                    boolean isHoleCardFlipping = gameJustEnded && i == 1;
                    boolean isNewlyDrawn = renderedDealerCards > prevDealerCount;
                    boolean isNewCard = isHoleCardFlipping || isNewlyDrawn;

                    double delay = 0;
                    if (isHoleCardFlipping) { delay = 0; }
                    else if (isNewlyDrawn) { delay = (renderedDealerCards - prevDealerCount) * 0.2; }

                    if (!game.isGameOver() && i == 1) {
            %>
            <div class="card hidden <%= isNewCard ? "animateIn" : "" %>"
                 style="animation-delay: <%= delay %>s;">?</div>
            <%
            } else {
                Card card = dHand.get(i);
                String suitSymbol = "";
                String colorClass = "";
                switch (card.getSuit()) {
                    case "Hearts": suitSymbol = "♥"; colorClass = "red"; break;
                    case "Diamonds": suitSymbol = "♦"; colorClass = "red"; break;
                    case "Clubs": suitSymbol = "♣"; break;
                    case "Spades": suitSymbol = "♠"; break;
                }
            %>
            <div class="card <%= colorClass %> <%= isNewCard ? "animateIn" : "" %>"
                 style="animation-delay: <%= delay %>s;">
                <span class="cardRank"><%= card.getRank() %></span>
                <span class="cardSuit"><%= suitSymbol %></span>
            </div>
            <%
                    }
                }
            %>
        </div>

        <hr class="divider">

        <div class="handsRow">
            <%
                List<List<Card>> hands = game.getPlayerHands();
                for (int i = 0; i < hands.size(); i++) {
                    boolean isActive = (!game.isGameOver() && i == game.getCurrentHandIndex());
                    List<Card> currentHand = hands.get(i);
            %>
            <div class="handCol">
                <h3 class="playerTitle <%= isActive ? "isActive" : "" %>">
                    <%= hands.size() > 1 ? "Hand " + (i + 1) : "Deine Karten" %>
                    <%= isActive ? "(Am Zug)" : "" %>
                </h3>

                <div class="hand">
                    <%
                        for (int j = 0; j < currentHand.size(); j++) {
                            renderedPlayerCards++;
                            boolean isNewCard = (renderedPlayerCards > prevPlayerCount);
                            double delay = isNewCard ? (renderedPlayerCards - prevPlayerCount) * 0.2 : 0;

                            Card card = currentHand.get(j);
                            String suitSymbol = "";
                            String colorClass = "";
                            switch (card.getSuit()) {
                                case "Hearts": suitSymbol = "♥"; colorClass = "red"; break;
                                case "Diamonds": suitSymbol = "♦"; colorClass = "red"; break;
                                case "Clubs": suitSymbol = "♣"; break;
                                case "Spades": suitSymbol = "♠"; break;
                            }
                    %>
                    <div class="card <%= colorClass %> <%= isNewCard ? "animateIn" : "" %>"
                         style="animation-delay: <%= delay %>s;">
                        <span class="cardRank"><%= card.getRank() %></span>
                        <span class="cardSuit"><%= suitSymbol %></span>
                    </div>
                    <%
                        }
                    %>
                </div>

                <p class="scoreLine">
                    <strong>Score: </strong>
                    <strong class="scoreValue"><%= game.calculateScore(currentHand) %></strong>
                </p>
            </div>
            <%
                }
            %>
        </div>
    </div>

    <% if (game.isGameOver()) { %>
    <div class="gameOverBox">
        <% for (String result : game.getResults()) { %>
        <p class="gameOverMsg"><%= result %></p>
        <% } %>
    </div>
    <% } %>

    <div class="controlsBox">
        <form action="BlackjackServlet" method="POST" class="formReset">
            <% if (!game.isGameOver()) {
                List<Card> currentActiveHand = game.getPlayerHands().get(game.getCurrentHandIndex());
            %>
            <p class="currentBetText">
                Aktueller Einsatz:
                <strong class="currentBetValue"><%= game.getCurrentBet() %> Chips</strong>
            </p>

            <button type="submit" class="actionBtn" name="action" value="hit">Karte ziehen</button>
            <button type="submit" class="actionBtn" name="action" value="stand">Halten</button>

            <% if (currentActiveHand.size() == 2 && user.getBalance() >= game.getCurrentBet()) { %>
            <button type="submit" class="actionBtn" name="action" value="double">Verdoppeln</button>
            <% } %>

            <% if (game.canSplit() && user.getBalance() >= game.getCurrentBet()) { %>
            <button type="submit" class="actionBtn" name="action" value="split">Split</button>
            <% } %>

            <% } else { %>
            <div class="controlsRow">
                <input type="number" name="betAmount" class="betInput"
                       min="1" max="<%= user.getBalance() %>"
                       value="<%= game.getCurrentBet() %>" required>

                <button type="submit" class="actionBtn btnNewGame" name="action" value="start">
                    Neues Spiel
                </button>
            </div>
            <% } %>
        </form>
    </div>

    <% } else { %>
    <div class="controlsBox startBox">
        <form action="BlackjackServlet" method="POST" class="startForm">
            <label class="startLabel">Dein Einsatz:</label>

            <div class="startRow">
                <input type="number" name="betAmount" class="betInput"
                       min="1" max="<%= user.getBalance() %>"
                       value="50" required>

                <button type="submit" class="actionBtn btnStart" name="action" value="start">
                    Spiel starten
                </button>
            </div>
        </form>
    </div>
    <% } %>

    <div class="footerLinks">
        <a href="LobbyPage.jsp" class="logoutBtn noTopMargin">Zurück zur Lobby</a>
        <a href="LogoutServlet" class="logoutBtn noTopMargin">Abmelden</a>
    </div>
</div>
</body>
</html>

<%
    if (game != null) {
        session.setAttribute("prevPlayerCount", currentTotalPlayerCards);
        session.setAttribute("prevDealerCount", currentTotalDealerCards);
        session.setAttribute("prevGameOver", game.isGameOver());
    }
%>
