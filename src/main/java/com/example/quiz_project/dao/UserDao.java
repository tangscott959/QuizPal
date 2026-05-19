package com.example.quiz_project.dao;

import com.example.quiz_project.domain.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

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
        String query = "SELECT * FROM user";
        List<User> users = jdbcTemplate.query(query,rowMapper);
        return users;
    }

    public List<User> getAllActiveUsers(){
        String query = "SELECT * FROM user WHERE is_active = 1 AND is_admin = 0";
        List<User> users = jdbcTemplate.query(query,rowMapper);
        return users;
    }

    public Optional<User> findByUsername(String username) {
        String query = "SELECT * FROM user WHERE user_name = ?";
        List<User> users = jdbcTemplate.query(query, rowMapper, username);
        return users.stream().findFirst();
    }

    public void AddUser(String user_name,String user_password,
                        String firstname, String lastname, String email,
                        String phone, int is_active, int is_admin){
        String query ="INSERT INTO user " +
                "(user_name,user_password,firstname,lastname,email,phone,is_active,is_admin) " +
                "VALUES(?,?,?,?,?,?,?,?)";
        jdbcTemplate.update(query,user_name,user_password,firstname,lastname,email,phone,is_active,is_admin);
    }
    public void updateUserstatus(int uid,int status) {
        String query = "UPDATE user SET is_active = ? WHERE user_id =?";
        jdbcTemplate.update(query,status,uid);
    }
    public User getById(int uid) {
        String query = "SELECT * FROM user WHERE user_id = ?";
        return this.jdbcTemplate.queryForObject(query,rowMapper,uid);
    }
    public void updateAdminStatus(int userId, int isAdmin) {
        String sql = "UPDATE user SET is_admin = ? WHERE user_id = ?";
        jdbcTemplate.update(sql, isAdmin, userId);
    }

    public User findByEmail(String email) {
        String query = "SELECT * FROM user WHERE email = ?";
        List<User> users = jdbcTemplate.query(query, rowMapper, email);
        return users.isEmpty() ? null : users.get(0);
    }

}
