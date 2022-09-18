package com.example.quiz_project.service;

import com.example.quiz_project.dao.QuestionDao;
import com.example.quiz_project.dao.QuizQuestionDao;
import com.example.quiz_project.domain.Choice;
import com.example.quiz_project.domain.Question;
import com.example.quiz_project.domain.QuizQuestion;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class QuestionService {
    private final QuestionDao questionDao;

    @Autowired
    public QuestionService(QuestionDao questionDao) {
        this.questionDao = questionDao;
    }

    public List<Question> getRandom5(int cid) {
        return questionDao.getRandom5ByType(cid);
    }

    public Question getById(int id) {
        return questionDao.getById(id);
    }
}
