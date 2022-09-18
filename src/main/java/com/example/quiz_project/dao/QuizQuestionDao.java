package com.example.quiz_project.dao;

import com.example.quiz_project.domain.Quiz;
import com.example.quiz_project.domain.QuizQuestion;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Repository;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

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

    public List<Map<String,Object>> getScoreByQuiz(int uid) {
        String query ="SELECT quiz_id,count(*) AS score FROM quizquestion " +
                "WHERE quiz_id IN (select quiz_id from quiz where user_id =?)   " +
                "AND choice_id IN (SELECT choice_id FROM choice WHERE is_correct =1) " +
                "GROUP BY quiz_id";
        return jdbcTemplate.queryForList(query,uid);
    }
}
