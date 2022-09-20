package com.example.quiz_project.domain;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.sql.Timestamp;

@Getter
@Setter
@NoArgsConstructor
public class QuizResultTable {
    private String UserName;
    private String Category;
    private int QuizId;
    private String QuizName;
    private Timestamp startTime;
    private Timestamp endTime;
    private String score;
}
