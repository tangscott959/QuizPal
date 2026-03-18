package com.example.quiz_project.domain;

import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class Contact {
    private int contactId;
    private String firstName;
    private String lastName;
    private String email;
    private String subject;
    private String message;

}
