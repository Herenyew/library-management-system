package com.librarymanagement.controller;

import com.librarymanagement.dao.BookDAO;
import com.librarymanagement.dao.LoanDAO;
import com.librarymanagement.dao.MemberDAO;
import java.io.IOException;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/dashboard")
public class DashboardServlet extends BaseServlet {
    private final BookDAO bookDAO = new BookDAO();
    private final MemberDAO memberDAO = new MemberDAO();
    private final LoanDAO loanDAO = new LoanDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!ensureAuthenticated(request, response)) {
            return;
        }

        try {
            request.setAttribute("bookCount", bookDAO.countBooks());
            request.setAttribute("memberCount", memberDAO.countMembers());
            request.setAttribute("activeLoanCount", loanDAO.countActiveLoans());
            request.setAttribute("featuredBooks", bookDAO.findFeaturedBooks(10));
            forward(request, response, "/WEB-INF/views/dashboard.jsp");
        } catch (SQLException ex) {
            request.setAttribute("errorMessage", ex.getMessage());
            forward(request, response, "/WEB-INF/views/error.jsp");
        }
    }
}
