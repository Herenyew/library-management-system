<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.librarymanagement.model.User" %>
<%!
    private String escapeHtml(String value) {
        if (value == null) {
            return "";
        }
        return value.replace("&", "&amp;")
                .replace("\"", "&quot;")
                .replace("<", "&lt;")
                .replace(">", "&gt;");
    }
%>
<%
    User loggedInUser = (User) session.getAttribute("loggedInUser");
    String flashMessage = (String) session.getAttribute("flashMessage");
    String flashType = (String) session.getAttribute("flashType");
    if (flashMessage != null) {
        session.removeAttribute("flashMessage");
        session.removeAttribute("flashType");
    }
    String requestUri = request.getRequestURI();
    boolean dashboardActive = requestUri.endsWith("/dashboard");
    boolean booksActive = requestUri.endsWith("/books");
    boolean membersActive = requestUri.endsWith("/members");
    boolean loansActive = requestUri.endsWith("/loans");
    String initials = "L";
    if (loggedInUser != null && loggedInUser.getFullName() != null && !loggedInUser.getFullName().isEmpty()) {
        initials = String.valueOf(Character.toUpperCase(loggedInUser.getFullName().charAt(0)));
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LibraVault Library Management</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/style.css">
</head>
<body>
<div class="app-shell">
    <aside class="sidebar">
        <div class="sidebar-brand">
            <h2>LibraVault</h2>
            <span>Library Management System</span>
        </div>
        <% if (loggedInUser != null) { %>
        <div class="sidebar-user">
            <div class="user-avatar"><%= initials %></div>
            <div>
                <div class="user-name"><%= loggedInUser.getFullName() %></div>
                <div class="user-role"><%= loggedInUser.getRole() %></div>
            </div>
        </div>
        <% } %>
        <div class="sidebar-nav flex">
            <div class="nav-section-title">Navigation</div>
            <a class="nav-item <%= dashboardActive ? "active" : "" %>" href="<%= request.getContextPath() %>/dashboard">
                <span class="nav-icon">D</span><span>Dashboard</span>
            </a>
            <a class="nav-item <%= booksActive ? "active" : "" %>" href="<%= request.getContextPath() %>/books">
                <span class="nav-icon">B</span><span>Books</span>
            </a>
            <a class="nav-item <%= membersActive ? "active" : "" %>" href="<%= request.getContextPath() %>/members">
                <span class="nav-icon">M</span><span>Members</span>
            </a>
            <a class="nav-item <%= loansActive ? "active" : "" %>" href="<%= request.getContextPath() %>/loans">
                <span class="nav-icon">L</span><span>Loans</span>
            </a>
        </div>
        <div class="sidebar-nav">
            <a class="nav-item logout" href="<%= request.getContextPath() %>/logout">
                <span class="nav-icon">X</span><span>Logout</span>
            </a>
        </div>
    </aside>
    <main class="main-content">
        <% if (flashMessage != null && !flashMessage.trim().isEmpty()) { %>
        <input type="hidden" id="flash-message" value="<%= escapeHtml(flashMessage) %>" data-flash-type="<%= escapeHtml(flashType) %>">
        <% } %>
