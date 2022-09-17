package com.example.quiz_project.dao;

import com.example.quiz_project.domain.Choice;
import com.example.quiz_project.domain.Question;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Repository;

import java.util.ArrayList;
import java.util.List;

@Repository
@Component
public class QuestionDao {
    JdbcTemplate jdbcTemplate;
    QuestionRowMapper rowMapper;
    private static final Question question;
    private static final List<Choice> choices;
    static {
        choices = new ArrayList<>();
        choices.add(new Choice(1,1, "42",0));
        choices.add(new Choice(2,2, "correct answer",1));
        choices.add(new Choice(3,3, "yes",1));
        question = new Question(
                1,
                1,
                "1+1=?",
                1);
    }

    @Autowired
    public QuestionDao(JdbcTemplate jdbcTemplate, QuestionRowMapper rowMapper){
        this.jdbcTemplate=jdbcTemplate;
        this.rowMapper=rowMapper;
    }
    public Question getQuestion() {
        return question;
    }
//    public Question getQuestion(){
//        String query = "SELECT * FROM "
//
//    }


}
