package com.example.quiz_project.service.improved;

import com.example.quiz_project.dao.improved.CategoryDaoImproved;
import com.example.quiz_project.domain.improved.Category;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class CategoryServiceImproved {

    private final CategoryDaoImproved categoryDao;

    @Autowired
    public CategoryServiceImproved(CategoryDaoImproved categoryDao) {
        this.categoryDao = categoryDao;
    }

    public List<Category> getAllCategories() {
        return categoryDao.findAll();
    }

    public List<Category> getActiveCategories() {
        return categoryDao.findActiveCategories();
    }

    public Optional<Category> findById(Integer categoryId) {
        return categoryDao.findById(categoryId);
    }

    public Optional<Category> findByName(String categoryName) {
        return categoryDao.findByName(categoryName);
    }

    public Category saveCategory(Category category) {
        if (category.getCategoryId() == null) {
            return createCategory(category);
        } else {
            return updateCategory(category);
        }
    }

    private Category createCategory(Category category) {
        Integer categoryId = categoryDao.save(category);
        category.setCategoryId(categoryId);
        return category;
    }

    private Category updateCategory(Category category) {
        categoryDao.update(category);
        return category;
    }

    public void deleteCategory(Integer categoryId) {
        // Check if category has questions before deleting
        if (categoryDao.hasQuestions(categoryId)) {
            throw new IllegalStateException("Cannot delete category that has associated questions");
        }
        categoryDao.deleteById(categoryId);
    }

    public void toggleCategoryStatus(Integer categoryId) {
        Optional<Category> categoryOpt = categoryDao.findById(categoryId);
        if (categoryOpt.isPresent()) {
            Category category = categoryOpt.get();
            category.setIsActive(!category.getIsActive());
            categoryDao.update(category);
        }
    }

    public boolean categoryExists(String categoryName) {
        return categoryDao.existsByName(categoryName);
    }

    public int getTotalCategoryCount() {
        return categoryDao.count();
    }

    public int getActiveCategoryCount() {
        return categoryDao.countActive();
    }
}
