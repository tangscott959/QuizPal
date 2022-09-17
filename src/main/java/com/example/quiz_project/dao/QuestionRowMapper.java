package com.example.quiz_project.dao;

import com.example.quiz_project.domain.Question;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Repository;

import java.sql.ResultSet;
import java.sql.SQLException;

@Component
@Repository
public class QuestionRowMapper implements RowMapper<Question> {
    @Override
    public Question mapRow(ResultSet rs, int rowNum) throws SQLException{
        Question questions = new Question();
        questions.setQuestion_id(rs.getInt("question_id"));
        questions.setCategory_id(rs.getInt("category_id"));
        questions.setQuiz_description(rs.getString("quiz_description"));
        questions.setIs_active(rs.getInt("is_active"));
        return questions;
    }
}
