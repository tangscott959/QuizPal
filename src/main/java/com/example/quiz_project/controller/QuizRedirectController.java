package com.example.quiz_project.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class QuizRedirectController {

    @GetMapping("/quizindex")
    public String quizIndex() {
        return "redirect:/quiz/index";
    }

    @GetMapping("/resultdetail")
    public String quizDetails(@RequestParam(name = "resultId") int quizId) {
        return "redirect:/quiz/result?quizId=" + quizId;
    }

    @GetMapping("/doquiz")
    public String startQuiz(@RequestParam("action") String action,
                            @RequestParam(name = "qtid", required = false) Integer categoryId,
                            @RequestParam(name = "lefttime", required = false) Integer leftTime) {
        if ("init".equals(action) && categoryId != null) {
            int timeLimit = leftTime != null ? leftTime : 15;
            return "redirect:/quiz/start?categoryId=" + categoryId + "&timeLimit=" + timeLimit;
        }
        return "redirect:/quiz/index";
    }
}
