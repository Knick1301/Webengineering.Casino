<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%@ page import="slot.SlotMachine" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Random" %>

<% 
    User user = (User) session.getAttribute("currentUser");
    if (user == null) { 
        response.sendRedirect("LoginPage.html"); 
        return; 
    } 
    SlotMachine slot = (SlotMachine) session.getAttribute("slotMachine");
    
    Boolean justSpunObj = (Boolean) session.getAttribute("justSpun");
    boolean hasJustSpun = (justSpunObj != null && justSpunObj);
    session.removeAttribute("justSpun");
    
    String[] allSymbols = {"🍒", "🍋", "🍊", "🔔", "💎", "7️⃣", "🍉", "🍇", "⭐", "🍀"};
    Random rand = new Random();
%>

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
                <span class="textGreen"><%= user.getBalance() %> Chips</span>
            </strong>
        </h2>

        <div class="gameBox">
            <div class="slotMachine">
                <div class="winLine"></div>
                <% 
                if (hasJustSpun && slot.getCurrentReels() != null && !slot.getCurrentReels().isEmpty()) { 
                    List<String> reels = slot.getCurrentReels();
                    
                    for (int i = 0; i < reels.size(); i++) {
                        String finalSymbol = reels.get(i);
                        double duration = 1.5 + (i * 1.0);
                %>
                        <div class="reelContainer">
                            <div class="strip" style="animation: spinReel <%= duration %>s cubic-bezier(0.15, 0.9, 0.25, 1) forwards;">
                                <% for(int k = 0; k < 28; k++) { %>
                                    <div class="symbol"><%= allSymbols[rand.nextInt(allSymbols.length)] %></div>
                                <% } %>
                                <div class="symbol"><%= finalSymbol %></div>
                                <div class="symbol"><%= allSymbols[rand.nextInt(allSymbols.length)] %></div>
                            </div>
                        </div>
                <%  } 
                } else { %>
                    <% for(int i = 0; i < 4; i++) { 

                        String topSymbol = "❓";
                        String centerSymbol = "❓";
                        String bottomSymbol = "❓";
                        

                        if(slot != null && slot.getCurrentReels() != null && slot.getCurrentReels().size() > i) {
                            topSymbol = allSymbols[rand.nextInt(allSymbols.length)];
                            centerSymbol = slot.getCurrentReels().get(i);
                            bottomSymbol = allSymbols[rand.nextInt(allSymbols.length)];
                        }
                    %>
                        <div class="reelContainer">
                            <div class="strip">
                                <div class="symbol"><%= topSymbol %></div>
                                <div class="symbol"><%= centerSymbol %></div>
                                <div class="symbol"><%= bottomSymbol %></div>
                            </div>
                        </div>
                    <% } %>
                <% } %>
            </div>

            <div class="resultBox" <%= hasJustSpun ? "style='opacity: 0; animation: fadeInResult 0.3s ease forwards 4.5s;'" : "" %>>
                <% if (slot != null && slot.getPayout() >= 0) { %>
                    <p class="resultMsg"><%= slot.getResultMessage() %></p>
                    <% if (slot.getPayout() > 0) { %>
                        <p class="payoutMsg">+ <%= slot.getPayout() %> Chips gewonnen!</p>
                    <% } else { %>
                        <p class="resultChips">- <%= slot.getBetAmount() %> Chips</p>
                    <% } %>
                <% } else { %>
                    <p class="slotParagraph">Wähle deinen Einsatz und drehe die Walzen!</p>
                <% } %>
            </div>

            <form action="SlotServlet" method="POST" class="display: flex; justify-content: center; align-items: center; margin-top: 20px;">
                <label for="betAmount" class="labelBetAmount">Einsatz:</label>
                <input type="number" id="betAmount" name="betAmount" class="betInput" min="1" max="<%= user.getBalance() %>" value="<%= slot != null ? slot.getBetAmount() : 10 %>" required>
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
            const isSpinning = <%= hasJustSpun %>;
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