package com.example.quiz_project.dao;


import com.example.quiz_project.domain.Category;
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
    public CategoryDao(JdbcTemplate jdbcTemplate, CategoryRowMapper rowMapper){
        this.jdbcTemplate=jdbcTemplate;
        this.rowMapper=rowMapper;

    }
    public List<Category> getAllCategory(){
        String query = "SELECT * FROM category";
        List<Category> categories = jdbcTemplate.query(query,rowMapper);
        return categories;
    }
}
