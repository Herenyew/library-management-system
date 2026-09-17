package com.librarymanagement.dao;

import com.librarymanagement.model.Loan;
import com.librarymanagement.util.DBConnectionUtil;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class LoanDAO {
    public List<Loan> findAll() throws SQLException {
        List<Loan> loans = new ArrayList<>();
        String sql = "SELECT l.id, l.book_id, l.member_id, l.issue_date, l.due_date, l.return_date, l.status, "
                + "b.title AS book_title, m.full_name AS member_name "
                + "FROM loans l INNER JOIN books b ON l.book_id = b.id "
                + "INNER JOIN members m ON l.member_id = m.id ORDER BY l.id DESC";
        try (Connection connection = DBConnectionUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {
            while (resultSet.next()) {
                loans.add(mapRow(resultSet));
            }
        }
        return loans;
    }

    public void issueBook(Loan loan) throws SQLException {
        String insertLoanSql = "INSERT INTO loans (book_id, member_id, issue_date, due_date, status) VALUES (?, ?, ?, ?, ?)";
        String updateBookSql = "UPDATE books SET available_copies = available_copies - 1 WHERE id = ? AND available_copies > 0";

        try (Connection connection = DBConnectionUtil.getConnection()) {
            connection.setAutoCommit(false);

            try (PreparedStatement updateBookStatement = connection.prepareStatement(updateBookSql)) {
                updateBookStatement.setInt(1, loan.getBookId());
                int affectedRows = updateBookStatement.executeUpdate();
                if (affectedRows == 0) {
                    connection.rollback();
                    throw new SQLException("Book is not available for loan.");
                }
            }

            try (PreparedStatement insertLoanStatement = connection.prepareStatement(insertLoanSql)) {
                insertLoanStatement.setInt(1, loan.getBookId());
                insertLoanStatement.setInt(2, loan.getMemberId());
                insertLoanStatement.setDate(3, loan.getIssueDate());
                insertLoanStatement.setDate(4, loan.getDueDate());
                insertLoanStatement.setString(5, "BORROWED");
                insertLoanStatement.executeUpdate();
            }

            connection.commit();
        }
    }

    public void returnBook(int loanId) throws SQLException {
        String findLoanSql = "SELECT book_id FROM loans WHERE id = ? AND status = 'BORROWED'";
        String returnLoanSql = "UPDATE loans SET status = 'RETURNED', return_date = ? WHERE id = ?";
        String updateBookSql = "UPDATE books SET available_copies = available_copies + 1 WHERE id = ?";

        try (Connection connection = DBConnectionUtil.getConnection()) {
            connection.setAutoCommit(false);
            int bookId;

            try (PreparedStatement findLoanStatement = connection.prepareStatement(findLoanSql)) {
                findLoanStatement.setInt(1, loanId);
                try (ResultSet resultSet = findLoanStatement.executeQuery()) {
                    if (!resultSet.next()) {
                        connection.rollback();
                        throw new SQLException("Loan record not found or already returned.");
                    }
                    bookId = resultSet.getInt("book_id");
                }
            }

            try (PreparedStatement returnLoanStatement = connection.prepareStatement(returnLoanSql)) {
                returnLoanStatement.setDate(1, new Date(System.currentTimeMillis()));
                returnLoanStatement.setInt(2, loanId);
                returnLoanStatement.executeUpdate();
            }

            try (PreparedStatement updateBookStatement = connection.prepareStatement(updateBookSql)) {
                updateBookStatement.setInt(1, bookId);
                updateBookStatement.executeUpdate();
            }

            connection.commit();
        }
    }

    public int countActiveLoans() throws SQLException {
        String sql = "SELECT COUNT(*) FROM loans WHERE status = 'BORROWED'";
        try (Connection connection = DBConnectionUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {
            resultSet.next();
            return resultSet.getInt(1);
        }
    }

    private Loan mapRow(ResultSet resultSet) throws SQLException {
        Loan loan = new Loan();
        loan.setId(resultSet.getInt("id"));
        loan.setBookId(resultSet.getInt("book_id"));
        loan.setMemberId(resultSet.getInt("member_id"));
        loan.setBookTitle(resultSet.getString("book_title"));
        loan.setMemberName(resultSet.getString("member_name"));
        loan.setIssueDate(resultSet.getDate("issue_date"));
        loan.setDueDate(resultSet.getDate("due_date"));
        loan.setReturnDate(resultSet.getDate("return_date"));
        loan.setStatus(resultSet.getString("status"));
        return loan;
    }
}
