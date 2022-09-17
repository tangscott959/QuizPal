package com.example.quiz_project.service;

import com.example.quiz_project.dao.UserDao;
import com.example.quiz_project.domain.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class UserService {
    private final UserDao userDao;
    @Autowired
    public UserService(UserDao userDao){
        this.userDao=userDao;
    }
//    public void createNewUser(User user){
//        userDao.createNewUser(user);
//    }
    public Optional<User> validateLogin(String username, String password){
        return userDao.getAllUsers().stream()
                .filter(a->a.getUsername().equals(username)
                && a.getPassword().equals(password)).findAny();

    }

}
