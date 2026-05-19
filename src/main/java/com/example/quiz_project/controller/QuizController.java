package com.example.quiz_project.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;

@Controller
public class QuizController {
    @GetMapping("/quizindex")
    public String quizindex(HttpServletRequest req,Model model) {
        return "redirect:/quiz/index";
    }

    @GetMapping("/resultdetail")
    public String quizDetails(HttpServletRequest req,Model model,@RequestParam(name="resultId") int quizId) {
        return "redirect:/quiz/result?quizId=" + quizId;
    }

    @GetMapping(value ="/doquiz")
    protected ModelAndView pageQuestions(HttpServletRequest req, @RequestParam("action") String action,
                                         @RequestParam(name="qtid" ,required=false) int cid,
                                         @RequestParam(name="page") int page,
                                        @RequestParam(name="lefttime") int leftTime)
    {
        if ("init".equals(action)) {
            return new ModelAndView("redirect:/quiz/start?categoryId=" + cid + "&timeLimit=" + leftTime);
        }
        return new ModelAndView("redirect:/quiz/index");
    }

}
