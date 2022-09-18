package com.example.quiz_project.controller;

import com.example.quiz_project.dao.CategoryDao;
import com.example.quiz_project.domain.*;
import com.example.quiz_project.service.CategoryService;
import com.example.quiz_project.service.QuestionService;
import com.example.quiz_project.service.QuizQuestionService;
import com.example.quiz_project.service.QuizService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;


import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;


@Controller
public class QuizController {
    private Logger logger = LoggerFactory.getLogger(this.getClass());
    @Autowired
    private CategoryService categoryService;
    @Autowired
    private QuizService quizService;
    @Autowired
    private QuizQuestionService quizQuestionService;
    @Autowired
    private QuestionService questionService;

    @GetMapping("/quizindex")
    public String quizindex(Model model) {
        List<Category> categories = categoryService.getALl();
        model.addAttribute("quizTypeList",categories);
        return "home";
    }

    private void initQuiz(User u,Category c) {
        Timestamp startTime = new Timestamp(System.currentTimeMillis());

        Quiz quiz = new Quiz();
        quiz.setQuizName(u.getFullName()+c.getCategoryName());
        quiz.setUserId(u.getId());
        quiz.setCategoryId(c.getCategoryId());
        quiz.setQuizTimeStart(startTime);
        quizService.saveQuiz(quiz);
    }

    @GetMapping(value ="/doquiz")
    protected ModelAndView pageQuestions(HttpServletRequest req, @RequestParam("action") String action,
                                         @RequestParam(name="qtid" ,required=false) int cid,
                                         @RequestParam(name="page") int page,
                                         @RequestParam(name="lefttime") int leftTime){
        HttpSession session = req.getSession(false);
        ModelAndView mv =new ModelAndView();
        String sel =req.getParameter("optradio");
        User u = (User) session.getAttribute("user");
        Category category = categoryService.getById(cid);

        if(action.equals("init")) {
            List<QuizQuestion> qList = new ArrayList<>();
            initQuiz(u,category);
            List<Question> questionList = questionService.getRandom5(cid);
            questionList.forEach(q->{
               QuizQuestion qq = new QuizQuestion();
               qq.setQuestionId(q.getQuestion_id());
               qq.setChoiceId(99);
               qq.setQuizId(cid);
               qList.add(qq);
            });

            quizQuestionService.saveQQ(qList);
            mv.addObject("resultlist",qList.get(0));
            mv.addObject("pageSize", qList.size());
            mv.addObject("currentPage", page );
            mv.setViewName("paper");
            return mv;
        }
        else {
//            List<QuestionAnswer> rList = (List<QuestionAnswer>) session.getAttribute("questionlist");
//            List<Result> savedList = (List<Result>) session.getAttribute("resultlist");
//            QuestionAnswer qa = rList.get(page);
//
//            Result r = savedList.get(page);
//            if (sel != null) {
//                String userAnswer = qa.getOptions().get(sel);
//                String answer = qa.getAnswer();
//                int selection = 0;
//                switch (sel) {
//                    case "a":
//                        break;
//                    case "b":
//                        selection = 1;
//                        break;
//                    case "c":
//                        selection = 2;
//                        break;
//                    case "d":
//                        selection = 3;
//                }
//                r.setSelAnswer(selection);
//                r.setChoice(qa.getQuestion().getChoice().get(selection));
//                if (Objects.equals(r.getQuestion().getId(), qa.getQuestion().getId())) {
//                    if (userAnswer.equals(answer))
//                        r.setIsAnswer(1);
//                }
//                qa.setUserSelection(sel);
//            }
//            session.setAttribute("resultlist", savedList);
//            mv.addObject("leftTime",leftTime);
//            mv.addObject("pageSize", rList.size());
//            switch (action) {
//                case "next":
//                    page = page + 1;
//                    mv.addObject("currentPage", page );
//                    mv.addObject("questionAnswer", rList.get(page));
//                    mv.setViewName("paper");
//                    break;
//                case "prev":
//                    page = page - 1;
//                    mv.addObject("currentPage", page );
//                    mv.addObject("questionAnswer", rList.get(page));
//                    mv.setViewName("paper");
//                    break;
//                case "finish":
//                    resultService.save(savedList);
//                    mv.setViewName("forward:/home");
//                    break;
//            }
            return mv;
        }
    }
}
