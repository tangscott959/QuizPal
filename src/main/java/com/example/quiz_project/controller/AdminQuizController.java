package com.example.quiz_project.controller;

import com.example.quiz_project.domain.*;
import com.example.quiz_project.service.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


@Controller
public class AdminQuizController {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());
    private final CategoryService categoryService;
    private final QuizService quizService;
    private final QuizQuestionService quizQuestionService;
    private final QuestionService questionService;
    private final ChoiceService choiceService;
    public AdminQuizController(CategoryService categoryService, QuizService quizService, QuizQuestionService quizQuestionService, QuestionService questionService, ChoiceService choiceService){
        this.categoryService=categoryService;
        this.quizService=quizService;
        this.quizQuestionService=quizQuestionService;
        this.questionService=questionService;
        this.choiceService = choiceService;
    }

    @GetMapping(value ="adminquiz")
    public String adminquizindex(HttpServletRequest req, Model model,
                                       @RequestParam(name="sortByName" ,required=false)boolean sortFlag1,
                                       @RequestParam(name="sortByCategory" ,required=false)boolean sortFlag2){
        List<Category> categories = categoryService.getALl();
        Map<Integer,String> typeDic =new HashMap<>();
        categories.forEach(c->{
            typeDic.put(c.getCategoryId(),c.getCategoryName());
        });
        List<Quiz> quizList = quizService.getALl();
        List<Map<String,Object>> scores = quizQuestionService.calScoreAll();
        Map<String,String> scoreMap =new HashMap<>();
        scores.forEach(s-> {
            scoreMap.put(s.get("quiz_id").toString(), s.get("score").toString());
        });

        model.addAttribute("typeDic",typeDic);
        model.addAttribute("scoreMap",scoreMap);
        model.addAttribute("quizList",quizList);
        model.addAttribute("quizTypeList",categories);
        return "admin/adminresult";
    }

}
