package com.example.quiz_project.controller;

import com.example.quiz_project.dao.ContactDao;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpServletRequest;

@Controller
public class ContactController {
    private final ContactDao contactDao;

    @Autowired
    public ContactController(ContactDao contactDao){
        this.contactDao=contactDao;
    }

    @GetMapping("/con")
    public String con(){
        return "contact";
    }
    @PostMapping("/contact")
    public String contact(Model model, HttpServletRequest req, @RequestParam String firstname,
                          @RequestParam String lastname, @RequestParam String subject, @RequestParam String message){
        contactDao.AddContact(firstname,lastname,subject,message);
        return "contact";

    }

}
