package com.example.quiz_project.controller;

import com.example.quiz_project.dao.UserDao;
import com.example.quiz_project.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpServletRequest;

@Controller
public class RegisterController {
    private final UserDao userDao;
    private final UserService userService;
    @Autowired
    public RegisterController(UserService userService, UserDao userDao){
        this.userDao=userDao;
        this.userService=userService;
    }
    @GetMapping("/register")
    public String regi(){
        return "register";
    }
    @PostMapping("/register")
    public String registration(Model model, HttpServletRequest req, @RequestParam String username,
                               @RequestParam String password, @RequestParam String firstname,
                               @RequestParam String lastname, @RequestParam String email,
                               @RequestParam String phone ){

        // if user not exist, add it
        if(!userService.userExists(username)){
            userDao.AddUser(username,password,firstname,lastname,email,phone,1,0);

            //  System.out.println(userService.userExists(username));
            return "login";

        }

        model.addAttribute("exception", "The user already exist.");
        model.addAttribute("url", req.getRequestURL());
        return "errorPage";


    }

}
