package com.example.quiz_project.controller;

import com.example.quiz_project.domain.User;
import com.example.quiz_project.service.LoginService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Optional;

@Controller
public class LoginController {
    private final LoginService loginService;
    public LoginController(LoginService loginService){
        this.loginService=loginService;
    }
    @GetMapping("/home")
    public String home(Model model){
        return "/quizindex";
    }
    @GetMapping("/login")
    public String getLogin(HttpServletRequest request, Model model){
        HttpSession session = request.getSession(false);
        if(session!=null && session.getAttribute("user")!=null){
            return "redirect:/quizindex";
        }
        return "login";
    }
    @PostMapping("/login")
    public String postLogin(@RequestParam String username,
                            @RequestParam String password,
                            HttpServletRequest request){
        Optional<User> user =loginService.validateLogin(username,password);
        if(user.isPresent()){
            HttpSession oldSession = request.getSession(false);
            if(oldSession!=null){
                oldSession.invalidate();
            }
            HttpSession newSession = request.getSession(true);
            newSession.setAttribute("user",user.get());
            return "redirect:/quizindex";
        }
        else {

            return "login";
        }
    }
    @GetMapping("/logout")
    public String logout(HttpServletRequest request, Model model) {
        HttpSession oldSession = request.getSession(false);
        // invalidate old session if it exists
        if(oldSession != null) oldSession.invalidate();
        return "login";
    }



}
