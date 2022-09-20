package com.example.quiz_project.service;

import com.example.quiz_project.dao.UserDao;
import com.example.quiz_project.domain.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class UserService {
    private final UserDao userDao;
    @Autowired
    public UserService(UserDao userDao){
        this.userDao=userDao;
    }

    public Optional<User> validateLogin(String username, String password){
        return userDao.getAllUsers().stream()
                .filter(a->a.getUsername().equals(username)
                && a.getPassword().equals(password)).findAny();

    }
    public boolean userExists(String username){
        List<User> users= userDao.getAllUsers();
        for(User u : users){
            //System.out.println(u);
            if(u.getUsername().equals(username)){
                System.out.println("User exist");
                return true;
            }
        }
        return false;

    }

    public List<User> getActiveUsers() {
        return userDao.getAllActiveUsers();
    }

}
