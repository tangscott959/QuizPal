package com.example.quiz_project.dao;

import com.example.quiz_project.domain.Choice;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

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

    public List<Choice> getByQuestionId(int id) {
        String query = "SELECT * FROM choice where question_id = ?";
        return jdbcTemplate.query(query,rowMapper,id);
    }
}
