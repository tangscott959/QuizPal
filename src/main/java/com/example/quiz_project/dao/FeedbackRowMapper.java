package com.example.quiz_project.dao;

import com.example.quiz_project.domain.Feedback;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Repository;

import java.sql.ResultSet;
import java.sql.SQLException;

@Component
@Repository
public class FeedbackRowMapper implements RowMapper<Feedback> {
    @Override
    public Feedback mapRow(ResultSet rs, int rowNum) throws SQLException{
        Feedback feedback = new Feedback();
        feedback.setFeedbackId(rs.getInt("feedback_id"));
        feedback.setMessage(rs.getString("message"));
        feedback.setRating(rs.getInt("rating"));
        feedback.setSubmitDate(rs.getTimestamp("submit_date"));
        return feedback;
    }
}
