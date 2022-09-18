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



}
