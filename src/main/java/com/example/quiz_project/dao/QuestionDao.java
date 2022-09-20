package com.example.quiz_project.dao;

import com.example.quiz_project.domain.Choice;
import com.example.quiz_project.domain.Question;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Repository;

import java.sql.PreparedStatement;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

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

    public List<Question> getRandom5ByType(int cid) {
        String query ="SELECT * FROM  question " +
                "WHERE  category_id = ? AND is_active =1 " +
                "ORDER BY RAND() LIMIT 5";
        return  this.jdbcTemplate.query(query,rowMapper,cid);
    }

    public List<Question> getALl() {
        String query ="SELECT * FROM  question " +
                "ORDER BY category_id";
        return  this.jdbcTemplate.query(query,rowMapper);
    }
    public Question getById(int id) {
        String query ="SELECT * FROM  question " +
                "WHERE  question_id = ?  " ;
        return  this.jdbcTemplate.queryForObject(query,rowMapper,id);
    }

    public int addOne(int categoryId,String description, int isActive){
        KeyHolder keyHolder = new GeneratedKeyHolder();
        jdbcTemplate.update(con ->  {
            String sql ="INSERT INTO question " +
                    "(category_id,quiz_description,is_active) VALUES( ?,?,? )";
            PreparedStatement ps = con.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
            ps.setInt(1, categoryId);
            ps.setString(2, description);
            ps.setInt(3,isActive);
            return ps;
        }, keyHolder);
        return Optional.ofNullable(keyHolder.getKey()).orElse(0).intValue();
    }

    public int updateOne(int id, int quizType,int status,String desc) {
        String query = "Update question SET category_id =?, quiz_description= ?, is_active= ? " +
                "WHERE question_id = ? ";
        return jdbcTemplate.update(query,quizType,desc,status,id);
    }
}
