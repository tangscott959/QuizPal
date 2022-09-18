package com.example.quiz_project.dao;

import com.example.quiz_project.domain.Quiz;
import com.example.quiz_project.domain.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Repository;

import java.sql.PreparedStatement;
import java.util.List;
import java.util.Optional;

@Repository
@Component
public class QuizDao {
    JdbcTemplate jdbcTemplate;
    QuizRowMapper rowMapper;
    @Autowired
    public QuizDao(JdbcTemplate jdbcTemplate, QuizRowMapper rowMapper ){
        this.jdbcTemplate=jdbcTemplate;
        this.rowMapper=rowMapper;
    }

    public List<Quiz> getAll() {
        String query = "SELECT * FROM quiz";
        return jdbcTemplate.query(query,rowMapper);
    }

    public int addQuiz(Quiz q) {
        KeyHolder keyHolder = new GeneratedKeyHolder();
        jdbcTemplate.update(con ->  {
            String sql="INSERT INTO quiz " +
                    "(user_id,category_id,quiz_name,quiz_time_start,quiz_time_end) " +
                    "VALUES(?,?,?,?)";
            PreparedStatement ps = con.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
            ps.setInt(1, q.getUserId());
            ps.setInt(2, q.getCategoryId());
            ps.setString(3,q.getQuizName());
            ps.setTimestamp(4,q.getQuizTimeStart());
            return ps;
        }, keyHolder);
        return Optional.ofNullable(keyHolder.getKey()).orElse(0).intValue();
    }
}
