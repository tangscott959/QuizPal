package com.example.quiz_project.dao;

import com.example.quiz_project.domain.Quiz;
import com.example.quiz_project.domain.QuizQuestion;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Repository;

import java.sql.ResultSet;
import java.sql.SQLException;

@Component
@Repository
public class QuizQuestionRowMapper implements RowMapper<QuizQuestion> {
    @Override
    public QuizQuestion mapRow(ResultSet rs, int rowNum) throws SQLException{
        QuizQuestion quizQuestion =new QuizQuestion();
        quizQuestion.setQuizquestionId(rs.getInt("quizquestion_id"));
        quizQuestion.setQuizId(rs.getInt("quiz_id"));
        quizQuestion.setQuestionId(rs.getInt("question_id"));
        quizQuestion.setChoiceId(rs.getInt("choice_id"));
        quizQuestion.setOrderNum(rs.getInt("order_num"));

        return quizQuestion;

    }
}
