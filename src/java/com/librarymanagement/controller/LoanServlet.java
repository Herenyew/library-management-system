package com.librarymanagement.controller;

import com.librarymanagement.dao.BookDAO;
import com.librarymanagement.dao.LoanDAO;
import com.librarymanagement.dao.MemberDAO;
import com.librarymanagement.model.Loan;
import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/loans")
public class LoanServlet extends BaseServlet {
    private final LoanDAO loanDAO = new LoanDAO();
    private final BookDAO bookDAO = new BookDAO();
    private final MemberDAO memberDAO = new MemberDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!ensureAuthenticated(request, response)) {
            return;
        }

        String action = request.getParameter("action");
        try {
            if ("new".equals(action)) {
                request.setAttribute("books", bookDAO.findAll());
                request.setAttribute("members", memberDAO.findAll());
                forward(request, response, "/WEB-INF/views/loan-form.jsp");
            } else if ("return".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                loanDAO.returnBook(id);
                setFlash(request, "success", "Book returned.");
                response.sendRedirect(request.getContextPath() + "/loans");
            } else {
                request.setAttribute("loans", loanDAO.findAll());
                request.setAttribute("books", bookDAO.findAll());
                request.setAttribute("members", memberDAO.findAll());
                forward(request, response, "/WEB-INF/views/loans.jsp");
            }
        } catch (SQLException ex) {
            request.setAttribute("errorMessage", ex.getMessage());
            forward(request, response, "/WEB-INF/views/error.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!ensureAuthenticated(request, response)) {
            return;
        }

        Loan loan = new Loan();
        loan.setBookId(Integer.parseInt(request.getParameter("bookId")));
        loan.setMemberId(Integer.parseInt(request.getParameter("memberId")));
        loan.setIssueDate(Date.valueOf(request.getParameter("issueDate")));
        loan.setDueDate(Date.valueOf(request.getParameter("dueDate")));

        try {
            loanDAO.issueBook(loan);
            setFlash(request, "success", "Book borrowed.");
            response.sendRedirect(request.getContextPath() + "/loans");
        } catch (SQLException ex) {
            try {
                request.setAttribute("books", bookDAO.findAll());
                request.setAttribute("members", memberDAO.findAll());
            } catch (SQLException ignored) {
                request.setAttribute("errorMessage", ignored.getMessage());
            }
            request.setAttribute("errorMessage", ex.getMessage());
            forward(request, response, "/WEB-INF/views/loan-form.jsp");
        }
    }
}
