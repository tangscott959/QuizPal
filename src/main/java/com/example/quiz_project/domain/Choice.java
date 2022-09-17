package com.example.quiz_project.domain;

import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class Choice {
    private int choice_id;
    private int question_id;
    private String choice_description;
    private int is_correct;


}
