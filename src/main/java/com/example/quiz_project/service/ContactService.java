package com.example.quiz_project.service;

import com.example.quiz_project.dao.ContactDao;
import com.example.quiz_project.domain.Contact;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ContactService {
    private final ContactDao contactDao;
    @Autowired
    public ContactService(ContactDao contactDao){
        this.contactDao=contactDao;
    }
    public List<Contact> getAllContacts(){
        return contactDao.getAllContacts();
    }
    public void addContact(String firstname, String lastname, String subject,String message){
        contactDao.AddContact(firstname,lastname, subject,message);
    }
}
