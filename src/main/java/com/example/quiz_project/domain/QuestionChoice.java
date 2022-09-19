package com.example.quiz_project.domain;

import lombok.*;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class QuestionChoice {
    private int questionId;
    private String Description;
    private int userChoice;
    private List<Choice> choiceList;
}
