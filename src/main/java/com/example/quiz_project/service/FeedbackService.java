package com.example.quiz_project.service;

import com.example.quiz_project.dao.FeedbackDao;
import com.example.quiz_project.domain.Feedback;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class FeedbackService {
    private final FeedbackDao feedbackDao;
    private FeedbackService(FeedbackDao feedbackDao){
        this.feedbackDao=feedbackDao;
    }
    public List<Feedback> getAllFeedbacks(){
        return feedbackDao.getAllFeedbacks();

    }
}
