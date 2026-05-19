package com.example.quiz_project.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

@Controller
public class LoginController {
    @GetMapping("/")
    public String index(){
        return "redirect:/quiz/index";
    }

    @GetMapping("/home")
    public String home(Model model){
        return "redirect:/quiz/index";
    }

    @GetMapping("/login")
    public String getLogin(HttpServletRequest request, Model model){
        HttpSession session = request.getSession(false);
        if(session!=null && session.getAttribute("user")!=null ){
            return "redirect:/quiz/index";
        }
        return "login";
    }

    @GetMapping("/admin")
    public String admin(){
        return "redirect:/admin/adminindex";
    }

    @GetMapping("/admin/adminindex")
    public String adminIndex() {
        return "admin/adminindex";
    }
}
