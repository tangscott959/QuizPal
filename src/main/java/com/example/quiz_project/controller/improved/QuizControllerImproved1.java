package com.example.quiz_project.controller.improved;

import com.example.quiz_project.domain.*;
import com.example.quiz_project.service.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.*;

@Controller
@RequestMapping("/quiz")
public class QuizControllerImproved1 {
    
    private final Logger logger = LoggerFactory.getLogger(QuizControllerImproved1.class);
    
    private final CategoryService categoryService;
    private final QuizService quizService;
    private final QuestionService questionService;
    private final UserService userService;
    private final QuizQuestionService quizQuestionService;

    public QuizControllerImproved1(CategoryService categoryService,
                                QuizService quizService,
                                QuestionService questionService,
                                UserService userService,
                                QuizQuestionService quizQuestionService) {
        this.categoryService = categoryService;
        this.quizService = quizService;
        this.questionService = questionService;
        this.userService = userService;
        this.quizQuestionService = quizQuestionService;
    }

    @GetMapping("/index")
    public String quizIndex(HttpServletRequest request, Model model) {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            return "redirect:/login";
        }

        User currentUser = (User) session.getAttribute("user");
        logger.info("Loading quiz index for user: {}", currentUser.getUsername());

        try {
            // Get available categories
            List<Category> categories = categoryService.getALl();
            model.addAttribute("categories", categories);

            // Get user's quiz history
            List<Quiz> userQuizzes = quizService.getByUser(currentUser.getId());
            model.addAttribute("userQuizzes", userQuizzes);

            List<Map<String, Object>> scores = quizQuestionService.calScore(currentUser.getId());
            Map<Integer, Object> scoreMap = new HashMap<>();
            for (Map<String, Object> score : scores) {
                scoreMap.put((Integer) score.get("quiz_id"), score.get("score"));
            }
            model.addAttribute("scoreMap", scoreMap);

            // Calculate statistics
            Map<String, Object> stats = calculateUserStatistics(currentUser.getId());
            model.addAttribute("stats", stats);

            return "quiz/quiz-index";
        } catch (Exception e) {
            logger.error("Error loading quiz index for user: {}", currentUser.getUsername(), e);
            model.addAttribute("error", "Unable to load quiz data. Please try again.");
            return "quiz/quiz-index";
        }
    }

    @GetMapping("/start")
    public String startQuiz(@RequestParam("categoryId") Integer categoryId,
                           @RequestParam(value = "timeLimit", required = false) Integer timeLimit,
                           HttpServletRequest request,
                           Model model,
                           RedirectAttributes redirectAttributes) {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            return "redirect:/login";
        }

        User currentUser = (User) session.getAttribute("user");

        try {
            // Get questions for this category
            List<Question> questions = questionService.getByCategory(categoryId);
            if (questions.isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "No questions available for this category");
                return "redirect:/quiz/index";
            }

            // Create new quiz
            Quiz quiz = new Quiz();
            quiz.setUserId(currentUser.getId());
            quiz.setCategoryId(categoryId);
            quiz.setQuizName("Quiz - " + LocalDateTime.now().toLocalDate());
            quiz.setQuizTimeStart(new Timestamp(System.currentTimeMillis()));

            Integer quizId = quizService.saveQuiz(quiz);
            quiz.setQuizId(quizId);

            // Store quiz in session
            session.setAttribute("currentQuiz", quiz);
            session.setAttribute("quizQuestions", questions);
            session.setAttribute("currentQuestionIndex", 0);
            session.setAttribute("quizAnswers", new ArrayList<QuizQuestion>());

            logger.info("Started new quiz {} for user {} in category {}", 
                       quizId, currentUser.getUsername(), categoryId);

            return "redirect:/quiz/question";
        } catch (Exception e) {
            logger.error("Error starting quiz for user: {}", currentUser.getUsername(), e);
            redirectAttributes.addFlashAttribute("error", "Failed to start quiz. Please try again.");
            return "redirect:/quiz/index";
        }
    }

    @GetMapping("/question")
    public String showQuestion(HttpServletRequest request, Model model, RedirectAttributes redirectAttributes) {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            return "redirect:/login";
        }

        Quiz currentQuiz = (Quiz) session.getAttribute("currentQuiz");
        List<Question> questions = (List<Question>) session.getAttribute("quizQuestions");
        Integer currentQuestionIndex = (Integer) session.getAttribute("currentQuestionIndex");

        if (currentQuiz == null || questions == null || currentQuestionIndex == null) {
            redirectAttributes.addFlashAttribute("error", "Quiz session expired. Please start again.");
            return "redirect:/quiz/index";
        }

        // Check if quiz is completed
        if (currentQuestionIndex >= questions.size()) {
            return "redirect:/quiz/complete";
        }

        Question currentQuestion = questions.get(currentQuestionIndex);
        
        // Get choices for this question
        List<Choice> choices = questionService.getChoicesByQuestion(currentQuestion.getQuestion_id());

        model.addAttribute("quiz", currentQuiz);
        model.addAttribute("question", currentQuestion);
        model.addAttribute("choices", choices);
        model.addAttribute("questionIndex", currentQuestionIndex);
        model.addAttribute("totalQuestions", questions.size());

        return "quiz/quiz-question";
    }

    @PostMapping("/answer")
    public String submitAnswer(@RequestParam("selectedChoiceId") Integer selectedChoiceId,
                              HttpServletRequest request,
                              RedirectAttributes redirectAttributes) {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            return "redirect:/login";
        }

        try {
            Quiz currentQuiz = (Quiz) session.getAttribute("currentQuiz");
            List<Question> questions = (List<Question>) session.getAttribute("quizQuestions");
            Integer currentQuestionIndex = (Integer) session.getAttribute("currentQuestionIndex");
            List<QuizQuestion> quizAnswers = (List<QuizQuestion>) session.getAttribute("quizAnswers");

            if (currentQuiz == null || questions == null || currentQuestionIndex == null || quizAnswers == null) {
                redirectAttributes.addFlashAttribute("error", "Quiz session expired");
                return "redirect:/quiz/index";
            }

            Question currentQuestion = questions.get(currentQuestionIndex);

            QuizQuestion answer = new QuizQuestion();
            answer.setQuizId(currentQuiz.getQuizId());
            answer.setQuestionId(currentQuestion.getQuestion_id());
            answer.setChoiceId(selectedChoiceId);
            answer.setIs_marked(isCorrectChoice(currentQuestion.getQuestion_id(), selectedChoiceId) ? 1 : 0);
            quizAnswers.add(answer);
            session.setAttribute("quizAnswers", quizAnswers);

            // Move to next question
            session.setAttribute("currentQuestionIndex", currentQuestionIndex + 1);

            logger.debug("Recorded answer for question {} in quiz {}", 
                        currentQuestion.getQuestion_id(), currentQuiz.getQuizId());

            return "redirect:/quiz/question";
        } catch (Exception e) {
            logger.error("Error submitting answer", e);
            redirectAttributes.addFlashAttribute("error", "Failed to submit answer. Please try again.");
            return "redirect:/quiz/question";
        }
    }

    @GetMapping("/complete")
    public String completeQuiz(HttpServletRequest request, Model model, RedirectAttributes redirectAttributes) {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            return "redirect:/login";
        }

        try {
            Quiz currentQuiz = (Quiz) session.getAttribute("currentQuiz");
            List<QuizQuestion> quizAnswers = (List<QuizQuestion>) session.getAttribute("quizAnswers");

            if (currentQuiz == null || quizAnswers == null) {
                redirectAttributes.addFlashAttribute("error", "Quiz session expired");
                return "redirect:/quiz/index";
            }

            // Calculate final score
            int totalScore = calculateScore(quizAnswers);

            currentQuiz.setQuizTimeEnd(new Timestamp(System.currentTimeMillis()));
            quizService.updateQuiz(currentQuiz.getQuizId(), currentQuiz.getQuizTimeEnd());
            quizQuestionService.saveQQ(quizAnswers);

            // Clear quiz from session
            session.removeAttribute("currentQuiz");
            session.removeAttribute("quizQuestions");
            session.removeAttribute("currentQuestionIndex");
            session.removeAttribute("quizAnswers");

            logger.info("Completed quiz {} with score {}", currentQuiz.getQuizId(), totalScore);

            return "redirect:/quiz/result?quizId=" + currentQuiz.getQuizId();
        } catch (Exception e) {
            logger.error("Error completing quiz", e);
            redirectAttributes.addFlashAttribute("error", "Failed to complete quiz. Please try again.");
            return "redirect:/quiz/index";
        }
    }

    @GetMapping("/result")
    public String showResult(@RequestParam("quizId") Integer quizId,
                            HttpServletRequest request,
                            Model model,
                            RedirectAttributes redirectAttributes) {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            return "redirect:/login";
        }

        User currentUser = (User) session.getAttribute("user");

        try {
            Quiz quiz = quizService.getById(quizId);
            if (quiz == null) {
                redirectAttributes.addFlashAttribute("error", "Quiz not found");
                return "redirect:/quiz/index";
            }

            // Verify user owns this quiz
            if (currentUser == null || !Objects.equals(quiz.getUserId(), currentUser.getId())) {
                redirectAttributes.addFlashAttribute("error", "Access denied or session expired");
                return "redirect:/quiz/index";
            }

            // Get quiz answers and calculate score
            int score = quizQuestionService.calScoreOne(quizId);
            List<QuizQuestion> quizAnswers = quizQuestionService.getByQuizId(quizId);
            List<QuestionChoice> questionChoices = new ArrayList<>();
            for (QuizQuestion quizAnswer : quizAnswers) {
                Question question = questionService.getById(quizAnswer.getQuestionId());
                QuestionChoice questionChoice = new QuestionChoice();
                questionChoice.setQuestionId(question.getQuestion_id());
                questionChoice.setDescription(question.getQuiz_description());
                questionChoice.setUserChoice(quizAnswer.getChoiceId());
                questionChoice.setChoiceList(questionService.getChoicesByQuestion(question.getQuestion_id()));
                questionChoices.add(questionChoice);
            }
            
            model.addAttribute("quiz", quiz);
            model.addAttribute("score", score);
            model.addAttribute("user", currentUser);
            model.addAttribute("qclist", questionChoices);

            return "quiz/quiz-result";
        } catch (Exception e) {
            logger.error("Error showing quiz result for quizId: {}", quizId, e);
            redirectAttributes.addFlashAttribute("error", "Unable to load quiz results");
            return "redirect:/quiz/index";
        }
    }

    private Map<String, Object> calculateUserStatistics(Integer userId) {
        Map<String, Object> stats = new HashMap<>();
        
        try {
            List<Quiz> userQuizzes = quizService.getByUser(userId);
            
            int totalQuizzes = userQuizzes.size();
            
            stats.put("totalQuizzes", totalQuizzes);
            stats.put("completedQuizzes", totalQuizzes);
            stats.put("averageScore", 0.0);
            stats.put("totalPoints", 0);
            
        } catch (Exception e) {
            logger.error("Error calculating user statistics", e);
            stats.put("totalQuizzes", 0);
            stats.put("completedQuizzes", 0);
            stats.put("averageScore", 0.0);
            stats.put("totalPoints", 0);
        }
        
        return stats;
    }

    private int calculateScore(List<QuizQuestion> answers) {
        int score = 0;
        for (QuizQuestion answer : answers) {
            if (isCorrectChoice(answer.getQuestionId(), answer.getChoiceId())) {
                score++;
            }
        }
        return score;
    }

    private boolean isCorrectChoice(Integer questionId, Integer selectedChoiceId) {
        if (questionId == null || selectedChoiceId == null) {
            return false;
        }
        try {
            List<Choice> choices = questionService.getChoicesByQuestion(questionId);
            for (Choice choice : choices) {
                if (choice.getChoice_id() == selectedChoiceId && choice.getIs_correct() == 1) {
                    return true;
                }
            }
        } catch (Exception e) {
            logger.error("Error checking answer correctness", e);
        }
        return false;
    }
}
