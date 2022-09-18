package com.example.quiz_project.dao;

import com.example.quiz_project.domain.Category;
import com.example.quiz_project.domain.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Repository;

import java.util.List;

@Component
@Repository
public class CategoryDao {
    JdbcTemplate jdbcTemplate;
    CategoryRowMapper rowMapper;
    @Autowired
    public CategoryDao(JdbcTemplate jdbcTemplate, CategoryRowMapper rowMapper ){
        this.jdbcTemplate=jdbcTemplate;
        this.rowMapper=rowMapper;
    }
    public List<Category> getAllCategories(){
        String query = "SELECT * FROM category";
        return jdbcTemplate.query(query,rowMapper);
    }
    public Category getById(int id) {
        String query = "SELECT * FROM category WHERE category_id = ?";
        return jdbcTemplate.queryForObject(query,rowMapper,id);
    }


}
