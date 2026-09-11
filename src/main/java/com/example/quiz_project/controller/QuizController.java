package com.example.quiz_project.controller;

import com.example.quiz_project.domain.*;
import com.example.quiz_project.service.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/quiz")
public class QuizController {

    private static final int QUIZ_TIME_LIMIT_MINUTES = 15;

    private final Logger logger = LoggerFactory.getLogger(QuizController.class);

    private final CategoryService categoryService;
    private final QuizService quizService;
    private final QuestionService questionService;
    private final QuizQuestionService quizQuestionService;

    public QuizController(CategoryService categoryService,
                          QuizService quizService,
                          QuestionService questionService,
                          QuizQuestionService quizQuestionService) {
        this.categoryService = categoryService;
        this.quizService = quizService;
        this.questionService = questionService;
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
            List<Category> categories = categoryService.getALl();
            model.addAttribute("categories", categories);

            Quiz inProgressQuiz = quizService.getInProgressByUser(currentUser.getId());
            if (inProgressQuiz != null && isQuizExpired(inProgressQuiz)) {
                finalizeExpiredQuiz(inProgressQuiz);
                model.addAttribute("info", "Your previous quiz timed out and was submitted automatically.");
                inProgressQuiz = null;
            }
            model.addAttribute("inProgressQuiz", inProgressQuiz);
            if (inProgressQuiz != null) {
                model.addAttribute("inProgressAnsweredCount",
                        quizQuestionService.countAnswered(inProgressQuiz.getQuizId()));
            }

            List<Quiz> userQuizzes = quizService.getCompletedByUser(currentUser.getId());
            model.addAttribute("userQuizzes", userQuizzes);

            List<Map<String, Object>> scores = quizQuestionService.calScore(currentUser.getId());
            Map<Integer, Object> scoreMap = new HashMap<>();
            for (Map<String, Object> score : scores) {
                scoreMap.put((Integer) score.get("quiz_id"), score.get("score"));
            }
            model.addAttribute("scoreMap", scoreMap);

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
                          RedirectAttributes redirectAttributes) {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            return "redirect:/login";
        }

        User currentUser = (User) session.getAttribute("user");

