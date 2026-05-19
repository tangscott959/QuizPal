package com.example.quiz_project;

import com.example.quiz_project.config.QuizUserDetails;
import com.example.quiz_project.dao.UserDao;
import com.example.quiz_project.domain.User;
import com.example.quiz_project.service.UserService;
import org.junit.jupiter.api.Test;
import org.mockito.ArgumentCaptor;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;

import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

class QuizProjectApplicationTests {

	@Test
	void registerUserStoresBcryptPassword() {
		UserDao userDao = mock(UserDao.class);
		PasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
		UserService userService = new UserService(userDao, passwordEncoder);

		userService.registerUser("student", "password", "Jane", "Student", "jane@example.com", "555-0100");

		ArgumentCaptor<String> passwordCaptor = ArgumentCaptor.forClass(String.class);
		verify(userDao).AddUser(
				org.mockito.ArgumentMatchers.eq("student"),
				passwordCaptor.capture(),
				org.mockito.ArgumentMatchers.eq("Jane"),
				org.mockito.ArgumentMatchers.eq("Student"),
				org.mockito.ArgumentMatchers.eq("jane@example.com"),
				org.mockito.ArgumentMatchers.eq("555-0100"),
				org.mockito.ArgumentMatchers.eq(1),
				org.mockito.ArgumentMatchers.eq(0));

		assertThat(passwordCaptor.getValue()).isNotEqualTo("password");
		assertThat(passwordEncoder.matches("password", passwordCaptor.getValue())).isTrue();
	}

	@Test
	void validateLoginRequiresActiveUserAndMatchingPassword() {
		UserDao userDao = mock(UserDao.class);
		PasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
		UserService userService = new UserService(userDao, passwordEncoder);
		User user = new User(1, "student", passwordEncoder.encode("password"),
				"Jane", "Student", "jane@example.com", "555-0100", 1, 0);

		when(userDao.findByUsername("student")).thenReturn(Optional.of(user));

		assertThat(userService.validateLogin("student", "password")).contains(user);
		assertThat(userService.validateLogin("student", "wrong-password")).isEmpty();
	}

	@Test
	void quizUserDetailsMapsAdminRoleAndActiveFlag() {
		User admin = new User(1, "admin", "hash",
				"System", "Admin", "admin@example.com", "", 1, 1);

		QuizUserDetails details = new QuizUserDetails(admin);

		assertThat(details.isEnabled()).isTrue();
		assertThat(details.getAuthorities())
				.extracting("authority")
				.containsExactly("ROLE_ADMIN");
	}
}
