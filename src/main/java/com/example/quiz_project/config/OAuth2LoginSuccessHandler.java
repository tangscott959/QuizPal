package com.example.quiz_project.config;

import com.example.quiz_project.dao.UserDao;
import com.example.quiz_project.domain.User;
import org.springframework.security.core.Authentication;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.UUID;

@Component
public class OAuth2LoginSuccessHandler implements AuthenticationSuccessHandler {

    private final UserDao userDao;

    public OAuth2LoginSuccessHandler(UserDao userDao) {
        this.userDao = userDao;
    }

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
                                        Authentication authentication) throws IOException, ServletException {

        OAuth2User oAuth2User = (OAuth2User) authentication.getPrincipal();

        String email = oAuth2User.getAttribute("email");
        String firstName = oAuth2User.getAttribute("given_name");
        String lastName = oAuth2User.getAttribute("family_name");
        String name = oAuth2User.getAttribute("name");

        if (firstName == null && name != null) {
            String[] parts = name.split(" ", 2);
            firstName = parts[0];
            lastName = parts.length > 1 ? parts[1] : "";
        }
        if (firstName == null) firstName = "Google";
        if (lastName == null) lastName = "User";

        User user = userDao.findByEmail(email);

        if (user == null) {
            String username = email.split("@")[0];
            if (userDao.findByEmail(email) != null || userExists(username)) {
                username = username + "_" + UUID.randomUUID().toString().substring(0, 4);
            }
            String randomPassword = UUID.randomUUID().toString();
            userDao.AddUser(username, randomPassword, firstName, lastName, email, "", 1, 0);
            user = userDao.findByEmail(email);
        }

        HttpSession oldSession = request.getSession(false);
        if (oldSession != null) {
            oldSession.invalidate();
        }
        HttpSession newSession = request.getSession(true);
        newSession.setAttribute("user", user);

        if (user.getIs_admin() == 1) {
            response.sendRedirect("/admin/adminindex");
        } else {
            response.sendRedirect("/quizindex");
        }
    }

    private boolean userExists(String username) {
        for (User u : userDao.getAllUsers()) {
            if (u.getUsername().equalsIgnoreCase(username)) {
                return true;
            }
        }
        return false;
    }
}
