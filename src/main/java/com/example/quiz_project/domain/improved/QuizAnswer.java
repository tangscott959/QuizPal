package com.example.quiz_project.domain.improved;

import lombok.*;
import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class QuizAnswer {
    private Integer answerId;
    private Integer quizId;
    private Integer questionId;
    private Integer selectedChoiceId;
    private String answerText;
    private Boolean isCorrect;
    private Integer pointsEarned;
    private Integer timeTakenSeconds;
    private LocalDateTime answeredAt;

    private Choice selectedChoice;
    private Question question;

    public boolean isAnsweredCorrectly() {
        return isCorrect != null && isCorrect;
    }

    public boolean isAnsweredIncorrectly() {
        return !isAnsweredCorrectly();
    }

    public boolean isMultipleChoiceAnswer() {
        return selectedChoiceId != null;
    }

    public boolean isShortAnswerAnswer() {
        return answerText != null && !answerText.trim().isEmpty();
    }

    public boolean hasPointsEarned() {
        return pointsEarned != null && pointsEarned > 0;
    }

    public String getDisplayAnswer() {
        if (isMultipleChoiceAnswer() && selectedChoice != null) {
            return selectedChoice.getDisplayText();
        } else if (isShortAnswerAnswer()) {
            return answerText;
        }
        return "No answer provided";
    }

    public boolean wasAnswered() {
        return isMultipleChoiceAnswer() || isShortAnswerAnswer();
    }
}
