package com.example.quiz_project.dao;

import com.example.quiz_project.domain.Choice;
import com.example.quiz_project.domain.QuizQuestion;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.util.ArrayList;
import java.util.List;

@Repository
public class ChoiceDao {
    JdbcTemplate jdbcTemplate;
    ChoiceRowMapper rowMapper;
    @Autowired
    public ChoiceDao(JdbcTemplate jdbcTemplate, ChoiceRowMapper rowMapper ){
        this.jdbcTemplate=jdbcTemplate;
        this.rowMapper=rowMapper;
    }
    // If you're using JDBC/MyBatis, add something like this to your ChoiceDao implementation:
    public void updateDescription(int choiceId, String description) {
        String sql = "UPDATE choice SET choice_description = ? WHERE choice_id = ?";
        // Execute the update query
        jdbcTemplate.update(sql, description, choiceId);
    }

    public Choice getById(int choiceId) {
        String sql = "SELECT * FROM choice WHERE choice_id = ?";
        // Execute select query and return Choice object
        return jdbcTemplate.queryForObject(sql, new BeanPropertyRowMapper<>(Choice.class), choiceId);
    }

    public List<Choice> getByQuestionId(int id) {
        String query = "SELECT * FROM choice where question_id = ?";
        return jdbcTemplate.query(query,rowMapper,id);
    }

    public void addBatch(List<Choice> cList) {
        String query ="INSERT INTO choice " +
                "(question_id,choice_description,is_correct) " +
                "VALUES(?,?,?)";
        List<Object[]> ba = new ArrayList<>();
        Object[] arr = null;
        for(Choice e : cList) {
            arr= new Object[]{e.getQuestion_id(),e.getChoice_description(),e.getIs_correct()};
            ba.add(arr);
        }
        jdbcTemplate.batchUpdate(query,ba);
    }
    public void updateOne(int id,int answer) {
        String query = "UPDATE choice SET is_correct = ? WHERE choice_id = ?";
        jdbcTemplate.update(query,answer,id);
    }
    public void updateByQId(int qid,int answer) {
        String query = "UPDATE choice SET is_correct = ? WHERE question_id = ?";
        jdbcTemplate.update(query,answer,qid);
    }

}
