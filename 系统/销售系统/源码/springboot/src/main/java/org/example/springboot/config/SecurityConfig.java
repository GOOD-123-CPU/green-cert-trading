package org.example.springboot.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

/**
 * Spring Security 配置
 *
 * 职责划分说明：
 * - 认证由自定义 JwtInterceptor 完成（见 WebConfig）
 * - Spring Security 仅提供 BCrypt 密码编码器，并放行所有请求，
 *   最终 API 的访问控制由 JwtInterceptor 的白名单机制决定
 *
 * 此前版本使用 anyRequest().permitAll() 且存在重复/乱码注释，已清理。
 */
@Configuration
@EnableWebSecurity
public class SecurityConfig {

    /**
     * BCrypt 密码编码器（强度 10，自动加盐）
     */
    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder(10);
    }

    /**
     * 安全过滤器链：全部放行，认证交给 JwtInterceptor
     * （前后端分离 + 自定义 token 认证的常见做法）
     */
    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
                .authorizeHttpRequests(auth -> auth.anyRequest().permitAll())
                .csrf(csrf -> csrf.disable());
        return http.build();
    }
}
