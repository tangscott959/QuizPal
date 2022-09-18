package com.example.quiz_project.service;

import com.example.quiz_project.dao.CategoryDao;
import com.example.quiz_project.dao.UserDao;
import com.example.quiz_project.domain.Category;
import com.example.quiz_project.domain.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class CategoryService {
    private final CategoryDao categoryDao;
    @Autowired
    public CategoryService(CategoryDao categoryDao){
        this.categoryDao=categoryDao;
    }

    public List<Category> getALl(){
        return categoryDao.getAllCategories();
    }

    public Category getById(int id) {return categoryDao.getById(id);}

}
