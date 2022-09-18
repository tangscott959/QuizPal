package com.example.quiz_project.domain;

import lombok.*;

import java.sql.Timestamp;
import java.util.Date;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class Quiz {
    int quizId;
    int userId;
    int categoryId;
    String quizName;
    Timestamp quizTimeStart;
    Timestamp quizTimeEnd;
}
