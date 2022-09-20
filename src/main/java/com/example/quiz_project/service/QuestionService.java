package com.example.quiz_project.service;

import com.example.quiz_project.dao.ChoiceDao;
import com.example.quiz_project.dao.QuestionDao;
import com.example.quiz_project.dao.QuizQuestionDao;
import com.example.quiz_project.domain.Choice;
import com.example.quiz_project.domain.Question;
import com.example.quiz_project.domain.QuizQuestion;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.stream.Stream;

@Service
public class QuestionService {
    private final QuestionDao questionDao;
    private final ChoiceDao choiceDao;
    @Autowired
    public QuestionService(QuestionDao questionDao,ChoiceDao choiceDao) {
        this.questionDao = questionDao;
        this.choiceDao = choiceDao;
    }

    public List<Question> getRandom5(int cid) {
        return questionDao.getRandom5ByType(cid);
    }
    public List<Question> getAll() {
        return questionDao.getALl();
    }

    public Question getById(int id) {
        return questionDao.getById(id);
    }
    public void addQuestion(int categoryId,String description, int isActive,int isAnswer, List<String> choices) {
        int questionId = questionDao.addOne(categoryId,description,isActive);
        List<Choice> chList= new ArrayList<>();
        Stream.iterate(0, i -> i + 1).limit(choices.size()).forEach(index -> {
            String s = choices.get(index);
            Choice choice = new Choice();
            choice.setChoice_description(s);
            if (isAnswer == index)
                choice.setIs_correct(1);
            else
                choice.setIs_correct(0);
            choice.setQuestion_id(questionId);
            chList.add(choice);
        });
        choiceDao.addBatch(chList);
    }

    public void updateQuestion(int id, int quizType,int isAnswer,int status,String desc) {
        questionDao.updateOne(id,quizType,status,desc);
    }
}
