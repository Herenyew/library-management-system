package com.librarymanagement.dao;

import com.librarymanagement.model.Member;
import com.librarymanagement.util.DBConnectionUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class MemberDAO {
    public List<Member> findAll() throws SQLException {
        List<Member> members = new ArrayList<>();
        String sql = "SELECT * FROM members ORDER BY id DESC";
        try (Connection connection = DBConnectionUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {
            while (resultSet.next()) {
                members.add(mapRow(resultSet));
            }
        }
        return members;
    }

    public Member findById(int id) throws SQLException {
        String sql = "SELECT * FROM members WHERE id = ?";
        try (Connection connection = DBConnectionUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, id);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return mapRow(resultSet);
                }
            }
        }
        return null;
    }

    public void insert(Member member) throws SQLException {
        String sql = "INSERT INTO members (member_code, full_name, email, phone, address) VALUES (?, ?, ?, ?, ?)";
        try (Connection connection = DBConnectionUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, member.getMemberCode());
            statement.setString(2, member.getFullName());
            statement.setString(3, member.getEmail());
            statement.setString(4, member.getPhone());
            statement.setString(5, member.getAddress());
            statement.executeUpdate();
        }
    }

    public void update(Member member) throws SQLException {
        String sql = "UPDATE members SET member_code = ?, full_name = ?, email = ?, phone = ?, address = ? WHERE id = ?";
        try (Connection connection = DBConnectionUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, member.getMemberCode());
            statement.setString(2, member.getFullName());
            statement.setString(3, member.getEmail());
            statement.setString(4, member.getPhone());
            statement.setString(5, member.getAddress());
            statement.setInt(6, member.getId());
            statement.executeUpdate();
        }
    }

    public void delete(int id) throws SQLException {
        String sql = "DELETE FROM members WHERE id = ?";
        try (Connection connection = DBConnectionUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, id);
            statement.executeUpdate();
        }
    }

    public int countMembers() throws SQLException {
        String sql = "SELECT COUNT(*) FROM members";
        try (Connection connection = DBConnectionUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {
            resultSet.next();
            return resultSet.getInt(1);
        }
    }

    private Member mapRow(ResultSet resultSet) throws SQLException {
        Member member = new Member();
        member.setId(resultSet.getInt("id"));
        member.setMemberCode(resultSet.getString("member_code"));
        member.setFullName(resultSet.getString("full_name"));
        member.setEmail(resultSet.getString("email"));
        member.setPhone(resultSet.getString("phone"));
        member.setAddress(resultSet.getString("address"));
        return member;
    }
}
