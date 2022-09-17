package com.example.quiz_project.domain;

import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class User {
    private int id;
    private String username;
    private String password;
    private String firstname;
    private String lastname;
    private String email;
    private String phone;
    private int is_active;
    private int is_admin;
}
