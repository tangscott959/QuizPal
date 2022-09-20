package com.example.quiz_project.controller;

import com.example.quiz_project.dao.ContactDao;
import com.example.quiz_project.service.ContactService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpServletRequest;

@Controller
public class ContactController {
    private final ContactDao contactDao;
    private final ContactService contactService;

    @Autowired
    public ContactController(ContactDao contactDao, ContactService contactService){
        this.contactDao=contactDao;
        this.contactService = contactService;
    }

    @GetMapping("/contact")
    public String con(){
        return "contact";
    }
    @PostMapping("/contact")
    public String contact(@RequestParam String firstname, @RequestParam String lastname, @RequestParam String subject,@RequestParam String message){
        contactService.addContact(firstname,lastname,subject,message);
        return "contact";



    }

}
