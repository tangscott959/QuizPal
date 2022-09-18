package com.example.quiz_project.domain;

import lombok.*;

import java.sql.Timestamp;
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class Feedback {
    private int FeedbackId;
    private String Message;
    private int rating;
    private Timestamp submitDate;

}
