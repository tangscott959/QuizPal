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
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import java.sql.Timestamp;
import java.util.*;
import java.util.stream.Collectors;

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
                               ChoiceService choiceService, UserService userService, ContactService contactService, FeedbackService feedbackService){
        this.categoryService = categoryService;
        this.quizService = quizService;
        this.quizQuestionService = quizQuestionService;
        this.questionService = questionService;
        this.choiceService = choiceService;
        this.userService = userService;
        this.contactService = contactService;
        this.feedbackService = feedbackService;
    }
    @GetMapping("/admin/home")
    public String adminHome(HttpSession session) {
        return "admin/adminindex";
    }


    @GetMapping(value = "adminquiz")
    public String adminQuizIndex(HttpSession session, Model model,
                                 @RequestParam(name = "sortByName", required = false) String sortFlag1,
                                 @RequestParam(name = "sortByCategory", required = false) String sortFlag2) {

        // Process quiz list for admin view
        List<QuizResultTable> qrtList = new ArrayList<>();
        List<Quiz> quizList;
        List<Category> categories = categoryService.getALl();
        List<User> usersList = userService.getAllUsers();

        if (null == sortFlag2 || sortFlag2.equals("0")) {
            if (null != sortFlag1) {
                quizList = quizService.getByUserName(sortFlag1);
            } else {
                quizList = quizService.getALl();
            }
        } else {
            quizList = quizService.getByCategory(Integer.parseInt(sortFlag2));
        }

        List<Map<String,Object>> scores = quizQuestionService.calScoreAll();

        for (Quiz quiz : quizList) {
            QuizResultTable qrt = new QuizResultTable();
            qrt.setQuizId(quiz.getQuizId());
            qrt.setQuizName(quiz.getQuizName());
            qrt.setStartTime(quiz.getQuizTimeStart());
            qrt.setEndTime(quiz.getQuizTimeEnd());
            User quizUser = usersList.stream().filter(u -> u.getId() == quiz.getUserId()).findFirst().orElse(null);
            if (quizUser != null) {
                qrt.setUserName(quizUser.getFullName());
            } else {
                qrt.setUserName("Unknown");
            }

            qrt.setCategory(categories.stream().filter(c -> c.getCategoryId() == quiz.getCategoryId()).findFirst().map(Category::getCategoryName).orElse("Unknown"));

            Map<String, Object> score = scores.stream().filter(s -> (Integer) s.get("quiz_id") == quiz.getQuizId()).findFirst().orElse(null);
            qrt.setScore(score != null ? score.get("score").toString() : "0");

            qrtList.add(qrt);
        }

        model.addAttribute("category", categories);
        model.addAttribute("qrtList", qrtList);
        return "admin/adminresult";  // Admin page
    }

    @GetMapping("/adminresultdetail")
    public String quizDetails(HttpServletRequest req, Model model, @RequestParam(name = "resultId") int quizId) {
        Quiz quiz = quizService.getById(quizId);
        User u = userService.getUserById(quiz.getUserId());
        int score = quizQuestionService.calScoreOne(quizId);

        model.addAttribute("user", u);
        model.addAttribute("score", score);
        model.addAttribute("quizdetail", quiz);
        List<QuizQuestion> qqList = quizQuestionService.getByQuizId(quizId);
        List<QuestionChoice> qcList = new ArrayList<>();
        qqList.forEach(qq -> {
            QuestionChoice qc = new QuestionChoice();
            qc.setQuestionId(qq.getQuestionId());
            qc.setUserChoice(qq.getChoiceId());
            qc.setDescription(questionService.getById(qq.getQuestionId()).getQuiz_description());
            qc.setChoiceList(choiceService.getByQid(qq.getQuestionId()));
            qcList.add(qc);
        });

        model.addAttribute("qclist", qcList);
        return "admin/adminquiz";  // Admin quiz detail page
    }

    @GetMapping(value = "adminallusers")
    protected String listAllUsers(Model model, @RequestParam(name = "pageNum") int pageNum) {
        List<User> userList = userService.getAllUsers();
        model.addAttribute("userInfo", userList);
        return "admin/adminusers";  // Admin user list page
    }

    @PostMapping(value = "admin/adminupdateuser")
    protected String toggleUserStatus(@RequestParam(name = "userid") int userId) {
        logger.info("Toggling status for user with ID: {}", userId);
        userService.toggleUserStatus(userId);
        return "redirect:/adminallusers?pageNum=1";  // Redirect back to user list page
    }

    @PostMapping(value = "admin/toggleuser")
    protected String updateUser(@RequestParam(name = "userid") int userId, @RequestParam(name = "action") String action) {
        logger.info("Action: {} for user with ID: {}", action, userId);
        if ("toggle_status".equals(action)) {
            userService.toggleUserStatus(userId);
        } else if ("toggle_admin".equals(action)) {
            userService.toggleAdminStatus(userId);  // Assuming you have a toggleAdminStatus method in the service
        }
        return "redirect:/adminallusers?pageNum=1";  // Redirect to user list after update
    }

    // Debugging for regular user viewing their own results
    @GetMapping("/userquizresults")
    public String userResults(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        List<Quiz> quizList;

        if (user.getIs_admin() == 1) {
            // Admin sees all users' quiz results
            quizList = quizService.getALl();
        } else {
            // Regular user sees only their own quiz results
            quizList = quizService.getByUserId(user.getId());
        }

        List<QuizResultTable> qrtList = new ArrayList<>();
        List<Category> categories = categoryService.getALl();
        List<User> usersList = userService.getAllUsers();
        List<Map<String,Object>> scores = quizQuestionService.calScoreAll();

        for (Quiz quiz : quizList) {
            QuizResultTable qrt = new QuizResultTable();
            qrt.setQuizId(quiz.getQuizId());
            qrt.setQuizName(quiz.getQuizName());
            qrt.setStartTime(quiz.getQuizTimeStart());
            qrt.setEndTime(quiz.getQuizTimeEnd());

            // Get the user that took the quiz
            User quizUser = usersList.stream().filter(u -> u.getId() == quiz.getUserId()).findFirst().orElse(null);
            if (quizUser != null) {
                qrt.setUserName(quizUser.getFullName());
            } else {
                qrt.setUserName("Unknown");
            }

            // Set the category name for the quiz
            qrt.setCategory(
                    categories.stream()
                            .filter(c -> c.getCategoryId() == quiz.getCategoryId())
                            .findFirst()
                            .map(Category::getCategoryName)
                            .orElse("Unknown")
            );

            // Set the score
            Map<String, Object> score = scores.stream()
                    .filter(s -> (Integer) s.get("quiz_id") == quiz.getQuizId())
                    .findFirst()
                    .orElse(null);
            qrt.setScore(score != null ? score.get("score").toString() : "0");

            qrtList.add(qrt);
        }

        model.addAttribute("qrtList", qrtList);
        return user.getIs_admin() == 1 ? "admin/adminresult" : "user/quizresults";
    }
    @GetMapping("/admin/feedback")
    public String viewAllFeedback(Model model, HttpSession session) {
        List<Feedback> feedbackList = feedbackService.getAllFeedback();
        model.addAttribute("feedbackList", feedbackList);

        return "admin/adminfeedback";
    }

    @GetMapping("/admin/contact")
    public String viewAllContact(Model model, HttpSession session) {
        List<Contact> contactList = contactService.getAllContacts();
        model.addAttribute("contactlist", contactList);

        return "admin/admincontact";
    }


    @GetMapping("/admin/managequestions")
    public String manageQuestions(Model model) {
        // Get all questions
        List<Question> questionList = questionService.getAll();

        // Wrap each question with its choices
        List<QuestionChoice> questionChoiceList = questionList.stream()
                .map(q -> {
                    List<Choice> choices = choiceService.getByQid(q.getQuestion_id());
                    return new QuestionChoice(q.getQuestion_id(), q.getQuiz_description(), 0, choices); // Use getQuiz_description()
                })
                .collect(Collectors.toList());

        model.addAttribute("questionChoiceList", questionChoiceList);
        return "admin/manage_questions";
    }
    @PostMapping("/admin/updateQuestion")
    public String updateQuestion(@RequestParam("questionId") int questionId,
                                 @RequestParam("description") String description,
                                 @RequestParam("choices") String[] choices,
                                 @RequestParam("choiceIds") int[] choiceIds,
                                 RedirectAttributes redirectAttributes) {

        try {
            // Update question description
            Question question = questionService.getById(questionId);
            if (question != null) {
                questionService.updateQuestion(questionId,
                        question.getCategory_id(),
                        0,
                        question.getIs_active(),
                        description);
            }

            // Update choices using their specific IDs
            for (int i = 0; i < choices.length && i < choiceIds.length; i++) {
                choiceService.updateChoiceDescription(choiceIds[i], choices[i]);
            }

            redirectAttributes.addFlashAttribute("successMessage", "Question and choices updated successfully!");

        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Error: " + e.getMessage());
            e.printStackTrace();
        }

        return "redirect:/admin/managequestions";
    }



}
