<%@ page contentType="text/html;charset=UTF-8" language="java" %> 
<%@ page import="model.User" %> 
<% if (session.getAttribute("currentUser") == null) { response.sendRedirect("LoginPage.html"); return;} %>
<!doctype html>
<html lang="de">
  <head>
    <meta charset="UTF-8" />
    <title>Casino - Lobby</title>
    <style>
      body {
        background: #0f171c;
        color: white;
        font-family: system-ui, sans-serif;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        height: 100vh;
        margin: 0;
      }
      .container {
        background: rgba(255, 255, 255, 0.1);
        padding: 3rem;
        border-radius: 24px;
        backdrop-filter: blur(10px);
        border: 1px solid rgba(252, 194, 61, 0.3);
        text-align: center;
      }
      h1 {
        color: #fcc23d;
        font-size: 3rem;
      }
      .logout-btn {
        margin-top: 2rem;
        display: inline-block;
        padding: 10px 20px;
        color: #fcc23d;
        text-decoration: none;
        border: 1px solid #fcc23d;
        border-radius: 8px;
        transition: 0.3s;
      }
      .logout-btn:hover {
        background: #fcc23d;
        color: #0f171c;
      }
    </style>
  </head>
  <body>
    <div class="container">
      <h1>Willkommen im Casino!</h1>

      <p>Hallo, <strong>${currentUser.username}</strong>!</p>
      <p>Dein Einsatz ist bereit. Viel Glück!</p>

      <a href="LoginPage.html" class="logout-btn">Abmelden</a>
    </div>
  </body>
</html>
