<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%@ page import="java.util.List" %>

<%
    User currentUser = (User) session.getAttribute("currentUser");
    
    if (currentUser == null) {
        response.sendRedirect("LoginPage.html");
        return;
    }

    if (!"admin".equals(currentUser.getUsername())) {
        response.sendRedirect("Lobby.jsp");
        return;
    }

    @SuppressWarnings("unchecked")
    List<User> userList = (List<User>) application.getAttribute("globalUserList");
%>

<!doctype html>
<html lang="de">
<head>
    <meta charset="UTF-8" />
    <title>Casino - Manager Dashboard</title>
    <style>
        body { background: #0f171c; color: white; font-family: system-ui, sans-serif; display: flex; flex-direction: column; align-items: center; min-height: 100vh; margin: 0; padding-top: 3rem; }
        .container { background: rgba(255, 255, 255, 0.1); padding: 2rem; border-radius: 24px; backdrop-filter: blur(10px); border: 1px solid rgba(252, 194, 61, 0.3); width: 90%; max-width: 600px; text-align: center; }
        h1 { color: #fcc23d; margin-top: 0; }
        
        .userList { list-style: none; padding: 0; margin-top: 20px; text-align: left; }
        .userItem { background: rgba(0,0,0,0.3); margin: 10px 0; padding: 15px; border-radius: 10px; display: flex; justify-content: space-between; align-items: center; border: 1px solid #4d5a60; }
        
        .userInfo { display: flex; flex-direction: column; }
        .userName { font-weight: bold; font-size: 1.2rem; color: white; }
        .userBalance { color: #4CAF50; font-size: 0.9rem; margin-top: 5px; }
        
        .deleteBtn { background: #d32f2f; color: white; border: none; padding: 8px 15px; border-radius: 6px; cursor: pointer; font-weight: bold; transition: 0.2s; }
        .deleteBtn:hover { background: #b71c1c; transform: scale(1.05); }
        
        .backBtn { display: inline-block; margin-top: 20px; padding: 10px 20px; color: #fcc23d; text-decoration: none; border: 1px solid #fcc23d; border-radius: 8px; transition: 0.3s; }
        .backBtn:hover { background: #fcc23d; color: #0f171c; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Manager Dashboard</h1>
        <p style="color: #ccc; margin-bottom: 30px;">Hier kannst du Spieler aus dem Casino verweisen.</p>

        <ul class="userList">
            <% if (userList != null) {
                for (User u : userList) { %>
                    <li class="userItem">
                        <div class="userInfo">
                            <span class="userName"><%= u.getUsername() %></span>
                            <form action="UpdateBalanceServlet" method="POST" style="margin-top: 5px; display: flex; gap: 5px;">
                                <input type="hidden" name="username" value="<%= u.getUsername() %>">
                                <input type="number" name="newBalance" value="<%= u.getBalance() %>" style="width: 80px; background: #000; color: #4CAF50; border: 1px solid #4d5a60; padding: 2px 5px; border-radius: 4px;">
                                <button type="submit" style="background: #fcc23d; border: none; padding: 2px 8px; border-radius: 4px; cursor: pointer; font-weight: bold;">OK</button>
                            </form>
                        </div>
                        
                        <% if (!u.getUsername().equals(currentUser.getUsername())) { %>
                            <form action="DeleteUserServlet" method="POST" style="margin: 0;">
                                <input type="hidden" name="usernameToDelete" value="<%= u.getUsername() %>">
                                <button type="submit" class="deleteBtn">Löschen</button>
                            </form>
                        <% } else { %>
                            <span style="color: #4CAF50; font-weight: bold;">(Du)</span>
                        <% } %>
                    </li>
            <%  }
            } %>
        </ul>

        <a href="LobbyPage.jsp" class="backBtn">Zurück zur Lobby</a>
    </div>
</body>
</html>