package com.example.quiz_project.dao;

import com.example.quiz_project.domain.Quiz;
import com.example.quiz_project.domain.QuizQuestion;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Repository;

import java.util.ArrayList;
import java.util.List;

@Repository
public class QuizQuestionDao {
    JdbcTemplate jdbcTemplate;
    QuizQuestionRowMapper rowMapper;
    @Autowired
    public QuizQuestionDao(JdbcTemplate jdbcTemplate, QuizQuestionRowMapper rowMapper ){
        this.jdbcTemplate=jdbcTemplate;
        this.rowMapper=rowMapper;
    }

    public List<QuizQuestion> getAll() {
        String query = "SELECT * FROM quizquestion";
        return jdbcTemplate.query(query,rowMapper);
    }

    public void addBatch(List<QuizQuestion> qList) {
        String query ="INSERT INTO quizquestion " +
                "(quiz_id,question_id,choice_id,order_num) " +
                "VALUES(?,?,?,?)";
        List<Object[]> ba = new ArrayList<>();
        Object[] arr = null;
        for(QuizQuestion e : qList) {
            arr= new Object[]{e.getQuizId(),e.getQuestionId(),e.getChoiceId(),0};
            ba.add(arr);
        }
        jdbcTemplate.batchUpdate(query,ba);
    }
}
