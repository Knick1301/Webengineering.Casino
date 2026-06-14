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
    <style>
         body { background-image: url('images/slotbg2.jpg');             background-size: 100%; 
            background-position: center;
            background-repeat: no-repeat; color: white; font-family: system-ui, sans-serif; display: flex; flex-direction: column; align-items: center; min-height: 100vh; margin: 0; }
        .container {background: #272e33; padding: 2rem; padding-top: 0; border-radius: 24px; backdrop-filter: blur(10px); border: 1px solid rgba(252, 194, 61, 0.3); text-align: center; width: 90%; max-width: 600px; margin-top: 2rem; }
        h1 { color: #fcc23d; font-size: 2.5rem; margin-bottom: 0.2rem; }
        h2 { color: #fff; font-size: 1.5rem; margin-top: 0; font-weight: 300; }
        .gameBox { background: rgba(0,0,0,0.3); padding: 30px; border-radius: 15px; margin: 20px 0; border: 1px solid #4d5a60; }
        
        .slotMachine { 
            display: flex; gap: 15px; justify-content: center; margin: 30px 0; 
            background: #1a2227; padding: 20px; border-radius: 12px; 
            border: 3px solid #fcc23d; position: relative;
        }

        .winLine {
            position: absolute;
            top: 120px; 
            left: 10px;
            right: 10px;
            height: 100px;
            border-top: 3px solid rgba(252, 194, 61, 0.8);
            border-bottom: 3px solid rgba(252, 194, 61, 0.8);
            background: rgba(252, 194, 61, 0.05);
            border-radius: 8px;
            box-shadow: 0 0 15px rgba(252, 194, 61, 0.2);
            pointer-events: none; 
            z-index: 10;
        }
        
        .reelContainer {
            width: 80px; height: 300px; background: white; border-radius: 8px; 
            border: 2px solid #ccc; 
            box-shadow: inset 0 75px 40px -20px rgba(0,0,0,0.85), inset 0 -75px 40px -20px rgba(0,0,0,0.85);
            overflow: hidden; position: relative;
        }

        .strip { display: flex; flex-direction: column; }
        
        .symbol { 
            height: 100px; display: flex; align-items: center; justify-content: center; 
            font-size: 3rem; color: black;
        }

        @keyframes spinReel {
            0% { transform: translateY(0px); }
            100% { transform: translateY(-2700px); }
        }

        .resultBox { margin: 20px 0; padding: 15px; background: rgba(252, 194, 61, 0.1); border-radius: 8px; min-height: 60px; display: flex; flex-direction: column; justify-content: center; }
        
        @keyframes fadeInResult {
            0% { opacity: 0; transform: scale(0.9); }
            100% { opacity: 1; transform: scale(1); }
        }

        .resultMsg { color: #fcc23d; font-weight: bold; font-size: 1.3rem; margin: 0; }
        .payoutMsg { color: #4CAF50; font-size: 1.1rem; margin-top: 5px; margin-bottom: 0; }

        @keyframes revealBalance {
            0% { color: transparent; text-shadow: 0 0 15px rgba(76, 175, 80, 0.8); }
            99% { color: transparent; text-shadow: 0 0 15px rgba(76, 175, 80, 0.8); }
            100% { color: #4CAF50; text-shadow: none; }
        }

        .balanceSpoiler {
            display: inline-block;
            <%= hasJustSpun ? "animation: revealBalance 4.5s forwards;" : "color: #4CAF50;" %>
        }

        .logoutBtn { display: inline-block; padding: 10px 20px; color: #fcc23d; text-decoration: none; border: 1px solid #fcc23d; border-radius: 8px; transition: 0.3s; }
        .logoutBtn:hover { background: #fcc23d; color: #0f171c; }
        .actionBtn { padding: 10px 20px; cursor: pointer; border-radius: 6px; border: none; font-weight: bold; font-size: 1.2rem; background: #fcc23d; color: #0f171c; transition: 0.2s; }
        .actionBtn:hover { transform: scale(1.05); }
        .actionBtn:disabled { opacity: 0.5; cursor: not-allowed; transform: none; }
        .betInput { padding: 10px; border-radius: 6px; border: 1px solid #fcc23d; background: #0f171c; color: #fcc23d; font-weight: bold; font-size: 1.2rem; width: 100px; text-align: center; margin-right: 15px; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Slotmaschine</h1>
        <h2>Guthaben: 
            <strong>
                <span class="balanceSpoiler"><%= user.getBalance() %> Chips</span>
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
                        <p style="color: #d32f2f; margin-top: 5px; margin-bottom: 0;">- <%= slot.getBetAmount() %> Chips</p>
                    <% } %>
                <% } else { %>
                    <p style="color: #ccc; margin: 0;">Wirf eine Münze ein und drehe die Walzen!</p>
                <% } %>
            </div>

            <form action="SlotServlet" method="POST" style="display: flex; justify-content: center; align-items: center; margin-top: 20px;">
                <label for="betAmount" style="color: #ccc; font-weight: bold; font-size: 1.2rem; margin-right: 10px;">Einsatz:</label>
                <input type="number" id="betAmount" name="betAmount" class="betInput" min="1" max="<%= user.getBalance() %>" value="<%= slot != null ? slot.getBetAmount() : 10 %>" required>
                <button type="submit" id="spinBtn" class="actionBtn">SPIN 🎰</button>
            </form>
        </div>

        <div style="margin-top: 1rem; display: flex; gap: 10px; justify-content: center;">
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