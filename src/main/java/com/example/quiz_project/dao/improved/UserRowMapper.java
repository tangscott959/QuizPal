package com.example.quiz_project.dao.improved;

import com.example.quiz_project.domain.improved.User;
import org.springframework.jdbc.core.RowMapper;

import java.sql.ResultSet;
import java.sql.SQLException;

public class UserRowMapper implements RowMapper<User> {

    @Override
    public User mapRow(ResultSet rs, int rowNum) throws SQLException {
        User user = new User();
        user.setUserId(rs.getInt("user_id"));
        user.setUsername(rs.getString("user_name"));
        user.setPassword(rs.getString("user_password"));
        user.setFirstname(rs.getString("firstname"));
        user.setLastname(rs.getString("lastname"));
        user.setEmail(rs.getString("email"));
        user.setPhone(rs.getString("phone"));
        user.setIsActive(rs.getBoolean("is_active"));
        user.setIsAdmin(rs.getBoolean("is_admin"));
        
        // Handle timestamp fields
        try {
            user.setCreatedAt(rs.getTimestamp("created_at") != null ? 
                rs.getTimestamp("created_at").toLocalDateTime() : null);
            user.setUpdatedAt(rs.getTimestamp("updated_at") != null ? 
                rs.getTimestamp("updated_at").toLocalDateTime() : null);
        } catch (SQLException e) {
            // Handle case where columns don't exist yet (backward compatibility)
            user.setCreatedAt(null);
            user.setUpdatedAt(null);
        }
        
        return user;
    }
}
