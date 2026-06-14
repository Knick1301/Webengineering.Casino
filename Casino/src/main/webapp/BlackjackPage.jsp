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
        for(List<Card> h : game.getPlayerHands()) { currentTotalPlayerCards += h.size(); }
        currentTotalDealerCards = game.getDealerHand().size();
        
        if (prevPlayerCount == null || currentTotalPlayerCards < prevPlayerCount || (currentTotalPlayerCards == 2 && game.getPlayerHands().size() == 1 && !game.isGameOver())) {
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
    <style>
        body { background-image: url('images/blackjackbackground.jpeg');             background-size: 100%; 
            background-position: center;
            background-repeat: no-repeat; color: white; font-family: system-ui, sans-serif; display: flex; flex-direction: column; align-items: center; min-height: 100vh; margin: 0; }
        .container { 
            background: #272e33;
            padding: 2rem;
            width:100%;
            padding-top: 0px;
            border-radius: 24px; 
            backdrop-filter: blur(10px); 
            border: 1px solid rgba(252, 194, 61, 0.3); 
            text-align: center; 
            max-width: 1000px;
            margin-top: 2rem; 
        }
        h1 { color: #fcc23d; font-size: 2.5rem; margin-bottom: 0.2rem; }
        h2 { color: #fff; font-size: 1.5rem; margin-top: 0; font-weight: 300; }
        
        .gameBox { 
            background-image: url('images/BlackjackTable.png'); 
            background-size: 100%; 
            background-position: center;
            background-repeat: no-repeat;
            width: 100%;
            min-height: 500px;
            padding: 20px; 
            box-sizing: border-box;
            border: none;
            background-color: transparent;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            text-shadow: 1px 1px 3px rgba(0,0,0,0.8);
            overflow: hidden;
        }
        .gameBox h3 { 
            margin: 0 0 5px 0 !important;
        }

        .gameBox .hand { 
            margin: 5px 0 !important;
            gap: 5px !important;
        }

        .gameBox hr { 
            margin: 10px 0 !important;
            width: 60%; 
        }

        .gameBox p { 
            margin: 15px 0 0 0 !important;
            font-size: 1.2rem;
        }
        .hand { display: flex; gap: 10px; justify-content: center; }
        
        @keyframes dealCard {
            0% { transform: translateY(-100px) rotate(-10deg); opacity: 0; }
            100% { transform: translateY(0) rotate(0deg); opacity: 1; }
        }

        .card { 
            width: 50px; height: 70px; background: white; color: black; border-radius: 6px; 
            display: flex; flex-direction: column; align-items: center; justify-content: center; 
            font-weight: bold; border: 1px solid #ccc; box-shadow: 2px 2px 5px rgba(0,0,0,0.5);
            text-shadow: none;
        }
        
        .animateIn { opacity: 0; animation: dealCard 0.4s ease-out forwards; }
        .card.hidden { background: #4d5a60; color: #fcc23d; border: 1px solid #fcc23d; }
        .red { color: #d32f2f; }
        .logoutBtn { margin-top: 1rem; display: inline-block; padding: 10px 20px; color: #fcc23d; text-decoration: none; border: 1px solid #fcc23d; border-radius: 8px; transition: 0.3s; }
        .logoutBtn:hover { background: #fcc23d; color: #0f171c; }
        .actionBtn { padding: 8px 16px; cursor: pointer; margin: 5px; border-radius: 6px; border: none; font-weight: bold; background: white; color: black; transition: 0.2s; }
        .actionBtn:hover { background: #fcc23d; }
        .actionBtn:disabled { opacity: 0.5; cursor: not-allowed; }
        .betInput { padding: 10px; border-radius: 6px; border: 1px solid #fcc23d; background: #0f171c; color: #fcc23d; font-weight: bold; font-size: 1.1rem; width: 100px; text-align: center; margin-right: 10px; }
        
        .controlsBox { margin-top: 20px; padding: 15px; background: rgba(0,0,0,0.4); border-radius: 12px; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Willkommen, <%= user.getUsername() %>!</h1>
        <h2>Guthaben: <strong style="color: #4CAF50;"><%= user.getBalance() %> Chips</strong></h2>

        <% if (game != null) { %>
            <div class="gameBox">
                <h3 style="margin-bottom: 5px; color: #fff;">Dealer</h3>
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
                            <div class="card hidden <%= isNewCard ? "animateIn" : "" %>" style="animation-delay: <%= delay %>s;">?</div>
                    <%  } else { 
                            Card card = dHand.get(i);
                            String suitSymbol = "";
                            String colorClass = "";
                            switch(card.getSuit()) {
                                case "Hearts": suitSymbol = "♥"; colorClass = "red"; break;
                                case "Diamonds": suitSymbol = "♦"; colorClass = "red"; break;
                                case "Clubs": suitSymbol = "♣"; break;
                                case "Spades": suitSymbol = "♠"; break;
                            }
                    %>
                            <div class="card <%= colorClass %> <%= isNewCard ? "animateIn" : "" %>" style="animation-delay: <%= delay %>s;">
                                <span style="font-size: 0.8rem;"><%= card.getRank() %></span>
                                <span style="font-size: 1.2rem;"><%= suitSymbol %></span>
                            </div>
                    <%  } 
                    } %>
                </div>
                
                <hr style="border: 0; border-top: 1px solid rgba(255,255,255,0.2); margin: 20px 0;">

                <% 
                List<List<Card>> hands = game.getPlayerHands();
                for (int i = 0; i < hands.size(); i++) { 
                    boolean isActive = (!game.isGameOver() && i == game.getCurrentHandIndex());
                    List<Card> currentHand = hands.get(i);
                %>
                    <h3 style="<%= isActive ? "color: #fcc23d; margin-bottom: 5px;" : "color: #fff; margin-bottom: 5px;" %>">
                        <%= hands.size() > 1 ? "Hand " + (i + 1) : "Deine Karten" %> 
                        <%= isActive ? "(Am Zug)" : "" %>
                    </h3>
                    
                    <div class="hand">
                        <% for (int j = 0; j < currentHand.size(); j++) { 
                            renderedPlayerCards++;
                            boolean isNewCard = (renderedPlayerCards > prevPlayerCount);
                            double delay = isNewCard ? (renderedPlayerCards - prevPlayerCount) * 0.2 : 0;
                            
                            Card card = currentHand.get(j);
                            String suitSymbol = "";
                            String colorClass = "";
                            switch(card.getSuit()) {
                                case "Hearts": suitSymbol = "♥"; colorClass = "red"; break;
                                case "Diamonds": suitSymbol = "♦"; colorClass = "red"; break;
                                case "Clubs": suitSymbol = "♣"; break;
                                case "Spades": suitSymbol = "♠"; break;
                            }
                        %>
                            <div class="card <%= colorClass %> <%= isNewCard ? "animateIn" : "" %>" style="animation-delay: <%= delay %>s;">
                                <span style="font-size: 0.8rem;"><%= card.getRank() %></span>
                                <span style="font-size: 1.2rem;"><%= suitSymbol %></span>
                            </div>
                        <% } %>
                    </div>
                    
                    <p style="margin-top: 0;"> <strong>Score: </strong> <strong style="color: #fcc23d;"><%= game.calculateScore(currentHand) %></strong></p>
                    
                <% } %>
            </div>

            <% if (game.isGameOver()) { %>
                <div style="margin: 10px 0; padding: 15px; background: rgba(252, 194, 61, 0.15); border-radius: 8px; border: 1px solid #fcc23d;">
                    <% for (String result : game.getResults()) { %>
                        <p style="color: #fcc23d; font-weight: bold; font-size: 1.2rem; margin: 5px 0;"><%= result %></p>
                    <% } %>
                </div>
            <% } %>

            <div class="controlsBox">
                <form action="BlackjackServlet" method="POST" style="margin: 0;">
                    <% if (!game.isGameOver()) { 
                        List<Card> currentActiveHand = game.getPlayerHands().get(game.getCurrentHandIndex());
                    %>
                        <p style="color: #ccc; margin-top: 0; margin-bottom: 10px;">Aktueller Einsatz: <strong style="color: white;"><%= game.getCurrentBet() %> Chips</strong></p>
                        <button type="submit" class="actionBtn" name="action" value="hit">Karte ziehen</button>
                        <button type="submit" class="actionBtn" name="action" value="stand">Halten</button>
                        
                        <% if (currentActiveHand.size() == 2 && user.getBalance() >= game.getCurrentBet()) { %>
                            <button type="submit" class="actionBtn" name="action" value="double">Verdoppeln</button>
                        <% } %>

                        <% if (game.canSplit() && user.getBalance() >= game.getCurrentBet()) { %>
                            <button type="submit" class="actionBtn" name="action" value="split">Split</button>
                        <% } %>
                    <% } else { %>
                        <div style="display: flex; justify-content: center; align-items: center;">
                            <input type="number" name="betAmount" class="betInput" min="1" max="<%= user.getBalance() %>" value="<%= game.getCurrentBet() %>" required>
                            <button type="submit" class="actionBtn" name="action" value="start" style="background: #fcc23d; color: #0f171c;">Neues Spiel</button>
                        </div>
                    <% } %>
                </form>
            </div>
            
        <% } else { %>
            <div class="controlsBox" style="margin-top: 40px;">
                <form action="BlackjackServlet" method="POST" style="display: flex; justify-content: center; align-items: center; flex-direction: column; margin: 0;">
                    <label style="margin-bottom: 15px; font-weight: bold; font-size: 1.2rem;">Dein Einsatz:</label>
                    <div style="display: flex;">
                        <input type="number" name="betAmount" class="betInput" min="1" max="<%= user.getBalance() %>" value="50" required>
                        <button type="submit" class="actionBtn" name="action" value="start" style="background: #fcc23d; color: #0f171c;">Blackjack starten</button>
                    </div>
                </form>
            </div>
        <% } %>

        <div style="margin-top: 2rem; display: flex; gap: 15px; justify-content: center;">
            <a href="LobbyPage.jsp" class="logoutBtn" style="margin-top: 0;">Zurück zur Lobby</a>
            <a href="LogoutServlet" class="logoutBtn" style="margin-top: 0;">Abmelden</a>
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