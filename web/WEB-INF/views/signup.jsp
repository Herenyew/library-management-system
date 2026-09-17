<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Sign Up - LibraVault</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/style.css">
</head>
<body>
<div class="login-shell">
    <div class="login-bg-text">LibraVault</div>
    <div class="login-card">
        <div class="login-logo">
            <div class="login-icon">LV</div>
            <h1>Admin Sign Up</h1>
            <p>Create a secure administrator account</p>
        </div>
        <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="message error"><%= request.getAttribute("errorMessage") %></div>
        <% } %>
        <form action="<%= request.getContextPath() %>/signup" method="post">
            <div class="form-group">
                <label for="fullName">Full Name</label>
                <input type="text" id="fullName" name="fullName" maxlength="100" required>
            </div>
            <div class="form-group">
                <label for="username">Username</label>
                <input type="text" id="username" name="username" minlength="3" maxlength="50" pattern="[A-Za-z0-9_]{3,50}" required>
            </div>
            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" minlength="8" required>
            </div>
            <div class="form-group">
                <label for="confirmPassword">Confirm Password</label>
                <input type="password" id="confirmPassword" name="confirmPassword" minlength="8" required>
            </div>
            <button type="submit">Create Admin</button>
        </form>
        <p class="auth-link">Already have an admin account? <a href="<%= request.getContextPath() %>/login">Sign in</a></p>
    </div>
</div>
</body>
</html>
