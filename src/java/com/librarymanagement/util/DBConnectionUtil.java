package com.librarymanagement.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public final class DBConnectionUtil {
    private static final String URL = "jdbc:mysql://localhost:3306/library_management_db?useSSL=false&serverTimezone=UTC";
    private static final String USERNAME = "root";
    private static final String PASSWORD = "root";

    private DBConnectionUtil() {
    }

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException ex) {
            throw new SQLException("MySQL JDBC driver not found. Add mysql-connector-j to the server library.", ex);
        }
        return DriverManager.getConnection(URL, USERNAME, PASSWORD);
    }
}
