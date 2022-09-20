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
import java.sql.Timestamp;
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
        String query = "SELECT * FROM quiz ORDER BY quiz_time_start DESC";
        return jdbcTemplate.query(query,rowMapper);
    }

    public List<Quiz> getByUser(int id) {
        String query = "SELECT * FROM quiz WHERE user_id = ? ORDER BY quiz_time_start DESC";
        return jdbcTemplate.query(query,rowMapper,id);
    }
    public List<Quiz> getByUserName(String pattern ) {
        String p = "%"+pattern+"%";
        String query = "SELECT * FROM quiz WHERE user_id IN (SELECT user_id FROM user WHERE firstname like ? OR lastname like ? ) ORDER BY quiz_time_start DESC";
        return jdbcTemplate.query(query,rowMapper,p,p);
    }
    public List<Quiz> getByCategory(int qid) {
        String query = "SELECT * FROM quiz WHERE category_id = ? ORDER BY quiz_time_start DESC";
        return jdbcTemplate.query(query,rowMapper,qid);
    }
    public Quiz getById(int id) {
        String query = "SELECT * FROM quiz WHERE quiz_id = ? ";
        return jdbcTemplate.queryForObject(query,rowMapper,id);
    }

    public int addQuiz(Quiz q) {
        KeyHolder keyHolder = new GeneratedKeyHolder();
        jdbcTemplate.update(con ->  {
            String sql="INSERT INTO quiz " +
                    "(user_id,category_id,quiz_name,quiz_time_start,quiz_time_end) " +
                    "VALUES(?,?,?,?,?)";
            PreparedStatement ps = con.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
            ps.setInt(1, q.getUserId());
            ps.setInt(2, q.getCategoryId());
            ps.setString(3,q.getQuizName());
            ps.setTimestamp(4,q.getQuizTimeStart());
            ps.setTimestamp(5,q.getQuizTimeEnd());
            return ps;
        }, keyHolder);
        return Optional.ofNullable(keyHolder.getKey()).orElse(0).intValue();
    }

    public int updateQuiz(int quizId, Timestamp ts) {
        String query = "Update quiz SET quiz_time_end =? WHERE quiz_id = ? ";
        return jdbcTemplate.update(query,ts,quizId);
    }
}
