package com.example.quiz_project.dao;

import com.example.quiz_project.domain.Contact;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Repository;

import java.util.List;

@Component
@Repository
public class ContactDao {
    JdbcTemplate jdbcTemplate;
    ContactRowMapper rowMapper;

    @Autowired
    public ContactDao(JdbcTemplate jdbcTemplate, ContactRowMapper rowMapper){
        this.jdbcTemplate=jdbcTemplate;
        this.rowMapper=rowMapper;
    }
    public List<Contact> getAllContacts(){
        String query = "SELECT * FROM contact";
        List<Contact> contacts = jdbcTemplate.query(query,rowMapper);
        return contacts;
    }
    public void AddContact(String firstName, String lastName, String subject, String message){
        String query = "INSERT INTO contact (firstname, lastname, subject, message) VALUES(?,?,?,?)";
        jdbcTemplate.update(query,firstName,lastName,subject,message);
        System.out.println("Contact added");
    }
}
