package com.example.quiz_project.dao;

import com.example.quiz_project.domain.Feedback;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Repository;

import java.sql.Timestamp;
import java.util.List;

@Component
@Repository
public class FeedbackDao {
    JdbcTemplate jdbcTemplate;
    FeedbackRowMapper rowMapper;

    @Autowired
    public FeedbackDao(JdbcTemplate jdbcTemplate, FeedbackRowMapper rowMapper){
        this.jdbcTemplate=jdbcTemplate;
        this.rowMapper=rowMapper;
    }
    public List<Feedback> getAllFeedbacks(){
        String query = "SELECT * FROM feedback";
        List<Feedback> feedbacks = jdbcTemplate.query(query,rowMapper);
        return feedbacks;
    }
    public void addFeedback(String message, int rating, Timestamp submit_date){
        String query = "INSERT INTO feedback (message,rating,submit_date) VALUES(?,?,?)";
        jdbcTemplate.update(query,message,rating,submit_date);
        System.out.println("feedback added");
    }
}
