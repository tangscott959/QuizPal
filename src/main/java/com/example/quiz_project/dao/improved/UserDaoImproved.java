package com.example.quiz_project.dao.improved;

import com.example.quiz_project.domain.improved.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;

import java.sql.PreparedStatement;
import java.sql.Statement;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public class UserDaoImproved {

    private final JdbcTemplate jdbcTemplate;
    private final RowMapper<User> rowMapper;

    @Autowired
    public UserDaoImproved(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
        this.rowMapper = new UserRowMapper();
    }

    public List<User> findAll() {
        String query = "SELECT * FROM user ORDER BY created_at DESC";
        return jdbcTemplate.query(query, rowMapper);
    }

    public List<User> findActiveUsers() {
        String query = "SELECT * FROM user WHERE is_active = true AND is_admin = false ORDER BY created_at DESC";
        return jdbcTemplate.query(query, rowMapper);
    }

    public List<User> findAdminUsers() {
        String query = "SELECT * FROM user WHERE is_admin = true ORDER BY created_at DESC";
        return jdbcTemplate.query(query, rowMapper);
    }

    public Optional<User> findById(Integer userId) {
        try {
            String query = "SELECT * FROM user WHERE user_id = ?";
            User user = jdbcTemplate.queryForObject(query, rowMapper, userId);
            return Optional.of(user);
        } catch (EmptyResultDataAccessException e) {
            return Optional.empty();
        }
    }

    public Optional<User> findByUsername(String username) {
        try {
            String query = "SELECT * FROM user WHERE user_name = ?";
            User user = jdbcTemplate.queryForObject(query, rowMapper, username);
            return Optional.of(user);
        } catch (EmptyResultDataAccessException e) {
            return Optional.empty();
        }
    }

    public Optional<User> findByEmail(String email) {
        try {
            String query = "SELECT * FROM user WHERE email = ?";
            User user = jdbcTemplate.queryForObject(query, rowMapper, email);
            return Optional.of(user);
        } catch (EmptyResultDataAccessException e) {
            return Optional.empty();
        }
    }

    public boolean existsByUsername(String username) {
        String query = "SELECT COUNT(*) FROM user WHERE user_name = ?";
        Integer count = jdbcTemplate.queryForObject(query, Integer.class, username);
        return count != null && count > 0;
    }

    public boolean existsByEmail(String email) {
        String query = "SELECT COUNT(*) FROM user WHERE email = ?";
        Integer count = jdbcTemplate.queryForObject(query, Integer.class, email);
        return count != null && count > 0;
    }

    public Integer save(User user) {
        if (user.getUserId() == null) {
            return insert(user);
        } else {
            update(user);
            return user.getUserId();
        }
    }

    private Integer insert(User user) {
        KeyHolder keyHolder = new GeneratedKeyHolder();
        jdbcTemplate.update(connection -> {
            String sql = "INSERT INTO user (user_name, user_password, firstname, lastname, email, phone, is_active, is_admin) " +
                        "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPassword());
            ps.setString(3, user.getFirstname());
            ps.setString(4, user.getLastname());
            ps.setString(5, user.getEmail());
            ps.setString(6, user.getPhone());
            ps.setBoolean(7, user.getIsActive() != null ? user.getIsActive() : true);
            ps.setBoolean(8, user.getIsAdmin() != null ? user.getIsAdmin() : false);
            return ps;
        }, keyHolder);
        return keyHolder.getKey().intValue();
    }

    public void update(User user) {
        String sql = "UPDATE user SET user_name = ?, user_password = ?, firstname = ?, lastname = ?, " +
                    "email = ?, phone = ?, is_active = ?, is_admin = ?, updated_at = ? WHERE user_id = ?";
        jdbcTemplate.update(sql, user.getUsername(), user.getPassword(), user.getFirstname(), user.getLastname(),
                user.getEmail(), user.getPhone(), user.getIsActive(), user.getIsAdmin(), 
                LocalDateTime.now(), user.getUserId());
    }

    public void updatePassword(Integer userId, String hashedPassword) {
        String sql = "UPDATE user SET user_password = ?, updated_at = ? WHERE user_id = ?";
        jdbcTemplate.update(sql, hashedPassword, LocalDateTime.now(), userId);
    }

    public void updateStatus(Integer userId, Boolean isActive) {
        String sql = "UPDATE user SET is_active = ?, updated_at = ? WHERE user_id = ?";
        jdbcTemplate.update(sql, isActive, LocalDateTime.now(), userId);
    }

    public void updateAdminStatus(Integer userId, Boolean isAdmin) {
        String sql = "UPDATE user SET is_admin = ?, updated_at = ? WHERE user_id = ?";
        jdbcTemplate.update(sql, isAdmin, LocalDateTime.now(), userId);
    }

    public void deleteById(Integer userId) {
        String query = "DELETE FROM user WHERE user_id = ?";
        jdbcTemplate.update(query, userId);
    }

    public int count() {
        String query = "SELECT COUNT(*) FROM user";
        return jdbcTemplate.queryForObject(query, Integer.class);
    }

    public int countActiveUsers() {
        String query = "SELECT COUNT(*) FROM user WHERE is_active = true";
        return jdbcTemplate.queryForObject(query, Integer.class);
    }

    public int countAdminUsers() {
        String query = "SELECT COUNT(*) FROM user WHERE is_admin = true";
        return jdbcTemplate.queryForObject(query, Integer.class);
    }
}
