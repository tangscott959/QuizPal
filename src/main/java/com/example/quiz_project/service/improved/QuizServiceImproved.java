package com.example.quiz_project.service.improved;

import com.example.quiz_project.domain.Quiz;
import com.example.quiz_project.dao.QuizDao;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class QuizServiceImproved {

    private final QuizDao quizDao;

    @Autowired
    public QuizServiceImproved(QuizDao quizDao) {
        this.quizDao = quizDao;
    }

    public List<Quiz> getQuizzesByUser(Integer userId) {
        return quizDao.getByUser(userId);
    }

    public Optional<Quiz> findById(Integer quizId) {
        try {
            Quiz quiz = quizDao.getById(quizId);
            return Optional.of(quiz);
        } catch (Exception e) {
            return Optional.empty();
        }
    }

    public Integer createQuiz(Quiz quiz) {
        return quizDao.addQuiz(quiz);
    }

    public void updateQuiz(Integer quizId, Timestamp endTime) {
        quizDao.updateQuiz(quizId, endTime);
    }

    public void updateQuiz(Quiz quiz) {
        if (quiz.getQuizTimeEnd() != null) {
            quizDao.updateQuiz(quiz.getQuizId(), quiz.getQuizTimeEnd());
        }
    }

    public List<Quiz> getAllQuizzes() {
        return quizDao.getAll();
    }
}
