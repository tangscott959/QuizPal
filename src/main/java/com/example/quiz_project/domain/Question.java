package com.example.quiz_project.domain;

import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class Question {
    private int question_id;
    private int category_id;
    private String quiz_description;
    private int is_active;

}
