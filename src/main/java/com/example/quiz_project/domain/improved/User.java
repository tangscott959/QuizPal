package com.example.quiz_project.domain.improved;

import lombok.*;
import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class User {
    private Integer userId;
    private String username;
    private String password;
    private String firstname;
    private String lastname;
    private String email;
    private String phone;
    private Boolean isActive;
    private Boolean isAdmin;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public String getFullName() {
        return firstname != null && lastname != null ? 
               firstname + " " + lastname : 
               username != null ? username : "Unknown";
    }

    public boolean isRegularUser() {
        return isAdmin != null && !isAdmin;
    }

    public boolean isAdministrator() {
        return isAdmin != null && isAdmin;
    }

    public boolean isAccountActive() {
        return isActive != null && isActive;
    }
}
