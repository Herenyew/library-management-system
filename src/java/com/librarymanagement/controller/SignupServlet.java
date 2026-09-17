package com.librarymanagement.controller;

import com.librarymanagement.dao.UserDAO;
import com.librarymanagement.model.User;
import java.io.IOException;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/signup")
public class SignupServlet extends BaseServlet {
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        forward(request, response, "/WEB-INF/views/signup.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String fullName = trim(request.getParameter("fullName"));
        String username = trim(request.getParameter("username"));
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        String validationMessage = validate(fullName, username, password, confirmPassword);
        if (validationMessage != null) {
            request.setAttribute("errorMessage", validationMessage);
            forward(request, response, "/WEB-INF/views/signup.jsp");
            return;
        }

        try {
            User user = userDAO.createAdmin(username, password, fullName);
            HttpSession session = request.getSession();
            request.changeSessionId();
            session.setAttribute("loggedInUser", user);
            response.sendRedirect(request.getContextPath() + "/dashboard");
        } catch (SQLException ex) {
            String message = "Unable to create the admin account. Please try again.";
            if (ex.getMessage() != null && ex.getMessage().contains("Username already exists")) {
                message = "That username is already taken.";
            }
            request.setAttribute("errorMessage", message);
            forward(request, response, "/WEB-INF/views/signup.jsp");
        }
    }

    private String validate(String fullName, String username, String password, String confirmPassword) {
        if (isBlank(fullName) || isBlank(username) || isBlank(password) || isBlank(confirmPassword)) {
            return "All fields are required.";
        }
        if (fullName.length() > 100) {
            return "Full name must be 100 characters or less.";
        }
        if (!username.matches("[A-Za-z0-9_]{3,50}")) {
            return "Username must be 3-50 characters and use only letters, numbers, or underscores.";
        }
        if (password.length() < 8) {
            return "Password must be at least 8 characters long.";
        }
        if (!password.equals(confirmPassword)) {
            return "Passwords do not match.";
        }
        return null;
    }

    private String trim(String value) {
        return value == null ? null : value.trim();
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}
