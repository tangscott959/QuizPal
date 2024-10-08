package com.example.quiz_project.service;

import com.example.quiz_project.dao.QuestionDao;
import com.example.quiz_project.dao.QuizQuestionDao;
import com.example.quiz_project.domain.QuizQuestion;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class QuizQuestionService {
    private final QuizQuestionDao quizQuestionDao;

    @Autowired
    public QuizQuestionService(QuizQuestionDao quizQuestionDao) {
        this.quizQuestionDao = quizQuestionDao;
    }

    public List<QuizQuestion> getByQuizId(int qid) {
        return quizQuestionDao.getByQuizId(qid);
    }

    public void saveQQ(List<QuizQuestion> qqList) {
        quizQuestionDao.addBatch(qqList);
    }

    public List<Map<String,Object>> calScore(int uid) {
        return quizQuestionDao.getScoreByUser(uid);
    }

    public List<Map<String,Object>> calScoreAll() {
        return quizQuestionDao.getScoreAll();
    }

    public int calScoreOne(int qid) {
        return quizQuestionDao.getScoreByQuiz(qid);
    }
}
