package com.example.quiz_project.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    private final OAuth2LoginSuccessHandler oAuth2LoginSuccessHandler;
    private final FormLoginSuccessHandler formLoginSuccessHandler;
    private final QuizUserDetailsService userDetailsService;

    public SecurityConfig(OAuth2LoginSuccessHandler oAuth2LoginSuccessHandler,
                          FormLoginSuccessHandler formLoginSuccessHandler,
                          QuizUserDetailsService userDetailsService) {
        this.oAuth2LoginSuccessHandler = oAuth2LoginSuccessHandler;
        this.formLoginSuccessHandler = formLoginSuccessHandler;
        this.userDetailsService = userDetailsService;
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .userDetailsService(userDetailsService)
            .authorizeRequests()
                .antMatchers("/", "/login", "/register", "/error", "/accessdenied.jsp").permitAll()
                .antMatchers("/oauth2/**", "/login/oauth2/**").permitAll()
                .antMatchers("/css/**", "/js/**", "/images/**", "/webjars/**").permitAll()
                .antMatchers("/admin/**", "/adminquiz", "/adminquiz/**",
                        "/adminallusers", "/adminallusers/**",
                        "/adminresultdetail", "/adminresultdetail/**").hasRole("ADMIN")
                .anyRequest().authenticated()
            .and()
            .formLogin()
                .loginPage("/login")
                .loginProcessingUrl("/login")
                .successHandler(formLoginSuccessHandler)
                .failureUrl("/login?error")
                .permitAll()
            .and()
            .oauth2Login()
                .loginPage("/login")
                .successHandler(oAuth2LoginSuccessHandler)
            .and()
            .logout()
                .logoutUrl("/logout")
                .logoutSuccessUrl("/login?logout")
                .invalidateHttpSession(true)
                .deleteCookies("JSESSIONID")
                .permitAll()
            .and()
            .exceptionHandling()
                .accessDeniedPage("/accessdenied.jsp");

        return http.build();
    }
}
