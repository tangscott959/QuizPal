package com.example.quiz_project.service;


import com.example.quiz_project.dao.QuizDao;
import com.example.quiz_project.domain.Quiz;
import com.example.quiz_project.domain.QuizQuestion;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.sql.Timestamp;
import java.util.List;

@Service
public class QuizService {
    private final QuizDao quizDao;
    @Autowired
    public QuizService(QuizDao quizDao){
        this.quizDao=quizDao;
    }

    public List<Quiz> getALl(){
        return quizDao.getAll();
    }

    public List<Quiz> getByUser(int id) {
        return quizDao.getByUser(id);
    }
    public List<Quiz> getByCategory( int qid) {return quizDao.getByCategory(qid);}
    public Quiz getById(int id) {
        return quizDao.getById(id);
    }
    public int saveQuiz(Quiz q) {
        return quizDao.addQuiz(q);
    }

    public int updateQuiz(int quizId, Timestamp ts) {
        return quizDao.updateQuiz(quizId,ts);
    }
}