        try {
            List<Question> questions = questionService.getByCategory(categoryId);
            if (questions.size() < QuestionService.QUIZ_QUESTION_COUNT) {
                redirectAttributes.addFlashAttribute("error",
                        "This category needs at least " + QuestionService.QUIZ_QUESTION_COUNT
                                + " active questions to start a quiz.");
                return "redirect:/quiz/index";
            }

            quizService.abandonInProgressQuiz(currentUser.getId());

            Quiz quiz = new Quiz();
            quiz.setUserId(currentUser.getId());
            quiz.setCategoryId(categoryId);
            quiz.setQuizName("Quiz - " + LocalDateTime.now().toLocalDate());
            quiz.setQuizTimeStart(new Timestamp(System.currentTimeMillis()));
            quiz.setQuizTimeEnd(null);
            quiz.setTimeLimitMinutes(resolveTimeLimitMinutes(timeLimit));
            quiz.setTotalQuestions(questions.size());
            quiz.setStatus("IN_PROGRESS");

            Integer quizId = quizService.saveQuiz(quiz);
            List<Integer> questionIds = questions.stream()
                    .map(Question::getQuestion_id)
                    .collect(Collectors.toList());
            quizQuestionService.savePlaceholderAnswers(quizId, questionIds);

            logger.info("Started new quiz {} for user {} in category {}",
                    quizId, currentUser.getUsername(), categoryId);

            return "redirect:/quiz/question?quizId=" + quizId;
        } catch (Exception e) {
            logger.error("Error starting quiz for user: {}", currentUser.getUsername(), e);
            redirectAttributes.addFlashAttribute("error", "Failed to start quiz. Please try again.");
            return "redirect:/quiz/index";
        }
    }

    @GetMapping("/question")
    public String showQuestion(@RequestParam(value = "quizId", required = false) Integer quizId,
                               HttpServletRequest request,
                               Model model,
                               RedirectAttributes redirectAttributes) {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            return "redirect:/login";
        }

        User currentUser = (User) session.getAttribute("user");

        if (quizId == null) {
            Quiz inProgressQuiz = quizService.getInProgressByUser(currentUser.getId());
            if (inProgressQuiz != null) {
                return "redirect:/quiz/question?quizId=" + inProgressQuiz.getQuizId();
            }
            redirectAttributes.addFlashAttribute("error", "No quiz in progress. Please start a new quiz.");
            return "redirect:/quiz/index";
        }

        try {
            Quiz quiz = quizService.getById(quizId);
            if (quiz == null || !Objects.equals(quiz.getUserId(), currentUser.getId())) {
                redirectAttributes.addFlashAttribute("error", "Quiz not found or access denied.");
                return "redirect:/quiz/index";
            }

            if ("COMPLETED".equals(quiz.getStatus())) {
                return "redirect:/quiz/result?quizId=" + quizId;
            }
            if (!"IN_PROGRESS".equals(quiz.getStatus())) {
                redirectAttributes.addFlashAttribute("error", "This quiz is no longer active.");
                return "redirect:/quiz/index";
            }

            if (isQuizExpired(quiz)) {
                return finalizeExpiredQuiz(quiz, redirectAttributes);
            }

            List<QuizQuestion> quizAnswers = quizQuestionService.getByQuizId(quizId);
            List<Question> questions = loadQuestionsInOrder(quizAnswers);
            int currentQuestionIndex = getCurrentQuestionIndex(quizAnswers);

            if (currentQuestionIndex >= questions.size()) {
                return "redirect:/quiz/complete?quizId=" + quizId;
            }

            Question currentQuestion = questions.get(currentQuestionIndex);
            List<Choice> choices = questionService.getChoicesByQuestion(currentQuestion.getQuestion_id());

            model.addAttribute("quiz", quiz);
            model.addAttribute("question", currentQuestion);
            model.addAttribute("choices", choices);
            model.addAttribute("questionIndex", currentQuestionIndex);
            model.addAttribute("totalQuestions", questions.size());
            model.addAttribute("timerDeadlineEpochMs", getTimerDeadlineEpochMs(quiz));
            model.addAttribute("timeLimitMinutes", resolveTimeLimitMinutes(quiz));

            return "quiz/quiz-question";
        } catch (Exception e) {
            logger.error("Error loading quiz question for quizId: {}", quizId, e);
            redirectAttributes.addFlashAttribute("error", "Unable to load quiz question. Please try again.");
            return "redirect:/quiz/index";
        }
    }

    @PostMapping("/answer")
    public String submitAnswer(@RequestParam("quizId") Integer quizId,
                               @RequestParam("questionId") Integer questionId,
                               @RequestParam("selectedChoiceId") Integer selectedChoiceId,
                               HttpServletRequest request,
                               RedirectAttributes redirectAttributes) {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            return "redirect:/login";
        }

        User currentUser = (User) session.getAttribute("user");

        try {
            Quiz quiz = quizService.getById(quizId);
            if (quiz == null || !Objects.equals(quiz.getUserId(), currentUser.getId())) {
                redirectAttributes.addFlashAttribute("error", "Quiz not found or access denied.");
                return "redirect:/quiz/index";
            }
            if (!"IN_PROGRESS".equals(quiz.getStatus())) {
                redirectAttributes.addFlashAttribute("error", "This quiz is no longer active.");
                return "redirect:/quiz/index";
            }

            if (isQuizExpired(quiz)) {
                return finalizeExpiredQuiz(quiz, redirectAttributes);
            }

            boolean isCorrect = isCorrectChoice(questionId, selectedChoiceId);
            boolean saved = quizQuestionService.saveAnswer(quizId, questionId, selectedChoiceId, isCorrect);
            if (!saved) {
                redirectAttributes.addFlashAttribute("error", "Unable to save answer. Please try again.");
                return "redirect:/quiz/question?quizId=" + quizId;
            }

            logger.debug("Recorded answer for question {} in quiz {}", questionId, quizId);

            List<QuizQuestion> quizAnswers = quizQuestionService.getByQuizId(quizId);
            if (getCurrentQuestionIndex(quizAnswers) >= quiz.getTotalQuestions()) {
                return "redirect:/quiz/complete?quizId=" + quizId;
            }

            return "redirect:/quiz/question?quizId=" + quizId;
        } catch (Exception e) {
            logger.error("Error submitting answer for quizId: {}", quizId, e);
            redirectAttributes.addFlashAttribute("error", "Failed to submit answer. Please try again.");
            return "redirect:/quiz/question?quizId=" + quizId;
        }
    }

    @GetMapping("/complete")
    public String completeQuiz(@RequestParam("quizId") Integer quizId,
                               HttpServletRequest request,
                               RedirectAttributes redirectAttributes) {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            return "redirect:/login";
        }

        User currentUser = (User) session.getAttribute("user");

        try {
            Quiz quiz = quizService.getById(quizId);
            if (quiz == null || !Objects.equals(quiz.getUserId(), currentUser.getId())) {
                redirectAttributes.addFlashAttribute("error", "Quiz not found or access denied.");
                return "redirect:/quiz/index";
            }

            if ("COMPLETED".equals(quiz.getStatus())) {
                return "redirect:/quiz/result?quizId=" + quizId;
            }

            if (isQuizExpired(quiz)) {
                return finalizeExpiredQuiz(quiz, redirectAttributes);
            }

            if (quizQuestionService.countAnswered(quizId) < quiz.getTotalQuestions()) {
                return "redirect:/quiz/question?quizId=" + quizId;
            }

            int totalScore = quizQuestionService.calScoreOne(quizId);
            quizService.completeQuiz(quizId, new Timestamp(System.currentTimeMillis()), totalScore);

            logger.info("Completed quiz {} with score {}", quizId, totalScore);

            return "redirect:/quiz/result?quizId=" + quizId;
        } catch (Exception e) {
            logger.error("Error completing quiz {}", quizId, e);
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

            if (currentUser == null || !Objects.equals(quiz.getUserId(), currentUser.getId())) {
                redirectAttributes.addFlashAttribute("error", "Access denied or session expired");
                return "redirect:/quiz/index";
            }

            if ("IN_PROGRESS".equals(quiz.getStatus())) {
                if (isQuizExpired(quiz)) {
                    return finalizeExpiredQuiz(quiz, redirectAttributes);
                }
                return "redirect:/quiz/question?quizId=" + quizId;
            }

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

    private List<Question> loadQuestionsInOrder(List<QuizQuestion> quizAnswers) {
        List<Integer> questionIds = quizAnswers.stream()
                .map(QuizQuestion::getQuestionId)
                .collect(Collectors.toList());
        return questionService.getQuestionsInOrder(questionIds);
    }

    private int getCurrentQuestionIndex(List<QuizQuestion> quizAnswers) {
        for (int i = 0; i < quizAnswers.size(); i++) {
            if (quizAnswers.get(i).getChoiceId() == 0) {
                return i;
            }
        }
        return quizAnswers.size();
    }

    private int resolveTimeLimitMinutes(Integer requestedLimit) {
        if (requestedLimit != null && requestedLimit > 0) {
            return requestedLimit;
        }
        return QUIZ_TIME_LIMIT_MINUTES;
    }

    private int resolveTimeLimitMinutes(Quiz quiz) {
        return quiz.getTimeLimitMinutes() > 0 ? quiz.getTimeLimitMinutes() : QUIZ_TIME_LIMIT_MINUTES;
    }

    private long getTimerDeadlineEpochMs(Quiz quiz) {
        return quiz.getQuizTimeStart().getTime() + resolveTimeLimitMinutes(quiz) * 60_000L;
    }

    private boolean isQuizExpired(Quiz quiz) {
        if (quiz.getQuizTimeStart() == null) {
            return false;
        }
        return System.currentTimeMillis() >= getTimerDeadlineEpochMs(quiz);
    }

    private void finalizeExpiredQuiz(Quiz quiz) {
        if ("COMPLETED".equals(quiz.getStatus())) {
            return;
        }
        int score = quizQuestionService.calScoreOne(quiz.getQuizId());
        quizService.completeQuiz(quiz.getQuizId(), new Timestamp(System.currentTimeMillis()), score);
        logger.info("Quiz {} auto-submitted after time limit with score {}", quiz.getQuizId(), score);
    }

    private String finalizeExpiredQuiz(Quiz quiz, RedirectAttributes redirectAttributes) {
        finalizeExpiredQuiz(quiz);
        redirectAttributes.addFlashAttribute("error",
                "Time is up! Your quiz was submitted with the answers you completed.");
        return "redirect:/quiz/result?quizId=" + quiz.getQuizId();
    }

    private Map<String, Object> calculateUserStatistics(Integer userId) {
        Map<String, Object> stats = new HashMap<>();

        try {
            List<Quiz> userQuizzes = quizService.getCompletedByUser(userId);
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
