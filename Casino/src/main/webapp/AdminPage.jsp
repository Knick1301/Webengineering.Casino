<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:if test="${empty sessionScope.currentUser}">
    <c:redirect url="LoginPage.html" />
</c:if>

<c:if test="${sessionScope.currentUser.username != 'admin'}">
    <c:redirect url="LobbyPage.jsp" />
</c:if>

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
        <p>Hier kannst du Spieler aus dem Casino verwalten.</p>

        <ul class="userList">
            <c:if test="${not empty applicationScope.globalUserList}">
                <c:forEach var="u" items="${applicationScope.globalUserList}">
                    <li class="userItem">
                        <div class="userInfo">
                            <span class="userName">${u.username}</span>
                            <form action="UpdateBalanceServlet" method="POST" >
                                <input type="hidden" name="username" value="${u.username}">
                                <input type="number" name="newBalance" value="${u.balance}" class="updateBalance">
                                <button type="submit" class="updateBalanceBtn">OK</button>
                            </form>
                        </div>
                        
                        <c:choose>
                            <c:when test="${u.username != sessionScope.currentUser.username}">
                                <form action="DeleteUserServlet" method="POST" class="deleteUserForm">
                                    <input type="hidden" name="usernameToDelete" value="${u.username}">
                                    <button type="submit" class="deleteBtn">Löschen</button>
                                </form>
                            </c:when>
                            <c:otherwise>
                                <span class="deleteUserSpan">(Du)</span>
                            </c:otherwise>
                        </c:choose>
                    </li>
                </c:forEach>
            </c:if>
        </ul>

        <a href="LobbyPage.jsp" class="backBtn">Zurück zur Lobby</a>
    </div>
    <jsp:include page="footer.jsp" />
</body>
</html>