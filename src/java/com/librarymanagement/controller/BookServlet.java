package com.librarymanagement.controller;

import com.librarymanagement.dao.BookDAO;
import com.librarymanagement.model.Book;
import java.io.IOException;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/books")
public class BookServlet extends BaseServlet {
    private final BookDAO bookDAO = new BookDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!ensureAuthenticated(request, response)) {
            return;
        }

        String action = request.getParameter("action");
        try {
            if ("new".equals(action)) {
                request.setAttribute("formMode", "create");
                forward(request, response, "/WEB-INF/views/book-form.jsp");
            } else if ("edit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                request.setAttribute("book", bookDAO.findById(id));
                request.setAttribute("formMode", "edit");
                forward(request, response, "/WEB-INF/views/book-form.jsp");
            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                bookDAO.delete(id);
                setFlash(request, "success", "Book deleted.");
                response.sendRedirect(request.getContextPath() + "/books");
            } else {
                request.setAttribute("books", bookDAO.findAll());
                forward(request, response, "/WEB-INF/views/books.jsp");
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

        Book book = new Book();
        book.setIsbn(request.getParameter("isbn"));
        book.setTitle(request.getParameter("title"));
        book.setAuthor(request.getParameter("author"));
        book.setCategory(request.getParameter("category"));
        book.setPublishedYear(Integer.parseInt(request.getParameter("publishedYear")));
        book.setTotalCopies(Integer.parseInt(request.getParameter("totalCopies")));
        book.setAvailableCopies(Integer.parseInt(request.getParameter("availableCopies")));
        book.setCoverImageUrl(trim(request.getParameter("coverImageUrl")));

        try {
            String idValue = request.getParameter("id");
            if (idValue == null || idValue.isEmpty()) {
                bookDAO.insert(book);
                setFlash(request, "success", "Book added.");
            } else {
                book.setId(Integer.parseInt(idValue));
                bookDAO.update(book);
                setFlash(request, "success", "Book updated.");
            }
            response.sendRedirect(request.getContextPath() + "/books");
        } catch (SQLException ex) {
            request.setAttribute("errorMessage", ex.getMessage());
            request.setAttribute("book", book);
            request.setAttribute("formMode", request.getParameter("id") == null ? "create" : "edit");
            forward(request, response, "/WEB-INF/views/book-form.jsp");
        }
    }

    private String trim(String value) {
        return value == null ? null : value.trim();
    }
}
