package com.example.quiz_project.service;

import com.example.quiz_project.dao.UserDao;
import com.example.quiz_project.domain.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class UserService {
    private final UserDao userDao;
    private final PasswordEncoder passwordEncoder;
    
    @Autowired
    public UserService(UserDao userDao, PasswordEncoder passwordEncoder){
        this.userDao=userDao;
        this.passwordEncoder = passwordEncoder;
    }

    public Optional<User> validateLogin(String username, String password){
        return userDao.findByUsername(username)
                .filter(user -> user.getIs_active() == 1)
                .filter(user -> passwordEncoder.matches(password, user.getPassword()));
    }

    public void registerUser(String username, String password,
                             String firstname, String lastname,
                             String email, String phone) {
        String encodedPassword = passwordEncoder.encode(password);
        userDao.AddUser(username, encodedPassword, firstname, lastname, email, phone, 1, 0);
    }

    public boolean userExists(String username){
        return userDao.findByUsername(username).isPresent();

    }

    public List<User> getAllUsers() {
        return userDao.getAllUsers();
    }
    public List<User> getActiveUsers() {
        return userDao.getAllActiveUsers();
    }

    public void toggleUserStatus(int uid) {
        int status = userDao.getById(uid).getIs_active();
        if (status == 0)
            status =1;
        else
            status =0;
        userDao.updateUserstatus(uid,status);
    }
    public User getUserById(int id) {
        return userDao.getById(id);
    }
    public void toggleAdminStatus(int userId) {
        User user = userDao.getById(userId);
        int newStatus = (user.getIs_admin() == 1) ? 0 : 1;
        userDao.updateAdminStatus(userId, newStatus);
    }

}
