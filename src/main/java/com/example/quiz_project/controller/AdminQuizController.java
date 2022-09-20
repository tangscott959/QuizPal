package com.example.quiz_project.controller;

import com.example.quiz_project.dao.UserDao;
import com.example.quiz_project.domain.*;
import com.example.quiz_project.service.*;
import lombok.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.sql.Timestamp;
import java.util.*;


@Controller
public class AdminQuizController {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());
    private final CategoryService categoryService;
    private final QuizService quizService;
    private final QuizQuestionService quizQuestionService;
    private final QuestionService questionService;
    private final ChoiceService choiceService;
    private final UserService userService;
    private final ContactService contactService;
    private final FeedbackService feedbackService;
    public AdminQuizController(CategoryService categoryService, QuizService quizService,
                               QuizQuestionService quizQuestionService, QuestionService questionService,
                               ChoiceService choiceService,UserService userService, ContactService contactService, FeedbackService feedbackService){
        this.categoryService=categoryService;
        this.quizService=quizService;
        this.quizQuestionService=quizQuestionService;
        this.questionService=questionService;
        this.choiceService = choiceService;
        this.userService = userService;
        this.contactService =contactService;
        this.feedbackService =feedbackService;
    }

    @GetMapping(value ="adminquiz")
    public String adminquizindex(Model model,
                                       @RequestParam(name="sortByName" ,required=false)String sortFlag1,
                                       @RequestParam(name="sortByCategory" ,required=false)String sortFlag2){
        List<QuizResultTable> qrtList = new ArrayList<>();
        List<Quiz> quizList ;

        List<Category> categories = categoryService.getALl();
        List<User> usersList = userService.getAllUsers();

        if( null == sortFlag2 || sortFlag2.equals("0"))
            if( null != sortFlag1 )
                quizList = quizService.getByUserName(sortFlag1);
            else
                quizList = quizService.getALl();
        else
            quizList = quizService.getByCategory(Integer.parseInt(sortFlag2));
        List<Map<String,Object>> scores = quizQuestionService.calScoreAll();
        for (Quiz quiz : quizList) {
                QuizResultTable qrt = new QuizResultTable();
                qrt.setQuizId(quiz.getQuizId());
                qrt.setQuizName(quiz.getQuizName());
                qrt.setStartTime(quiz.getQuizTimeStart());
                qrt.setEndTime(quiz.getQuizTimeEnd());
                User user = usersList.stream().filter(u-> u.getId() == quiz.getUserId()).findAny().orElse(null);
                if (user != null) {
                    qrt.setUserName(usersList.stream().filter(u-> u.getId() == quiz.getUserId()).findAny().get().getFullName());
                }
                else {
                    qrt.setUserName(null);
                }
                qrt.setCategory(categories.stream().filter(c -> c.getCategoryId() == quiz.getCategoryId())
                        .findAny().get().getCategoryName());
                Map<String,Object> score = scores.stream().filter(s->(Integer)s.get("quiz_id") == quiz.getQuizId()).findAny().orElse(null);
                if( score!=null )
                    qrt.setScore(score.get("score").toString());
                else
                    qrt.setScore("0");
                qrtList.add(qrt);
        }
        model.addAttribute("category",categories);
        model.addAttribute("qrtList",qrtList);
        return "admin/adminresult";
    }

    @GetMapping("/adminresultdetail")
    public String quizDetails(HttpServletRequest req,Model model,@RequestParam(name="resultId") int quizId) {
        Quiz quiz = quizService.getById(quizId);
        User u = userService.getUserById(quiz.getUserId());
        int score = quizQuestionService.calScoreOne(quizId);

        model.addAttribute("user",u);
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
        return "admin/adminquiz";
    }

    @GetMapping(value ="adminallquestions")
    protected ModelAndView listall(@RequestParam(name="pageNum")int pageNum) {
        ModelAndView mv =new ModelAndView();
        List<Sort.Order> orders = new ArrayList<Sort.Order>();
        orders.add(new Sort.Order(Sort.Direction.ASC,"quizType.id"));
        Sort sort = Sort.by(orders);
        List<Question> questionList = questionService.getAll();
        List<Category> qzList = categoryService.getALl();
        mv.addObject("qzTypes",qzList);
        mv.addObject("qList",questionList);
        mv.setViewName("admin/adminquestion");
        return mv;
    }
    @PostMapping(value = "/admin/addquestion")
    protected String addQuestion(@RequestParam(name="quizType") int quizType ,@RequestParam(name="desc") String desc,
                                 @RequestParam(name="choices") List<String> choices,@RequestParam(name="isAnswerOption") int isAnswer) {
        questionService.addQuestion(quizType,desc,1,isAnswer,choices);
        return("redirect:/adminallquestions?pageNum=1");
    }
    @GetMapping(value ="/admindetail")
    protected String QuesstionDetail(Model model , @RequestParam(name="questionId")int qId) {
        Question question = questionService.getById(qId);
        List<Category> qzList = categoryService.getALl();
        List<Choice> cList = choiceService.getByQid(qId);
        model.addAttribute("qzTypes",qzList);
        model.addAttribute("detailInfo",question);
        model.addAttribute("choices",cList);
        return "admin/adminedit";
    }
    @PostMapping(value = "/admin/updatequestion")
    protected String editQuestion(@RequestParam(name="Id") int id,@RequestParam(name="quizType") int quizType ,
                                  @RequestParam(name="desc") String desc,
                                  @RequestParam(name="isAnswerOption") int isAnswer,
                                  @RequestParam(name="status") int status) {
        questionService.updateQuestion(id,quizType,isAnswer,status,desc);
        choiceService.setAnswer(id,isAnswer);
        return("redirect:/adminallquestions?pageNum=1");
    }
    @GetMapping(value ="/adminallusers")
    protected String  userall(Model model,@RequestParam(name="pageNum" )int pageNum) {
        List<User> userList = userService.getAllUsers();
        model.addAttribute("userInfo",userList);
        return "admin/adminusers";
    }
    @PostMapping(value = "admin/adminupdateuser")
    protected String toggleuser(@RequestParam(name="userid") int userId) {
        logger.info("-------userid={}",userId);
        userService.toggleUserStatus(userId);
        return "redirect:/adminallusers?pageNum=1";
    }
    @GetMapping(value = "/admincontact")
    protected String contact(Model model){
        List<Contact> contactList = contactService.getAllContacts();

        model.addAttribute("contactInfo",contactList);
        return "admin/admincontact";
    }
    @GetMapping(value = "/adminfeedback")
    protected String feedback(Model model){
        List<Feedback> feedbackList = feedbackService.getAllFeedbacks();
//        feedbackList.get(0).getMessage();
//        feedbackList.get(0).getRating();
//        feedbackList.get(0).getSubmitDate();
        model.addAttribute("feedbackInfo",feedbackList);

        return "admin/adminfeedback";

    }
}
