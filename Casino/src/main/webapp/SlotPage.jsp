<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<c:if test="${empty sessionScope.currentUser}">
    <c:redirect url="LoginPage.html" />
</c:if>

<%-- Session-Flag auslesen, lokal speichern und danach aufräumen, um Endlos-Animationen zu verhindern --%>
<c:set var="isSpinning" value="${not empty sessionScope.justSpun and sessionScope.justSpun}" scope="page" />
<c:remove var="justSpun" scope="session" />

<%-- Definition der Symbole für die Pseudo-Zufalls-Mathematik --%>
<c:set var="uniqueSymbols" value="🍒,🍋,🍊,🔔,💎,7️⃣,🍉,🍇,⭐,🍀" />
<c:set var="symbols" value="${fn:split(uniqueSymbols, ',')}" />

<%-- Eine künstliche Kette aus 27 Symbolen für den "Dreh-Effekt" der CSS-Animation --%>
<c:set var="fillerString" value="🍒,🍋,🍊,🔔,💎,7️⃣,🍉,🍇,⭐,🍀,🍋,🍉,💎,🍒,🔔,⭐,🍇,🍀,7️⃣,🍊,🍉,🍒,💎,⭐,🍋,🔔,🍇" />
<c:set var="fillers" value="${fn:split(fillerString, ',')}" />

<!doctype html>
<html lang="de">
<head>
    <meta charset="UTF-8" />
    <title>Casino - Slotmaschine</title>
    <link rel="stylesheet" href="jsp-style.css"/>
</head>
<body class="slot">
    <div class="container">
        <h1>Slotmaschine</h1>
        <h2>Guthaben: 
            <strong>
                <span class="textGreen">${sessionScope.currentUser.balance} Chips</span>
            </strong>
        </h2>

        <div class="gameBox">
            <div class="slotMachine">
                <div class="winLine"></div>
                
                <c:choose>
                    <c:when test="${isSpinning and not empty sessionScope.slotMachine.currentReels}">
                        <c:forEach var="finalSymbol" items="${sessionScope.slotMachine.currentReels}" varStatus="status">
                            <c:set var="duration" value="${1.5 + (status.index * 1.0)}" />
                            
                            <%-- Erzeugt einen mathematischen Pseudo-Zufall basierend auf der Walzennummer (0 bis 3) --%>
                            <c:set var="topIndex" value="${(status.index * 3 + 5) % 10}" />
                            <c:set var="bottomIndex" value="${(status.index * 7 + 2) % 10}" />
                            
                            <div class="reelContainer">
                                <div class="strip" style="animation: spinReel ${duration}s cubic-bezier(0.15, 0.9, 0.25, 1) forwards;">
                                    <%-- Die Füller-Symbole durchlaufen, damit das CSS Platz zum Scrollen hat --%>
                                    <c:forEach var="sym" items="${fillers}">
                                        <div class="symbol">${sym}</div>
                                    </c:forEach>
                                    
                                    <%-- Das pseudo-zufällige Symbol für OBEN --%>
                                    <div class="symbol">${symbols[topIndex]}</div>
                                    
                                    <%-- Das tatsächliche Gewinnsymbol, bei dem die Walze stoppt (MITTE) --%>
                                    <div class="symbol">${finalSymbol}</div>
                                    
                                    <%-- Das pseudo-zufällige Symbol für UNTEN --%>
                                    <div class="symbol">${symbols[bottomIndex]}</div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <%-- Anzeige nach dem Neuladen der Seite (wenn nicht mehr gedreht wird) --%>
                        <c:forEach var="reel" items="${sessionScope.slotMachine.currentReels}" varStatus="status">
                            <c:set var="topIndex" value="${(status.index * 3 + 5) % 10}" />
                            <c:set var="bottomIndex" value="${(status.index * 7 + 2) % 10}" />
                            
                            <div class="reelContainer">
                                <div class="strip">
                                    <div class="symbol">${not empty reel ? symbols[topIndex] : '❓'}</div>
                                    <div class="symbol">${not empty reel ? reel : '❓'}</div>
                                    <div class="symbol">${not empty reel ? symbols[bottomIndex] : '❓'}</div>
                                </div>
                            </div>
                        </c:forEach>
                        
                        <%-- Fallback, falls das Spiel komplett neu gestartet wird und noch keine Walzen existieren --%>
                        <c:if test="${empty sessionScope.slotMachine.currentReels}">
                            <c:forEach begin="0" end="3">
                                <div class="reelContainer">
                                    <div class="strip">
                                        <div class="symbol">❓</div>
                                        <div class="symbol">❓</div>
                                        <div class="symbol">❓</div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:if>
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="resultBox" ${isSpinning ? "style='opacity: 0; animation: fadeInResult 0.3s ease forwards 4.5s;'" : ""}>
                <c:choose>
                    <c:when test="${not empty sessionScope.slotMachine and sessionScope.slotMachine.payout >= 0}">
                        <p class="resultMsg">${sessionScope.slotMachine.resultMessage}</p>
                        <c:choose>
                            <c:when test="${sessionScope.slotMachine.payout > 0}">
                                <p class="payoutMsg">+ ${sessionScope.slotMachine.payout} Chips gewonnen!</p>
                            </c:when>
                            <c:otherwise>
                                <p class="resultChips">- ${sessionScope.slotMachine.betAmount} Chips</p>
                            </c:otherwise>
                        </c:choose>
                    </c:when>
                    <c:otherwise>
                        <p class="slotParagraph">Wähle deinen Einsatz und drehe die Walzen!</p>
                    </c:otherwise>
                </c:choose>
            </div>

            <form action="SlotServlet" method="POST" style="display: flex; justify-content: center; align-items: center; margin-top: 20px;">
                <label for="betAmount" class="labelBetAmount">Einsatz:</label>
                <input type="number" id="betAmount" name="betAmount" class="betInput" min="1" 
                       max="${sessionScope.currentUser.balance}" 
                       value="${not empty sessionScope.slotMachine ? sessionScope.slotMachine.betAmount : 10}" required>
                <button type="submit" id="spinBtn" class="actionBtn">SPIN 🎰</button>
            </form>
        </div>

        <div class="divExit">
            <a href="LobbyPage.jsp" class="logoutBtn">Zurück zur Lobby</a>
            <a href="LogoutServlet" class="logoutBtn">Abmelden</a>
        </div>
    </div>
    
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            const isSpinning = ${isSpinning};
            const spinBtn = document.getElementById("spinBtn");
            
            if (isSpinning && spinBtn) {
                spinBtn.disabled = true;
                setTimeout(() => {
                    spinBtn.disabled = false;
                }, 4500);
            }
        });
    </script>
</body>
</html>