<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:if test="${empty sessionScope.currentUser}">
    <c:redirect url="LoginPage.html" />
</c:if>

<!doctype html>
<html lang="de">
<head>
    <meta charset="UTF-8" />
    <title>Casino - Main Lobby</title>
    <link rel="stylesheet" href="jsp-style.css"/>
</head>
<body class="lobby">
    <div class="container">
        <h1>Willkommen, ${sessionScope.currentUser.username}!</h1>
        <h2>Dein Guthaben: <strong class="textGreen">${sessionScope.currentUser.balance} Chips</strong></h2>

        <a href="BlackjackPage.jsp" class="gameLink">
            🃏 Blackjack
        </a>
        <a href="SlotPage.jsp" class="gameLink">
            🎰 Slotmachine
        </a>

        <div class="actionContainer">
            <c:if test="${sessionScope.currentUser.username == 'admin'}">
                <a href="AdminPage.jsp" id="lobbyLogout" class="logoutBtn">
                    Nutzerverwaltung
                </a>
            </c:if>
            <a href="LogoutServlet" class="logoutBtn">
                Abmelden
            </a>
        </div>
    </div>
</body>
</html>