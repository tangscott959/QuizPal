package com.example.quiz_project.dao;

import com.example.quiz_project.domain.Choice;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Repository;

import java.sql.ResultSet;
import java.sql.SQLException;

@Component
@Repository
public class ChoiceRowMapper implements RowMapper<Choice> {
    @Override
    public Choice mapRow(ResultSet rs, int rowNum) throws SQLException{
        Choice choice = new Choice();
        choice.setChoice_id(rs.getInt("choice_id"));
        choice.setQuestion_id(rs.getInt("question_id"));
        choice.setChoice_description(rs.getString("choice_description"));
        choice.setIs_correct(rs.getInt("is_correct"));
        return choice;


    }
}
