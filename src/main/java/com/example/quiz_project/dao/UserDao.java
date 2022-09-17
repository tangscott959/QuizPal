package com.example.quiz_project.dao;

import com.example.quiz_project.domain.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Repository;

import java.util.List;

@Component
@Repository
public class UserDao {
    JdbcTemplate jdbcTemplate;
    UserRowMapper rowMapper;
    @Autowired
    public UserDao(JdbcTemplate jdbcTemplate, UserRowMapper rowMapper ){
        this.jdbcTemplate=jdbcTemplate;
        this.rowMapper=rowMapper;
    }
    public List<User> getAllUsers(){
        String query = "SELECT * FROM USER";
        List<User> users = jdbcTemplate.query(query,rowMapper);
        return users;
    }



}
