<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<c:if test="${empty sessionScope.currentUser}">
    <c:redirect url="LoginPage.html" />
</c:if>

<!doctype html>
<html lang="de">
<head>
    <meta charset="UTF-8" />
    <title>Casino - Blackjack</title>
    <link rel="stylesheet" href="jsp-style.css"/>
</head>
<body class="blackjack">
<div class="container">
    <h1>Willkommen, ${sessionScope.currentUser.username}!</h1>
    <h2>
        Guthaben:
        <strong class="textGreen">${sessionScope.currentUser.balance} Chips</strong>
    </h2>

    <c:if test="${not empty sessionScope.blackjackGame}">
    <div class="gameBox">
        <h3 class="dealerTitle">Dealer</h3>

        <div class="hand">
            <c:forEach var="card" items="${sessionScope.blackjackGame.dealerHand}" varStatus="loop">
                <c:choose>
                    <c:when test="${not sessionScope.blackjackGame.gameOver and loop.index == 1}">
                        <div class="card hidden">?</div>
                    </c:when>
                    <c:otherwise>
                        <c:set var="colorClass" value="${(card.suit == 'Hearts' or card.suit == 'Diamonds') ? 'red' : ''}" />
                        <c:set var="suitSymbol" value="" />
                        <c:choose>
                            <c:when test="${card.suit == 'Hearts'}"><c:set var="suitSymbol" value="♥" /></c:when>
                            <c:when test="${card.suit == 'Diamonds'}"><c:set var="suitSymbol" value="♦" /></c:when>
                            <c:when test="${card.suit == 'Clubs'}"><c:set var="suitSymbol" value="♣" /></c:when>
                            <c:when test="${card.suit == 'Spades'}"><c:set var="suitSymbol" value="♠" /></c:when>
                        </c:choose>
                        
                        <div class="card ${colorClass}">
                            <span class="cardRank">${card.rank}</span>
                            <span class="cardSuit">${suitSymbol}</span>
                        </div>
                    </c:otherwise>
                </c:choose>
            </c:forEach>
        </div>

        <hr class="divider">

        <div class="handsRow">
            <c:forEach var="currentHand" items="${sessionScope.blackjackGame.playerHands}" varStatus="handLoop">
                <c:set var="isActive" value="${not sessionScope.blackjackGame.gameOver and handLoop.index == sessionScope.blackjackGame.currentHandIndex}" />
                
                <div class="handCol">
                    <h3 class="playerTitle ${isActive ? 'isActive' : ''}">
                        ${fn:length(sessionScope.blackjackGame.playerHands) > 1 ? 'Hand ' += (handLoop.index + 1) : 'Deine Karten'}
                        ${isActive ? '(Am Zug)' : ''}
                    </h3>

                    <div class="hand">
                        <c:forEach var="card" items="${currentHand}">
                            <c:set var="colorClass" value="${(card.suit == 'Hearts' or card.suit == 'Diamonds') ? 'red' : ''}" />
                            <c:set var="suitSymbol" value="" />
                            <c:choose>
                                <c:when test="${card.suit == 'Hearts'}"><c:set var="suitSymbol" value="♥" /></c:when>
                                <c:when test="${card.suit == 'Diamonds'}"><c:set var="suitSymbol" value="♦" /></c:when>
                                <c:when test="${card.suit == 'Clubs'}"><c:set var="suitSymbol" value="♣" /></c:when>
                                <c:when test="${card.suit == 'Spades'}"><c:set var="suitSymbol" value="♠" /></c:when>
                            </c:choose>

                            <div class="card ${colorClass}">
                                <span class="cardRank">${card.rank}</span>
                                <span class="cardSuit">${suitSymbol}</span>
                            </div>
                        </c:forEach>
                    </div>

                    <p class="scoreLine">
                        <strong>Score: </strong>
                        <strong class="scoreValue">${sessionScope.blackjackGame.calculateScore(currentHand)}</strong>
                    </p>
                </div>
            </c:forEach>
        </div>
    </div>

    <c:if test="${sessionScope.blackjackGame.gameOver}">
        <div class="gameOverBox">
            <c:forEach var="result" items="${sessionScope.blackjackGame.results}">
                <p class="gameOverMsg">${result}</p>
            </c:forEach>
        </div>
    </c:if>

    <div class="controlsBox">
        <form action="BlackjackServlet" method="POST" class="formReset">
            <c:choose>
                <c:when test="${not sessionScope.blackjackGame.gameOver}">
                    <p class="currentBetText">
                        Aktueller Einsatz:
                        <strong class="currentBetValue">${sessionScope.blackjackGame.currentBet} Chips</strong>
                    </p>

                    <button type="submit" class="actionBtn" name="action" value="hit">Karte ziehen</button>
                    <button type="submit" class="actionBtn" name="action" value="stand">Halten</button>

                    <c:if test="${fn:length(sessionScope.blackjackGame.playerHands[sessionScope.blackjackGame.currentHandIndex]) == 2 and sessionScope.currentUser.balance >= sessionScope.blackjackGame.currentBet}">
                        <button type="submit" class="actionBtn" name="action" value="double">Verdoppeln</button>
                    </c:if>

                    <c:if test="${sessionScope.blackjackGame.canSplit() and sessionScope.currentUser.balance >= sessionScope.blackjackGame.currentBet}">
                        <button type="submit" class="actionBtn" name="action" value="split">Split</button>
                    </c:if>
                </c:when>
                <c:otherwise>
                    <div class="controlsRow">
                        <input type="number" name="betAmount" class="betInput"
                               min="1" max="${sessionScope.currentUser.balance}"
                               value="${sessionScope.blackjackGame.currentBet}" required>

                        <button type="submit" class="actionBtn btnNewGame" name="action" value="start">
                            Neues Spiel
                        </button>
                    </div>
                </c:otherwise>
            </c:choose>
        </form>
    </div>
    </c:if>

    <c:if test="${empty sessionScope.blackjackGame}">
    <div class="controlsBox startBox">
        <form action="BlackjackServlet" method="POST" class="startForm">
            <label class="startLabel">Dein Einsatz:</label>

            <div class="startRow">
                <input type="number" name="betAmount" class="betInput"
                       min="1" max="${sessionScope.currentUser.balance}"
                       value="50" required>

                <button type="submit" class="actionBtn btnStart" name="action" value="start">
                    Spiel starten
                </button>
            </div>
        </form>
    </div>
    </c:if>

    <div class="footerLinks">
        <a href="LobbyPage.jsp" class="logoutBtn noTopMargin">Zurück zur Lobby</a>
        <a href="LogoutServlet" class="logoutBtn noTopMargin">Abmelden</a>
    </div>
</div>
<jsp:include page="footer.jsp" />
</body>

</html>