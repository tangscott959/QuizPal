package com.example.quiz_project.dao;

import com.example.quiz_project.domain.User;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Repository;

import java.sql.ResultSet;
import java.sql.SQLException;

@Component
@Repository
public class UserRowMapper implements RowMapper<User> {
    @Override
    public User mapRow(ResultSet rs, int rowNum) throws SQLException{
        User user =new User();
        user.setId(rs.getInt("user_id"));
        user.setUsername(rs.getString("user_name"));
        user.setPassword(rs.getString("user_password"));
        user.setFirstname(rs.getString("firstname"));
        user.setLastname(rs.getString("lastname"));
        user.setEmail(rs.getString("email"));
        user.setPhone(rs.getString("phone"));
        user.setIs_active(rs.getInt("is_active"));
        user.setIs_admin(rs.getInt("is_admin"));
        return user;

    }
}
