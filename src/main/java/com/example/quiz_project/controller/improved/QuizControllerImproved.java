//package com.example.quiz_project.controller.improved;
//
//import com.example.quiz_project.domain.*;
//import org.springframework.ui.Model;
//import org.springframework.web.bind.annotation.*;
//import org.springframework.web.servlet.mvc.support.RedirectAttributes;
//
//import javax.servlet.http.HttpServletRequest;
//import javax.servlet.http.HttpSession;
//import java.time.LocalDateTime;
//import java.util.*;
//
//@GetMapping("/index")
//    public String quizIndex(HttpServletRequest request, Model model) {
//        HttpSession session = request.getSession(false);
//        if (session == null || session.getAttribute("user") == null) {
//            return "redirect:/login";
//        }
//
//        User currentUser = (User) session.getAttribute("user");
//        logger.info("Loading quiz index for user: {}", currentUser.getUsername());
//
//        try {
//            // Get available categories
//            List<Category> categories = categoryService.getActiveCategories();
//            model.addAttribute("categories", categories);
//
//            // Get user's quiz history
//            List<Quiz> userQuizzes = quizService.getQuizzesByUser(currentUser.getUserId());
//            model.addAttribute("userQuizzes", userQuizzes);
//
//            // Calculate statistics
//            Map<String, Object> stats = calculateUserStatistics(currentUser.getUserId());
//            model.addAttribute("stats", stats);
//
//            return "quiz/quiz-index";
//        } catch (Exception e) {
//            logger.error("Error loading quiz index for user: {}", currentUser.getUsername(), e);
//            model.addAttribute("error", "Unable to load quiz data. Please try again.");
//            return "quiz/quiz-index";
//        }
//    }
//
//    @GetMapping("/start")
//    public String startQuiz(@RequestParam("categoryId") Integer categoryId,
//                           @RequestParam(value = "timeLimit", required = false) Integer timeLimit,
//                           HttpServletRequest request,
//                           Model model,
//                           RedirectAttributes redirectAttributes) {
//        HttpSession session = request.getSession(false);
//        if (session == null || session.getAttribute("user") == null) {
//            return "redirect:/login";
//        }
//
//        User currentUser = (User) session.getAttribute("user");
//
//        try {
//            // Validate category
//            Optional<Category> categoryOpt = categoryService.findById(categoryId);
//            if (!categoryOpt.isPresent()) {
//                redirectAttributes.addFlashAttribute("error", "Invalid category selected");
//                return "redirect:/quiz/index";
//            }
//
//            Category category = categoryOpt.get();
//
//            // Get questions for this category
//            List<Question> questions = questionService.getActiveQuestionsByCategory(categoryId);
//            if (questions.isEmpty()) {
//                redirectAttributes.addFlashAttribute("error", "No questions available for this category");
//                return "redirect:/quiz/index";
//            }
//
//            // Create new quiz
//            Quiz quiz = new Quiz();
//            quiz.setUserId(currentUser.getUserId());
//            quiz.setCategoryId(categoryId);
//            quiz.setQuizName(category.getCategoryName() + " Quiz - " + LocalDateTime.now().toLocalDate());
//            quiz.setQuizTimeStart(LocalDateTime.now());
//            quiz.setTimeLimitMinutes(timeLimit);
//            quiz.setTotalQuestions(questions.size());
//            quiz.setMaxScore(questions.stream().mapToInt(Question::getPoints).sum());
//            quiz.setStatus(Quiz.QuizStatus.IN_PROGRESS);
//
//            Integer quizId = quizService.createQuiz(quiz);
//            quiz.setQuizId(quizId);
//
//            // Store quiz in session
//            session.setAttribute("currentQuiz", quiz);
//            session.setAttribute("quizQuestions", questions);
//            session.setAttribute("currentQuestionIndex", 0);
//            session.setAttribute("quizAnswers", new ArrayList<QuizAnswer>());
//
//            logger.info("Started new quiz {} for user {} in category {}",
//                       quizId, currentUser.getUsername(), category.getCategoryName());
//
//            return "redirect:/quiz/question";
//        } catch (Exception e) {
//            logger.error("Error starting quiz for user: {}", currentUser.getUsername(), e);
//            redirectAttributes.addFlashAttribute("error", "Failed to start quiz. Please try again.");
//            return "redirect:/quiz/index";
//        }
//    }
//
//    @GetMapping("/question")
//    public String showQuestion(HttpServletRequest request, Model model, RedirectAttributes redirectAttributes) {
//        HttpSession session = request.getSession(false);
//        if (session == null || session.getAttribute("user") == null) {
//            return "redirect:/login";
//        }
//
//        Quiz currentQuiz = (Quiz) session.getAttribute("currentQuiz");
//        List<Question> questions = (List<Question>) session.getAttribute("quizQuestions");
//        Integer currentQuestionIndex = (Integer) session.getAttribute("currentQuestionIndex");
//
//        if (currentQuiz == null || questions == null || currentQuestionIndex == null) {
//            redirectAttributes.addFlashAttribute("error", "Quiz session expired. Please start again.");
//            return "redirect:/quiz/index";
//        }
//
//        // Check if quiz is completed
//        if (currentQuestionIndex >= questions.size()) {
//            return "redirect:/quiz/complete";
//        }
//
//        // Check time limit
//        if (currentQuiz.hasTimeLimit() && currentQuiz.isTimeExpired()) {
//            currentQuiz.setStatus(Quiz.QuizStatus.ABANDONED);
//            quizService.updateQuiz(currentQuiz);
//            session.removeAttribute("currentQuiz");
//            redirectAttributes.addFlashAttribute("message", "Time expired! Quiz has been submitted.");
//            return "redirect:/quiz/result";
//        }
//
//        Question currentQuestion = questions.get(currentQuestionIndex);
//
//        // Prepare choices for multiple choice questions
//        if (currentQuestion.isMultipleChoice()) {
//            List<Choice> choices = questionService.getChoicesByQuestion(currentQuestion.getQuestionId());
//            currentQuestion.setChoices(choices);
//        }
//
//        model.addAttribute("quiz", currentQuiz);
//        model.addAttribute("question", currentQuestion);
//        model.addAttribute("questionIndex", currentQuestionIndex);
//        model.addAttribute("totalQuestions", questions.size());
//        model.addAttribute("timeRemaining", calculateTimeRemaining(currentQuiz));
//
//        return "quiz/quiz-question";
//    }
//
//    @PostMapping("/answer")
//    public String submitAnswer(@RequestParam(value = "selectedChoiceId", required = false) Integer selectedChoiceId,
//                              @RequestParam(value = "answerText", required = false) String answerText,
//                              @RequestParam("timeTaken") Integer timeTaken,
//                              HttpServletRequest request,
//                              RedirectAttributes redirectAttributes) {
//        HttpSession session = request.getSession(false);
//        if (session == null || session.getAttribute("user") == null) {
//            return "redirect:/login";
//        }
//
//        try {
//            Quiz currentQuiz = (Quiz) session.getAttribute("currentQuiz");
//            List<Question> questions = (List<Question>) session.getAttribute("quizQuestions");
//            Integer currentQuestionIndex = (Integer) session.getAttribute("currentQuestionIndex");
//            List<QuizAnswer> quizAnswers = (List<QuizAnswer>) session.getAttribute("quizAnswers");
//
//            if (currentQuiz == null || questions == null || currentQuestionIndex == null || quizAnswers == null) {
//                redirectAttributes.addFlashAttribute("error", "Quiz session expired");
//                return "redirect:/quiz/index";
//            }
//
//            Question currentQuestion = questions.get(currentQuestionIndex);
//
//            // Create answer
//            QuizAnswer quizAnswer = new QuizAnswer();
//            quizAnswer.setQuizId(currentQuiz.getQuizId());
//            quizAnswer.setQuestionId(currentQuestion.getQuestionId());
//            quizAnswer.setSelectedChoiceId(selectedChoiceId);
//            quizAnswer.setAnswerText(answerText);
//            quizAnswer.setTimeTakenSeconds(timeTaken);
//            quizAnswer.setAnsweredAt(LocalDateTime.now());
//
//            // Check if answer is correct
//            boolean isCorrect = false;
//            if (currentQuestion.isMultipleChoice() && selectedChoiceId != null) {
//                Optional<Choice> selectedChoice = questionService.getChoiceById(selectedChoiceId);
//                if (selectedChoice.isPresent() && selectedChoice.get().isCorrectChoice()) {
//                    isCorrect = true;
//                    quizAnswer.setPointsEarned(currentQuestion.getPoints());
//                }
//            }
//            quizAnswer.setIsCorrect(isCorrect);
//
//            quizAnswers.add(quizAnswer);
//            session.setAttribute("quizAnswers", quizAnswers);
//
//            // Move to next question
//            session.setAttribute("currentQuestionIndex", currentQuestionIndex + 1);
//
//            logger.debug("Recorded answer for question {} in quiz {}",
//                        currentQuestion.getQuestionId(), currentQuiz.getQuizId());
//
//            return "redirect:/quiz/question";
//        } catch (Exception e) {
//            logger.error("Error submitting answer", e);
//            redirectAttributes.addFlashAttribute("error", "Failed to submit answer. Please try again.");
//            return "redirect:/quiz/question";
//        }
//    }
//
//    @GetMapping("/complete")
//    public String completeQuiz(HttpServletRequest request, Model model, RedirectAttributes redirectAttributes) {
//        HttpSession session = request.getSession(false);
//        if (session == null || session.getAttribute("user") == null) {
//            return "redirect:/login";
//        }
//
//        try {
//            Quiz currentQuiz = (Quiz) session.getAttribute("currentQuiz");
//            List<QuizAnswer> quizAnswers = (List<QuizAnswer>) session.getAttribute("quizAnswers");
//
//            if (currentQuiz == null || quizAnswers == null) {
//                redirectAttributes.addFlashAttribute("error", "Quiz session expired");
//                return "redirect:/quiz/index";
//            }
//
//            // Calculate final score
//            int totalScore = quizAnswers.stream()
//                    .mapToInt(answer -> answer.getPointsEarned() != null ? answer.getPointsEarned() : 0)
//                    .sum();
//
//            currentQuiz.setScore(totalScore);
//            currentQuiz.setQuizTimeEnd(LocalDateTime.now());
//            currentQuiz.setStatus(Quiz.QuizStatus.COMPLETED);
//
//            // Update quiz in database
//            quizService.updateQuiz(currentQuiz);
//
//            // Save all answers
//            for (QuizAnswer answer : quizAnswers) {
//                quizAnswerService.saveAnswer(answer);
//            }
//
//            // Clear quiz from session
//            session.removeAttribute("currentQuiz");
//            session.removeAttribute("quizQuestions");
//            session.removeAttribute("currentQuestionIndex");
//            session.removeAttribute("quizAnswers");
//
//            logger.info("Completed quiz {} with score {}/{}",
//                       currentQuiz.getQuizId(), totalScore, currentQuiz.getMaxScore());
//
//            return "redirect:/quiz/result?quizId=" + currentQuiz.getQuizId();
//        } catch (Exception e) {
//            logger.error("Error completing quiz", e);
//            redirectAttributes.addFlashAttribute("error", "Failed to complete quiz. Please try again.");
//            return "redirect:/quiz/index";
//        }
//    }
//
//    @GetMapping("/result")
//    public String showResult(@RequestParam("quizId") Integer quizId,
//                            HttpServletRequest request,
//                            Model model,
//                            RedirectAttributes redirectAttributes) {
//        HttpSession session = request.getSession(false);
//        if (session == null || session.getAttribute("user") == null) {
//            return "redirect:/login";
//        }
//
//        User currentUser = (User) session.getAttribute("user");
//
//        try {
//            Optional<Quiz> quizOpt = quizService.findById(quizId);
//            if (!quizOpt.isPresent()) {
//                redirectAttributes.addFlashAttribute("error", "Quiz not found");
//                return "redirect:/quiz/index";
//            }
//
//            Quiz quiz = quizOpt.get();
//
//            // Verify user owns this quiz
//            if (!quiz.getUserId().equals(currentUser.getUserId())) {
//                redirectAttributes.addFlashAttribute("error", "Access denied");
//                return "redirect:/quiz/index";
//            }
//
//            // Get quiz answers
//            List<QuizAnswer> answers = quizAnswerService.getAnswersByQuiz(quizId);
//
//            // Enrich answers with question and choice details
//            for (QuizAnswer answer : answers) {
//                Optional<Question> questionOpt = questionService.findById(answer.getQuestionId());
//                if (questionOpt.isPresent()) {
//                    Question question = questionOpt.get();
//                    answer.setQuestion(question);
//
//                    if (answer.getSelectedChoiceId() != null) {
//                        Optional<Choice> choiceOpt = questionService.getChoiceById(answer.getSelectedChoiceId());
//                        choiceOpt.ifPresent(answer::setSelectedChoice);
//                    }
//                }
//            }
//
//            model.addAttribute("quiz", quiz);
//            model.addAttribute("answers", answers);
//            model.addAttribute("percentage", quiz.getScorePercentage());
//
//            return "quiz/quiz-result";
//        } catch (Exception e) {
//            logger.error("Error showing quiz result for quizId: {}", quizId, e);
//            redirectAttributes.addFlashAttribute("error", "Unable to load quiz results");
//            return "redirect:/quiz/index";
//        }
//    }
//
//    private Map<String, Object> calculateUserStatistics(Integer userId) {
//        Map<String, Object> stats = new HashMap<>();
//
//        try {
//            List<Quiz> userQuizzes = quizService.getQuizzesByUser(userId);
//
//            int totalQuizzes = userQuizzes.size();
//            int completedQuizzes = (int) userQuizzes.stream()
//                    .filter(Quiz::isCompleted)
//                    .count();
//
//            double averageScore = userQuizzes.stream()
//                    .filter(Quiz::isCompleted)
//                    .mapToDouble(Quiz::getScorePercentage)
//                    .average()
//                    .orElse(0.0);
//
//            int totalPoints = userQuizzes.stream()
//                    .filter(Quiz::isCompleted)
//                    .mapToInt(quiz -> quiz.getScore() != null ? quiz.getScore() : 0)
//                    .sum();
//
//            stats.put("totalQuizzes", totalQuizzes);
//            stats.put("completedQuizzes", completedQuizzes);
//            stats.put("averageScore", Math.round(averageScore * 100.0) / 100.0);
//            stats.put("totalPoints", totalPoints);
//
//        } catch (Exception e) {
//            logger.error("Error calculating user statistics", e);
//            stats.put("totalQuizzes", 0);
//            stats.put("completedQuizzes", 0);
//            stats.put("averageScore", 0.0);
//            stats.put("totalPoints", 0);
//        }
//
//        return stats;
//    }
//
//    private long calculateTimeRemaining(Quiz quiz) {
//        if (!quiz.hasTimeLimit() || quiz.getQuizTimeStart() == null) {
//            return -1; // No time limit
//        }
//
//        LocalDateTime expiryTime = quiz.getQuizTimeStart().plusMinutes(quiz.getTimeLimitMinutes());
//        LocalDateTime now = LocalDateTime.now();
//
//        if (now.isAfter(expiryTime)) {
//            return 0; // Time expired
//        }
//
//        return java.time.Duration.between(now, expiryTime).getSeconds();
//    }
//}
