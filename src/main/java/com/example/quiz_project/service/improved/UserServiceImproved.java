package com.example.quiz_project.service.improved;

import com.example.quiz_project.dao.improved.UserDaoImproved;
import com.example.quiz_project.domain.improved.User;
import com.example.quiz_project.util.SimplePasswordEncoder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class UserServiceImproved {

    private final UserDaoImproved userDao;
    private final SimplePasswordEncoder passwordEncoder;

    @Autowired
    public UserServiceImproved(UserDaoImproved userDao, SimplePasswordEncoder passwordEncoder) {
        this.userDao = userDao;
        this.passwordEncoder = passwordEncoder;
    }

    public Optional<User> authenticateUser(String username, String password) {
        Optional<User> userOpt = userDao.findByUsername(username);
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            if (user.isAccountActive() && passwordEncoder.matches(password, user.getPassword())) {
                return Optional.of(user);
            }
        }
        return Optional.empty();
    }

    public boolean userExists(String username) {
        return userDao.existsByUsername(username);
    }

    public boolean emailExists(String email) {
        return userDao.existsByEmail(email);
    }

    public User createUser(User user) {
        if (userExists(user.getUsername())) {
            throw new IllegalArgumentException("Username already exists: " + user.getUsername());
        }
        if (emailExists(user.getEmail())) {
            throw new IllegalArgumentException("Email already exists: " + user.getEmail());
        }
        
        // Hash password before saving
        user.setPassword(passwordEncoder.encode(user.getPassword()));
        user.setIsActive(true);
        user.setIsAdmin(false);
        
        Integer userId = userDao.save(user);
        user.setUserId(userId);
        return user;
    }

    public User updateUser(User user) {
        if (user.getUserId() == null) {
            throw new IllegalArgumentException("User ID cannot be null for update");
        }
        
        // Don't update password if it's not changed
        if (user.getPassword() == null || user.getPassword().trim().isEmpty()) {
            Optional<User> existingUser = userDao.findById(user.getUserId());
            if (existingUser.isPresent()) {
                user.setPassword(existingUser.get().getPassword());
            }
        } else {
            // Hash new password
            user.setPassword(passwordEncoder.encode(user.getPassword()));
        }
        
        userDao.update(user);
        return user;
    }

    public void changeUserPassword(Integer userId, String newPassword) {
        if (userId == null || newPassword == null || newPassword.trim().isEmpty()) {
            throw new IllegalArgumentException("User ID and new password cannot be null or empty");
        }
        
        String hashedPassword = passwordEncoder.encode(newPassword);
        userDao.updatePassword(userId, hashedPassword);
    }

    public void toggleUserStatus(Integer userId) {
        Optional<User> userOpt = userDao.findById(userId);
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            user.setIsActive(!user.getIsActive());
            userDao.updateStatus(userId, user.getIsActive());
        }
    }

    public void toggleAdminStatus(Integer userId) {
        Optional<User> userOpt = userDao.findById(userId);
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            // Prevent removing admin status from the last admin
            if (user.isAdministrator() && countAdminUsers() <= 1) {
                throw new IllegalStateException("Cannot remove admin status from the last administrator");
            }
            user.setIsAdmin(!user.getIsAdmin());
            userDao.updateAdminStatus(userId, user.getIsAdmin());
        }
    }

    public Optional<User> getUserById(Integer userId) {
        return userDao.findById(userId);
    }

    public Optional<User> getUserByUsername(String username) {
        return userDao.findByUsername(username);
    }

    public List<User> getAllUsers() {
        return userDao.findAll();
    }

    public List<User> getActiveUsers() {
        return userDao.findActiveUsers();
    }

    public List<User> getAdminUsers() {
        return userDao.findAdminUsers();
    }

    public void deleteUser(Integer userId) {
        // Prevent deletion of the last admin
        Optional<User> userOpt = userDao.findById(userId);
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            if (user.isAdministrator() && countAdminUsers() <= 1) {
                throw new IllegalStateException("Cannot delete the last administrator");
            }
        }
        
        userDao.deleteById(userId);
    }

    public int getTotalUserCount() {
        return userDao.count();
    }

    public int getActiveUserCount() {
        return userDao.countActiveUsers();
    }

    public int getAdminUserCount() {
        return userDao.countAdminUsers();
    }

    private int countAdminUsers() {
        return userDao.countAdminUsers();
    }

    public boolean isValidUser(User user) {
        return user != null && 
               user.getUsername() != null && !user.getUsername().trim().isEmpty() &&
               user.getEmail() != null && !user.getEmail().trim().isEmpty() &&
               user.getPassword() != null && !user.getPassword().trim().isEmpty();
    }
}
