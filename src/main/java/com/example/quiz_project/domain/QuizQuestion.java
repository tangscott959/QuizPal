package com.example.quiz_project.domain;

import lombok.*;


@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class QuizQuestion {
    int quizquestionId;
    int quizId;
    int questionId;
    int choiceId;
    int orderNum;
}
