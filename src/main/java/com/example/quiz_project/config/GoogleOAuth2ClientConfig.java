package com.example.quiz_project.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.security.oauth2.client.OAuth2ClientProperties;
import org.springframework.boot.autoconfigure.security.oauth2.client.OAuth2ClientPropertiesMapper;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.oauth2.client.registration.ClientRegistrationRepository;
import org.springframework.security.oauth2.client.registration.InMemoryClientRegistrationRepository;
import org.springframework.util.StringUtils;

import java.util.ArrayList;

@Configuration
@EnableConfigurationProperties(OAuth2ClientProperties.class)
public class GoogleOAuth2ClientConfig {

    @Bean
    public ClientRegistrationRepository clientRegistrationRepository(
            OAuth2ClientProperties properties,
            @Value("${GOOGLE_REDIRECT_URI:}") String redirectUriOverride) {

        if (StringUtils.hasText(redirectUriOverride)) {
            OAuth2ClientProperties.Registration google = properties.getRegistration().get("google");
            if (google != null) {
                google.setRedirectUri(redirectUriOverride);
            }
        }

        return new InMemoryClientRegistrationRepository(
                new ArrayList<>(new OAuth2ClientPropertiesMapper(properties).asClientRegistrations().values()));
    }
}
