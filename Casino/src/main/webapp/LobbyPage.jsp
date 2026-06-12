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
    <style>
        body { background: #0f171c; color: white; font-family: system-ui, sans-serif; display: flex; flex-direction: column; align-items: center; justify-content: center; min-height: 100vh; margin: 0; }
        .container { background: rgba(255, 255, 255, 0.1); padding: 3rem; border-radius: 24px; backdrop-filter: blur(10px); border: 1px solid rgba(252, 194, 61, 0.3); text-align: center; width: 90%; max-width: 500px; }
        h1 { color: #fcc23d; font-size: 2.5rem; margin-bottom: 0.2rem; }
        h2 { color: #fff; font-size: 1.5rem; margin-top: 0; font-weight: 300; margin-bottom: 2rem; }
        
        .game-link { display: block; background: rgba(0,0,0,0.3); padding: 20px; border-radius: 15px; margin: 15px 0; border: 1px solid #4d5a60; color: white; text-decoration: none; font-size: 1.5rem; font-weight: bold; transition: 0.3s; }
        .game-link:hover { background: rgba(252, 194, 61, 0.2); border-color: #fcc23d; transform: translateY(-3px); }
        
        .logout-btn { margin-top: 2rem; display: inline-block; padding: 10px 20px; color: #fcc23d; text-decoration: none; border: 1px solid #fcc23d; border-radius: 8px; transition: 0.3s; }
        .logout-btn:hover { background: #fcc23d; color: #0f171c; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Willkommen, <%= user.getUsername() %>!</h1>
        <h2>Dein Guthaben: <strong style="color: #4CAF50;"><%= user.getBalance() %> Chips</strong></h2>

        <a href="BlackjackPage.jsp" class="game-link">🃏 Blackjack</a>
        <a href="SlotPage.jsp" class="game-link">🎰 Slotmaschine</a>

        <a href="LogoutServlet" class="logout-btn">Abmelden</a>
    </div>
</body>
</html>