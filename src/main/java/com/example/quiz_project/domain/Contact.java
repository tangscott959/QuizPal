package com.example.quiz_project.domain;

import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class Contact {
    private int ContactId;
    private String FirstName;
    private String LastName;
    private String Subject;
    private String Message;


}
