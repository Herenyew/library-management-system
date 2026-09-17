<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - LibraVault</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/style.css">
</head>
<body>
<div class="login-shell">
    <div class="login-bg-text">LibraVault</div>
    <div class="login-card">
        <div class="login-logo">
            <div class="login-icon">LV</div>
            <h1>LibraVault</h1>
            <p>Library Management System</p>
        </div>
        <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="message error"><%= request.getAttribute("errorMessage") %></div>
        <% } %>
        <form action="<%= request.getContextPath() %>/login" method="post">
            <div class="form-group">
                <label for="username">Username</label>
                <input type="text" id="username" name="username" required>
            </div>
            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" required>
            </div>
            <button type="submit">Sign In</button>
        </form>
        <p class="login-note">Use the admin account stored in the database.</p>
        <p class="auth-link">Need an admin account? <a href="<%= request.getContextPath() %>/signup">Sign up</a></p>
    </div>
</div>
</body>
</html>
