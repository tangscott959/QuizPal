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
        String query = "SELECT * FROM quiz_answer";
        return jdbcTemplate.query(query,rowMapper);
    }
    public List<QuizQuestion> getByQuizId(int qid) {
        String query = "SELECT * FROM quiz_answer WHERE quiz_id= ? ORDER BY answer_id";
        return jdbcTemplate.query(query,rowMapper,qid);
    }

    public void addPlaceholderBatch(int quizId, List<Integer> questionIds) {
        String query = "INSERT INTO quiz_answer (quiz_id, question_id, selected_choice_id, is_correct) VALUES (?, ?, NULL, NULL)";
        List<Object[]> batch = new ArrayList<>();
        for (Integer questionId : questionIds) {
            batch.add(new Object[]{quizId, questionId});
        }
        jdbcTemplate.batchUpdate(query, batch);
    }

    public int updateAnswer(int quizId, int questionId, int selectedChoiceId, boolean isCorrect) {
        String query = "UPDATE quiz_answer SET selected_choice_id = ?, is_correct = ? " +
                "WHERE quiz_id = ? AND question_id = ? AND selected_choice_id IS NULL";
        return jdbcTemplate.update(query, selectedChoiceId, isCorrect, quizId, questionId);
    }

    public int countAnswered(int quizId) {
        String query = "SELECT COUNT(*) FROM quiz_answer WHERE quiz_id = ? AND selected_choice_id IS NOT NULL";
        Integer count = jdbcTemplate.queryForObject(query, Integer.class, quizId);
        return count != null ? count : 0;
    }
    public void addBatch(List<QuizQuestion> qList) {
        String query ="INSERT INTO quiz_answer " +
                "(quiz_id,question_id,selected_choice_id,is_correct) " +
                "VALUES(?,?,?,?)";
        List<Object[]> ba = new ArrayList<>();
        Object[] arr = null;
        for(QuizQuestion e : qList) {
            arr= new Object[]{e.getQuizId(),e.getQuestionId(),e.getChoiceId(),0};
            ba.add(arr);
        }
        jdbcTemplate.batchUpdate(query,ba);
    }

    public List<Map<String,Object>> getScoreByUser(int uid) {
        String query ="SELECT quiz_id,count(*) AS score FROM quiz_answer " +
                "WHERE quiz_id IN (select quiz_id from quiz where user_id =?)   " +
                "AND selected_choice_id IN (SELECT choice_id FROM choice WHERE is_correct =1) " +
                "GROUP BY quiz_id";
        return jdbcTemplate.queryForList(query,uid);
    }

    public List<Map<String,Object>> getScoreAll() {
        String query ="SELECT quiz_id,count(*) AS score FROM quiz_answer " +
                "WHERE selected_choice_id IN (SELECT choice_id FROM choice WHERE is_correct =1) " +
                "GROUP BY quiz_id";
        return jdbcTemplate.queryForList(query);
    }


    public int getScoreByQuiz(int qid) {
        String query ="SELECT count(*) AS score FROM quiz_answer " +
                "WHERE quiz_id =? " +
                "AND selected_choice_id IN (SELECT choice_id FROM choice WHERE is_correct =1) "
                ;
        return jdbcTemplate.queryForObject(query,Integer.class,qid);
    }


}
