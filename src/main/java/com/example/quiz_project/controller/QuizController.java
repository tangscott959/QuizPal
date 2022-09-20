package com.example.quiz_project.controller;

import com.example.quiz_project.domain.*;
import com.example.quiz_project.service.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
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
public class QuizController {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());
    private final CategoryService categoryService;
    private final QuizService quizService;
    private final QuizQuestionService quizQuestionService;
    private final QuestionService questionService;
    private final ChoiceService choiceService;
    public QuizController(CategoryService categoryService, QuizService quizService, QuizQuestionService quizQuestionService, QuestionService questionService,ChoiceService choiceService){
        this.categoryService=categoryService;
        this.quizService=quizService;
        this.quizQuestionService=quizQuestionService;
        this.questionService=questionService;
        this.choiceService = choiceService;
    }
    @GetMapping("/quizindex")
    public String quizindex(HttpServletRequest req,Model model) {
        HttpSession session = req.getSession(false);
        User currentUser = (User) session.getAttribute("user");
        List<Category> categories = categoryService.getALl();
        Map<Integer,String> typeDic =new HashMap<>();
        categories.forEach(c->{
            typeDic.put(c.getCategoryId(),c.getCategoryName());
        });
        List<Quiz> quizList = quizService.getByUser(currentUser.getId());
        List<Map<String,Object>> scores = quizQuestionService.calScore(currentUser.getId());
        Map<String,String> scoreMap =new HashMap<>();

        scores.forEach(s-> {
            scoreMap.put(s.get("quiz_id").toString(), s.get("score").toString());
        });

        model.addAttribute("typeDic",typeDic);
        model.addAttribute("scoreMap",scoreMap);
        model.addAttribute("quizList",quizList);
        model.addAttribute("quizTypeList",categories);
        return "home";
    }

    @GetMapping("/resultdetail")
    public String quizDetails(HttpServletRequest req,Model model,@RequestParam(name="resultId") int quizId) {
        HttpSession session = req.getSession(false);
        User currentUser = (User) session.getAttribute("user");
        model.addAttribute("user",currentUser);

        Quiz quiz = quizService.getById(quizId);
        int score = quizQuestionService.calScoreOne(quizId);

        model.addAttribute("score",score);
        model.addAttribute("quizdetail",quiz);
        List<QuizQuestion> qqList = quizQuestionService.getByQuizId(quizId);
        List<QuestionChoice> qcList = new ArrayList<>();
        qqList.forEach(qq->{
            QuestionChoice qc = new QuestionChoice();
            qc.setQuestionId(qq.getQuestionId());
            qc.setUserChoice(qq.getChoiceId());
            qc.setDescription(questionService.getById(qq.getQuestionId()).getQuiz_description());
            qc.setChoiceList(choiceService.getByQid(qq.getQuestionId()));
            qcList.add(qc);
        });
        model.addAttribute("qclist",qcList);
        logger.info("qclist {}",qcList);
        return "quiz";
    }
    private int initQuiz(User u,Category c) {
        Timestamp startTime = new Timestamp(System.currentTimeMillis());

        Quiz quiz = new Quiz();
        quiz.setQuizName(u.getFullName()+"-"+c.getCategoryName());
        quiz.setUserId(u.getId());
        quiz.setCategoryId(c.getCategoryId());
        quiz.setQuizTimeStart(startTime);
        return quizService.saveQuiz(quiz);
    }

    @GetMapping(value ="/doquiz")
    @SuppressWarnings("unchecked")
    protected ModelAndView pageQuestions(HttpServletRequest req, @RequestParam("action") String action,
                                         @RequestParam(name="qtid" ,required=false) int cid,
                                         @RequestParam(name="page") int page,
                                         @RequestParam(name="lefttime") int leftTime){
        HttpSession session = req.getSession(false);
        ModelAndView mv =new ModelAndView();
        String sel =req.getParameter("optradio");
        User u = (User) session.getAttribute("user");
        List<QuizQuestion> qqList;
        if(action.equals("init")) {
            qqList = new ArrayList<>();
            Category category = categoryService.getById(cid);
            int quizid = initQuiz(u,category);

            List<Question> questionList = questionService.getRandom5(cid);
            questionList.forEach(q->{
               QuizQuestion qq = new QuizQuestion();
               qq.setQuestionId(q.getQuestion_id());
               qq.setChoiceId(0);
               qq.setQuizId(quizid);
               qqList.add(qq);
            });
            session.setAttribute("qqlist",qqList);
            session.setAttribute("quizKey",quizid);
            Question q = questionList.get(0);
            mv.addObject("leftTime",leftTime*60);
            mv.addObject("qq",qqList.get(0));
            mv.addObject("question",q);
            mv.addObject("choices",choiceService.getByQid(q.getQuestion_id()));
            mv.addObject("pageSize", qqList.size());
            mv.addObject("currentPage", page );
            mv.setViewName("paper");
        }
        else {
            qqList = (List<QuizQuestion>) session.getAttribute("qqlist");
            QuizQuestion qq = qqList.get(page);
            if(sel !=null) {
                qq.setChoiceId(Integer.parseInt(sel));
                session.setAttribute("qqlist", qqList);
            }
            mv.addObject("leftTime",leftTime);
            mv.addObject("pageSize", qqList.size());
            switch (action) {
                case "next":
                    page = page + 1;
                    Question q = questionService.getById(qqList.get(page).getQuestionId());
                    List<Choice> c = choiceService.getByQid(q.getQuestion_id());
                    mv.addObject("qq",qqList.get(page));
                    mv.addObject("currentPage", page );
                    mv.addObject("question", q);
                    mv.addObject("choices",c);
                    mv.setViewName("paper");
                    break;
                case "prev":
                    page = page - 1;
                    Question q1 = questionService.getById(qqList.get(page).getQuestionId());
                    List<Choice> c1 = choiceService.getByQid(q1.getQuestion_id());

                    mv.addObject("qq",qqList.get(page));
                    mv.addObject("currentPage", page );
                    mv.addObject("question", q1);
                    mv.addObject("choices",c1);
                    mv.setViewName("paper");
                    break;
                case "finish":
                    int key = (int) session.getAttribute("quizKey");
                    Timestamp endTime = new Timestamp(System.currentTimeMillis());
                    quizService.updateQuiz(key,endTime);
                    quizQuestionService.saveQQ(qqList);
                    mv.setViewName("forward:/quizindex");
                    break;
                 default:
                    page = Integer.parseInt(action);
                    Question qd = questionService.getById(qqList.get(page).getQuestionId());
                    List<Choice> cd = choiceService.getByQid(qd.getQuestion_id());
                    mv.addObject("qq",qqList.get(page));
                    mv.addObject("currentPage", page );
                    mv.addObject("question", qd);
                    mv.addObject("choices",cd);
                    mv.setViewName("paper");


            }
        }
        return mv;
    }

}
