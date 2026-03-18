package com.example.quiz_project.dao.improved;

import com.example.quiz_project.domain.improved.Category;
import org.springframework.jdbc.core.RowMapper;

import java.sql.ResultSet;
import java.sql.SQLException;

public class CategoryRowMapper implements RowMapper<Category> {

    @Override
    public Category mapRow(ResultSet rs, int rowNum) throws SQLException {
        Category category = new Category();
        category.setCategoryId(rs.getInt("category_id"));
        category.setCategoryName(rs.getString("category_name"));
        category.setDescription(rs.getString("description"));
        category.setIsActive(rs.getBoolean("is_active"));
        
        // Handle timestamp fields
        try {
            category.setCreatedAt(rs.getTimestamp("created_at") != null ? 
                rs.getTimestamp("created_at").toLocalDateTime() : null);
            category.setUpdatedAt(rs.getTimestamp("updated_at") != null ? 
                rs.getTimestamp("updated_at").toLocalDateTime() : null);
        } catch (SQLException e) {
            // Handle case where columns don't exist yet (backward compatibility)
            category.setCreatedAt(null);
            category.setUpdatedAt(null);
        }
        
        return category;
    }
}
