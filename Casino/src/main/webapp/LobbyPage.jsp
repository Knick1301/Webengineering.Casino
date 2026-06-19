<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>

<% 
    User user = (User) session.getAttribute("currentUser");
    if (user == null) { 
        response.sendRedirect("LoginPage.html"); 
        return; 
    } 
%>

<!doctype html>
<html lang="de">
<head>
    <meta charset="UTF-8" />
    <title>Casino - Main Lobby</title>
    <link rel="stylesheet" href="jsp-style.css"/>
</head>
<body class="lobby">
    <div class="container">
        <h1>Willkommen, <%= user.getUsername() %>!</h1>
        <h2>Dein Guthaben: <strong class="textGreen"><%= user.getBalance() %> Chips</strong></h2>

        <a href="BlackjackPage.jsp" class="gameLink">
            🃏 Blackjack
        </a>
        <a href="SlotPage.jsp" class="gameLink">
            🎰 Slotmachine
        </a>

        <div class="actionContainer">
            <% if ("admin".equals(user.getUsername())) { %>
                <a href="AdminPage.jsp" id="lobbyLogout" class="logoutBtn">
                    Nutzerverwaltung
                </a>
            <% } %>
            <a href="LogoutServlet" class="logoutBtn">
                Abmelden
            </a>
        </div>
    </div>
</body>
</html>