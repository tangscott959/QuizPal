package com.example.quiz_project.service;


import com.example.quiz_project.dao.ChoiceDao;
import com.example.quiz_project.domain.Choice;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class ChoiceService {
    private final ChoiceDao choiceDao;
    @Autowired
    public ChoiceService(ChoiceDao choiceDao){
        this.choiceDao=choiceDao;
    }

    public List<Choice> getByQid(int id){
        return choiceDao.getByQuestionId(id);
    }
    @Transactional
    public void setAnswer(int questionId,int choiceId) {
        choiceDao.updateByQId(questionId,0);
        choiceDao.updateOne(choiceId,1);
    }

}
