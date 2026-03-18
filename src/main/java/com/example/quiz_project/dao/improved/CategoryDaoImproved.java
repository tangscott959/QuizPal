package com.example.quiz_project.dao.improved;

import com.example.quiz_project.domain.improved.Category;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;

import java.sql.PreparedStatement;
import java.sql.Statement;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public class CategoryDaoImproved {

    private final JdbcTemplate jdbcTemplate;
    private final RowMapper<Category> rowMapper;

    @Autowired
    public CategoryDaoImproved(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
        this.rowMapper = new CategoryRowMapper();
    }

    public List<Category> findAll() {
        String query = "SELECT * FROM category ORDER BY category_name";
        return jdbcTemplate.query(query, rowMapper);
    }

    public List<Category> findActiveCategories() {
        String query = "SELECT * FROM category WHERE is_active = true ORDER BY category_name";
        return jdbcTemplate.query(query, rowMapper);
    }

    public Optional<Category> findById(Integer categoryId) {
        try {
            String query = "SELECT * FROM category WHERE category_id = ?";
            Category category = jdbcTemplate.queryForObject(query, rowMapper, categoryId);
            return Optional.of(category);
        } catch (EmptyResultDataAccessException e) {
            return Optional.empty();
        }
    }

    public Optional<Category> findByName(String categoryName) {
        try {
            String query = "SELECT * FROM category WHERE category_name = ?";
            Category category = jdbcTemplate.queryForObject(query, rowMapper, categoryName);
            return Optional.of(category);
        } catch (EmptyResultDataAccessException e) {
            return Optional.empty();
        }
    }

    public boolean existsByName(String categoryName) {
        String query = "SELECT COUNT(*) FROM category WHERE category_name = ?";
        Integer count = jdbcTemplate.queryForObject(query, Integer.class, categoryName);
        return count != null && count > 0;
    }

    public Integer save(Category category) {
        if (category.getCategoryId() == null) {
            return insert(category);
        } else {
            update(category);
            return category.getCategoryId();
        }
    }

    private Integer insert(Category category) {
        KeyHolder keyHolder = new GeneratedKeyHolder();
        jdbcTemplate.update(connection -> {
            String sql = "INSERT INTO category (category_name, description, is_active) VALUES (?, ?, ?)";
            PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, category.getCategoryName());
            ps.setString(2, category.getDescription());
            ps.setBoolean(3, category.getIsActive() != null ? category.getIsActive() : true);
            return ps;
        }, keyHolder);
        return keyHolder.getKey().intValue();
    }

    public void update(Category category) {
        String sql = "UPDATE category SET category_name = ?, description = ?, is_active = ?, updated_at = ? WHERE category_id = ?";
        jdbcTemplate.update(sql, category.getCategoryName(), category.getDescription(), 
                category.getIsActive(), LocalDateTime.now(), category.getCategoryId());
    }

    public void deleteById(Integer categoryId) {
        String query = "DELETE FROM category WHERE category_id = ?";
        jdbcTemplate.update(query, categoryId);
    }

    public boolean hasQuestions(Integer categoryId) {
        String query = "SELECT COUNT(*) FROM question WHERE category_id = ?";
        Integer count = jdbcTemplate.queryForObject(query, Integer.class, categoryId);
        return count != null && count > 0;
    }

    public int count() {
        String query = "SELECT COUNT(*) FROM category";
        return jdbcTemplate.queryForObject(query, Integer.class);
    }

    public int countActive() {
        String query = "SELECT COUNT(*) FROM category WHERE is_active = true";
        return jdbcTemplate.queryForObject(query, Integer.class);
    }
}
