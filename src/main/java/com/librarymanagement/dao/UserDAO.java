package com.librarymanagement.dao;

import com.librarymanagement.model.User;
import com.librarymanagement.util.DBConnectionUtil;
import com.librarymanagement.util.PasswordUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.SQLIntegrityConstraintViolationException;
import java.sql.Statement;

public class UserDAO {
    public User authenticate(String username, String password) throws SQLException {
        if (isBlank(username) || isBlank(password)) {
            return null;
        }

        String sql = "SELECT id, username, password, full_name, role FROM users WHERE username = ?";
        try (Connection connection = DBConnectionUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, username.trim());

            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    String storedPassword = resultSet.getString("password");
                    if (PasswordUtil.verifyPassword(password, storedPassword)) {
                        return mapUser(resultSet);
                    }
                }
            }
        }
        return null;
    }

    public User createAdmin(String username, String password, String fullName) throws SQLException {
        String sql = "INSERT INTO users (username, password, full_name, role) VALUES (?, ?, ?, ?)";
        try (Connection connection = DBConnectionUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            statement.setString(1, username.trim());
            statement.setString(2, PasswordUtil.hashPassword(password));
            statement.setString(3, fullName.trim());
            statement.setString(4, "ADMIN");
            statement.executeUpdate();

            try (ResultSet keys = statement.getGeneratedKeys()) {
                if (keys.next()) {
                    return new User(keys.getInt(1), username.trim(), null, fullName.trim(), "ADMIN");
                }
            }
            throw new SQLException("Unable to create admin account.");
        } catch (SQLIntegrityConstraintViolationException ex) {
            throw new SQLException("Username already exists.", ex);
        }
    }

    private User mapUser(ResultSet resultSet) throws SQLException {
        User user = new User();
        user.setId(resultSet.getInt("id"));
        user.setUsername(resultSet.getString("username"));
        user.setPassword(null);
        user.setFullName(resultSet.getString("full_name"));
        user.setRole(resultSet.getString("role"));
        return user;
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}
