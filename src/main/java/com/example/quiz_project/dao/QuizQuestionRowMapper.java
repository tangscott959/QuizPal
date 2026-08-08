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
        quizQuestion.setQuizquestionId(rs.getInt("answer_id"));
        quizQuestion.setQuizId(rs.getInt("quiz_id"));
        quizQuestion.setQuestionId(rs.getInt("question_id"));
        int choiceId = rs.getInt("selected_choice_id");
        quizQuestion.setChoiceId(rs.wasNull() ? 0 : choiceId);
        int isCorrect = rs.getInt("is_correct");
        quizQuestion.setIs_marked(rs.wasNull() ? -1 : isCorrect);

        return quizQuestion;
    }
}
