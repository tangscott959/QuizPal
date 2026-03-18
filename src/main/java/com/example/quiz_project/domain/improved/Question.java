package com.example.quiz_project.domain.improved;

import lombok.*;
import java.time.LocalDateTime;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class Question {
    private Integer questionId;
    private Integer categoryId;
    private String questionText;
    private QuestionType questionType;
    private DifficultyLevel difficultyLevel;
    private Integer points;
    private Boolean isActive;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    
    private List<Choice> choices;

    public enum QuestionType {
        MULTIPLE_CHOICE, TRUE_FALSE, SHORT_ANSWER
    }

    public enum DifficultyLevel {
        EASY, MEDIUM, HARD
    }

    public boolean isMultipleChoice() {
        return questionType == QuestionType.MULTIPLE_CHOICE;
    }

    public boolean isTrueFalse() {
        return questionType == QuestionType.TRUE_FALSE;
    }

    public boolean isShortAnswer() {
        return questionType == QuestionType.SHORT_ANSWER;
    }

    public boolean isEasy() {
        return difficultyLevel == DifficultyLevel.EASY;
    }

    public boolean isMedium() {
        return difficultyLevel == DifficultyLevel.MEDIUM;
    }

    public boolean isHard() {
        return difficultyLevel == DifficultyLevel.HARD;
    }

    public boolean hasChoices() {
        return choices != null && !choices.isEmpty();
    }

    public Choice getCorrectChoice() {
        if (choices == null) return null;
        return choices.stream()
                .filter(Choice::getIsCorrect)
                .findFirst()
                .orElse(null);
    }

    public boolean isActiveQuestion() {
        return isActive != null && isActive;
    }
}
