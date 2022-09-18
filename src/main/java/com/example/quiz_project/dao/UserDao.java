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
    public void AddUser(String user_name,String user_password,
                        String firstname, String lastname, String email,
                        String phone){
        String query ="INSERT INTO user " +
                "(user_name,user_password,firstname,lastname,email,phone) " +
                "VALUES(?,?,?,?,?,?)";
        jdbcTemplate.update(query,user_name,user_password,firstname,lastname,email,phone);
        System.out.println("User added");
    }



}
