package com.example.quiz_project.domain.improved;

import lombok.*;
import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class Quiz {
    private Integer quizId;
    private Integer userId;
    private Integer categoryId;
    private String quizName;
    private LocalDateTime quizTimeStart;
    private LocalDateTime quizTimeEnd;
    private Integer timeLimitMinutes;
    private Integer totalQuestions;
    private Integer score;
    private Integer maxScore;
    private QuizStatus status;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public enum QuizStatus {
        IN_PROGRESS, COMPLETED, ABANDONED
    }

    public boolean isCompleted() {
        return status == QuizStatus.COMPLETED;
    }

    public boolean isInProgress() {
        return status == QuizStatus.IN_PROGRESS;
    }

    public boolean isAbandoned() {
        return status == QuizStatus.ABANDONED;
    }

    public long getDurationInSeconds() {
        if (quizTimeStart != null && quizTimeEnd != null) {
            return java.time.Duration.between(quizTimeStart, quizTimeEnd).getSeconds();
        }
        return 0;
    }

    public double getScorePercentage() {
        if (maxScore == null || maxScore == 0) return 0.0;
        return (double) (score != null ? score : 0) / maxScore * 100;
    }

    public boolean hasTimeLimit() {
        return timeLimitMinutes != null && timeLimitMinutes > 0;
    }

    public boolean isTimeExpired() {
        if (!hasTimeLimit() || quizTimeStart == null) return false;
        LocalDateTime expiryTime = quizTimeStart.plusMinutes(timeLimitMinutes);
        return LocalDateTime.now().isAfter(expiryTime);
    }
}
