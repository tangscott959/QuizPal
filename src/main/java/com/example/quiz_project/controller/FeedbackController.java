package com.example.quiz_project.controller;

import com.example.quiz_project.dao.FeedbackDao;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpServletRequest;
import java.sql.Timestamp;


@Controller
public class FeedbackController {
    private final FeedbackDao feedbackDao;

    @Autowired
    public FeedbackController(FeedbackDao feedbackDao){
        this.feedbackDao=feedbackDao;
    }

    @GetMapping("/feedback")
    public String fed(){
        return "feedback";
    }

    @PostMapping("/feedback")
    public String feedback(HttpServletRequest req, @RequestParam String message, @RequestParam int rating,  Timestamp submit_time){
        Timestamp timestampFromSystemTime = new Timestamp(System.currentTimeMillis());
        feedbackDao.addFeedback(message,rating,timestampFromSystemTime);
        System.out.println("feedback added");
        return "feedback";
    }

}
