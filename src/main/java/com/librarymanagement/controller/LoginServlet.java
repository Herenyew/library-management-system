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

@WebServlet("/login")
public class LoginServlet extends BaseServlet {
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        forward(request, response, "/WEB-INF/views/login.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = trim(request.getParameter("username"));
        String password = request.getParameter("password");

        try {
            User user = userDAO.authenticate(username, password);
            if (user == null) {
                request.setAttribute("errorMessage", "Invalid username or password.");
                forward(request, response, "/WEB-INF/views/login.jsp");
                return;
            }

            HttpSession session = request.getSession();
            request.changeSessionId();
            session.setAttribute("loggedInUser", user);
            response.sendRedirect(request.getContextPath() + "/dashboard");
        } catch (SQLException ex) {
            request.setAttribute("errorMessage", "Unable to connect to the authentication database.");
            forward(request, response, "/WEB-INF/views/login.jsp");
        }
    }

    private String trim(String value) {
        return value == null ? null : value.trim();
    }
}
