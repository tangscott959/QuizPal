package com.example.quiz_project.domain.improved;

import lombok.*;
import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class Choice {
    private Integer choiceId;
    private Integer questionId;
    private String choiceText;
    private Boolean isCorrect;
    private Integer choiceOrder;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public boolean isCorrectChoice() {
        return isCorrect != null && isCorrect;
    }

    public boolean isIncorrectChoice() {
        return !isCorrectChoice();
    }

    public String getDisplayText() {
        return choiceText != null ? choiceText : "";
    }

    public String getLetterLabel() {
        if (choiceOrder == null) return "";
        return String.valueOf((char) ('A' + choiceOrder - 1));
    }
}
