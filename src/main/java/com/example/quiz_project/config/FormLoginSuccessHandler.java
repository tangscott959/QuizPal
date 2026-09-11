package com.example.quiz_project.config;

import com.example.quiz_project.domain.User;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@Component
public class FormLoginSuccessHandler implements AuthenticationSuccessHandler {
    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
                                        Authentication authentication) throws IOException, ServletException {
        QuizUserDetails principal = (QuizUserDetails) authentication.getPrincipal();
        User user = principal.getUser();
        request.getSession(true).setAttribute("user", user);

        if (user.getIs_admin() == 1) {
            response.sendRedirect(request.getContextPath() + "/admin/adminindex");
        } else {
            response.sendRedirect(request.getContextPath() + "/quiz/index");
        }
    }
}
