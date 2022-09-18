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


    @Autowired
    public QuestionDao(JdbcTemplate jdbcTemplate, QuestionRowMapper rowMapper){
        this.jdbcTemplate=jdbcTemplate;
        this.rowMapper=rowMapper;
    }

    public List<Question> getRandom5ByType(int cid) {
        String query ="SELECT * FROM  question " +
                "WHERE  category_id = ? AND is_active =1 " +
                "ORDER BY RAND() LIMIT 5";
        return  this.jdbcTemplate.query(query,rowMapper,cid);
    }

    public Question getById(int id) {
        String query ="SELECT * FROM  question " +
                "WHERE  question_id = ?  " ;
        return  this.jdbcTemplate.queryForObject(query,rowMapper,id);
    }
}
