package com.librarymanagement.dao;

import com.librarymanagement.model.Book;
import com.librarymanagement.util.DBConnectionUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class BookDAO {
    public List<Book> findAll() throws SQLException {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT * FROM books ORDER BY id DESC";
        try (Connection connection = DBConnectionUtil.getConnection()) {
            ensureCoverColumn(connection);
            seedFeaturedBooks(connection);
            try (PreparedStatement statement = connection.prepareStatement(sql);
                 ResultSet resultSet = statement.executeQuery()) {
            while (resultSet.next()) {
                books.add(mapRow(resultSet));
            }
            }
        }
        return books;
    }

    public List<Book> findFeaturedBooks(int limit) throws SQLException {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT * FROM books "
                + "WHERE cover_image_url LIKE 'assets/img/covers/book%.jpg' "
                + "ORDER BY CAST(REPLACE(REPLACE(cover_image_url, 'assets/img/covers/book', ''), '.jpg', '') AS UNSIGNED) "
                + "LIMIT ?";
        try (Connection connection = DBConnectionUtil.getConnection()) {
            ensureCoverColumn(connection);
            seedFeaturedBooks(connection);
            try (PreparedStatement statement = connection.prepareStatement(sql)) {
                statement.setInt(1, limit);
                try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    books.add(mapRow(resultSet));
                }
                }
            }
        }
        return books;
    }

    public Book findById(int id) throws SQLException {
        String sql = "SELECT * FROM books WHERE id = ?";
        try (Connection connection = DBConnectionUtil.getConnection()) {
            ensureCoverColumn(connection);
            seedFeaturedBooks(connection);
            try (PreparedStatement statement = connection.prepareStatement(sql)) {
                statement.setInt(1, id);
                try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return mapRow(resultSet);
                }
                }
            }
        }
        return null;
    }

    public void insert(Book book) throws SQLException {
        String sql = "INSERT INTO books (isbn, title, author, category, published_year, total_copies, available_copies, cover_image_url) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection connection = DBConnectionUtil.getConnection()) {
            ensureCoverColumn(connection);
            try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, book.getIsbn());
            statement.setString(2, book.getTitle());
            statement.setString(3, book.getAuthor());
            statement.setString(4, book.getCategory());
            statement.setInt(5, book.getPublishedYear());
            statement.setInt(6, book.getTotalCopies());
            statement.setInt(7, book.getAvailableCopies());
            statement.setString(8, book.getCoverImageUrl());
            statement.executeUpdate();
            }
        }
    }

    public void update(Book book) throws SQLException {
        String sql = "UPDATE books SET isbn = ?, title = ?, author = ?, category = ?, published_year = ?, "
                + "total_copies = ?, available_copies = ?, cover_image_url = ? WHERE id = ?";
        try (Connection connection = DBConnectionUtil.getConnection()) {
            ensureCoverColumn(connection);
            try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, book.getIsbn());
            statement.setString(2, book.getTitle());
            statement.setString(3, book.getAuthor());
            statement.setString(4, book.getCategory());
            statement.setInt(5, book.getPublishedYear());
            statement.setInt(6, book.getTotalCopies());
            statement.setInt(7, book.getAvailableCopies());
            statement.setString(8, book.getCoverImageUrl());
            statement.setInt(9, book.getId());
            statement.executeUpdate();
            }
        }
    }

    public void delete(int id) throws SQLException {
        String sql = "DELETE FROM books WHERE id = ?";
        try (Connection connection = DBConnectionUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, id);
            statement.executeUpdate();
        }
    }

    public int countBooks() throws SQLException {
        String sql = "SELECT COUNT(*) FROM books";
        try (Connection connection = DBConnectionUtil.getConnection()) {
            ensureCoverColumn(connection);
            seedFeaturedBooks(connection);
            try (PreparedStatement statement = connection.prepareStatement(sql);
                 ResultSet resultSet = statement.executeQuery()) {
                resultSet.next();
                return resultSet.getInt(1);
            }
        }
    }

    private void ensureCoverColumn(Connection connection) throws SQLException {
        String checkSql = "SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS "
                + "WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'books' AND COLUMN_NAME = 'cover_image_url'";
        try (PreparedStatement statement = connection.prepareStatement(checkSql);
             ResultSet resultSet = statement.executeQuery()) {
            resultSet.next();
            if (resultSet.getInt(1) > 0) {
                return;
            }
        }

        try (Statement statement = connection.createStatement()) {
            statement.executeUpdate("ALTER TABLE books ADD COLUMN cover_image_url VARCHAR(500) NULL AFTER available_copies");
        }
    }

    private void seedFeaturedBooks(Connection connection) throws SQLException {
        String sql = "INSERT INTO books (isbn, title, author, category, published_year, total_copies, available_copies, cover_image_url) VALUES "
                + "('978-1780899671', 'The Family Upstairs', 'Lisa Jewell', 'Thriller', 2019, 4, 4, 'assets/img/covers/book1.jpg'), "
                + "('978-0062060556', 'Before I Go to Sleep', 'SJ Watson', 'Thriller', 2011, 3, 0, 'assets/img/covers/book2.jpg'), "
                + "('978-1538742525', 'Never Lie', 'Freida McFadden', 'Thriller', 2023, 4, 4, 'assets/img/covers/book3.jpg'), "
                + "('978-0000000001', 'Love, Mom', 'Iliana Xander', 'Mystery', 2022, 4, 4, 'assets/img/covers/book4.jpg'), "
                + "('978-0008371487', 'How to Kill Your Family', 'Bella Mackie', 'Fiction', 2021, 3, 0, 'assets/img/covers/book5.jpg'), "
                + "('978-1524714680', 'One of Us Is Lying', 'Karen M. McManus', 'Mystery', 2017, 4, 4, 'assets/img/covers/book6.jpg'), "
                + "('978-1538742488', 'The Housemaid', 'Freida McFadden', 'Thriller', 2022, 4, 4, 'assets/img/covers/book7.jpg'), "
                + "('978-1250301697', 'The Silent Patient', 'Alex Michaelides', 'Thriller', 2019, 2, 0, 'assets/img/covers/book8.jpg'), "
                + "('978-0000000002', 'Read People Like a Book', 'Patrick King', 'Non-Fiction', 2020, 5, 5, 'assets/img/covers/book9.jpg'), "
                + "('978-0000000003', 'The Art of Being Alone', 'Renuka Gavrani', 'Non-Fiction', 2023, 5, 5, 'assets/img/covers/book10.jpg') "
                + "ON DUPLICATE KEY UPDATE "
                + "title = VALUES(title), "
                + "author = VALUES(author), "
                + "category = VALUES(category), "
                + "published_year = VALUES(published_year), "
                + "cover_image_url = VALUES(cover_image_url)";
        try (Statement statement = connection.createStatement()) {
            statement.executeUpdate(sql);
        }
    }

    private Book mapRow(ResultSet resultSet) throws SQLException {
        Book book = new Book();
        book.setId(resultSet.getInt("id"));
        book.setIsbn(resultSet.getString("isbn"));
        book.setTitle(resultSet.getString("title"));
        book.setAuthor(resultSet.getString("author"));
        book.setCategory(resultSet.getString("category"));
        book.setPublishedYear(resultSet.getInt("published_year"));
        book.setTotalCopies(resultSet.getInt("total_copies"));
        book.setAvailableCopies(resultSet.getInt("available_copies"));
        book.setCoverImageUrl(resultSet.getString("cover_image_url"));
        return book;
    }
}
