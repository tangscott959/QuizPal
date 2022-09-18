package com.example.quiz_project.service;

import com.example.quiz_project.dao.QuestionDao;
import com.example.quiz_project.dao.QuizQuestionDao;
import com.example.quiz_project.domain.QuizQuestion;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class QuizQuestionService {
    private final QuizQuestionDao quizQuestionDao;

    @Autowired
    public QuizQuestionService(QuizQuestionDao quizQuestionDao) {
        this.quizQuestionDao = quizQuestionDao;
    }

    public void saveQQ(List<QuizQuestion> qqList) {
        quizQuestionDao.addBatch(qqList);
    }


}
