package com.example.quiz_project.dao;

import com.example.quiz_project.domain.Quiz;
import com.example.quiz_project.domain.User;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Repository;

import java.sql.ResultSet;
import java.sql.SQLException;

@Component
@Repository
public class QuizRowMapper implements RowMapper<Quiz> {
    @Override
    public Quiz mapRow(ResultSet rs, int rowNum) throws SQLException{
        Quiz quiz =new Quiz();
        quiz.setQuizId(rs.getInt("quiz_id"));
        quiz.setUserId(rs.getInt("user_id"));
        quiz.setCategoryId(rs.getInt("category_id"));
        quiz.setQuizName(rs.getString("quiz_name"));
        quiz.setQuizTimeStart(rs.getTimestamp("quiz_time_start"));
        quiz.setQuizTimeEnd(rs.getTimestamp("quiz_time_end"));
        return quiz;

    }
}
