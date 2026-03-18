package com.example.quiz_project.service;

import com.example.quiz_project.dao.UserDao;
import com.example.quiz_project.domain.User;
import com.example.quiz_project.util.SimplePasswordEncoder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class UserService {
    private final UserDao userDao;
    private final SimplePasswordEncoder passwordEncoder;
    
    @Autowired
    public UserService(UserDao userDao, SimplePasswordEncoder passwordEncoder){
        this.userDao=userDao;
        this.passwordEncoder = passwordEncoder;
    }

    public Optional<User> validateLogin(String username, String password){
        return userDao.getAllUsers().stream()
                .filter(user -> user.getUsername().equalsIgnoreCase(username) 
                    && user.getIs_active() == 1
                    && user.getPassword().equals(password))
                .findAny();
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
