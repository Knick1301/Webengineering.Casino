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
    <link rel="stylesheet" href="jsp-style.css"/>
</head>
<body class="admin">
    <div class="container">
        <h1>Manager Dashboard</h1>
        <p>Hier kannst du Spieler aus dem Casino verweisen.</p>

        <ul class="userList">
            <% if (userList != null) {
                for (User u : userList) { %>
                    <li class="userItem">
                        <div class="userInfo">
                            <span class="userName"><%= u.getUsername() %></span>
                            <form action="UpdateBalanceServlet" method="POST" >
                                <input type="hidden" name="username" value="<%= u.getUsername() %>">
                                <input type="number" name="newBalance" value="<%= u.getBalance() %>" class="updateBalance">
                                <button type="submit" class="updateBalanceBtn">OK</button>
                            </form>
                        </div>
                        
                        <% if (!u.getUsername().equals(currentUser.getUsername())) { %>
                            <form action="DeleteUserServlet" method="POST" class="deleteUserForm">
                                <input type="hidden" name="usernameToDelete" value="<%= u.getUsername() %>">
                                <button type="submit" class="deleteBtn">Löschen</button>
                            </form>
                        <% } else { %>
                            <span class="deleteUserSpan">(Du)</span>
                        <% } %>
                    </li>
            <%  }
            } %>
        </ul>

        <a href="LobbyPage.jsp" class="backBtn">Zurück zur Lobby</a>
    </div>
</body>
</html>