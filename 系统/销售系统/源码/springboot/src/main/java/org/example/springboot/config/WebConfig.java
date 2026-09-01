package org.example.springboot.config;

import jakarta.annotation.Resource;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.PathMatchConfigurer;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

/**
 * Web 配置
 * 1. 为所有 @RestController 统一添加 /api 路径前缀
 * 2. 注册 JWT 认证拦截器并配置放行规则
 *
 * 注意：此前 addPathPatterns("/api/**") 后紧跟 excludePathPatterns("/api/**")
 * 导致所有接口实际都被放行（拦截器形同虚设），现已修复为按白名单放行。
 */
@Configuration
public class WebConfig implements WebMvcConfigurer {
    @Resource
    private JwtInterceptor jwtInterceptor;

    /**
     * 为带有 @RestController 注解的类添加 "/api" 路径前缀
     */
    @Override
    public void configurePathMatch(PathMatchConfigurer configurer) {
        configurer.addPathPrefix("/api", clazz ->
                clazz.isAnnotationPresent(RestController.class) &&
                        !clazz.getPackage().getName().contains("springfox") &&
                        !clazz.getPackage().getName().contains("doc")
        );
    }

    /**
     * 全局 CORS 配置（取代散落在各 Controller 上的 @CrossOrigin）
     * 开发环境前端 Vite 已配置 /api 代理，一般不会触发跨域；
     * 此配置用于直连后端调试或部署分离场景。
     * 生产环境建议将 allowedOriginPatterns 收紧为具体域名。
     */
    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/api/**")
                .allowedOriginPatterns("*")
                .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS")
                .allowedHeaders("*")
                .exposedHeaders("token")
                .allowCredentials(true)
                .maxAge(3600);
    }

    /**
     * JWT 拦截规则：
     * - 拦截所有 /api/** 请求
     * - 仅放行登录、注册、找回密码、邮件验证码、静态资源等公开接口
     */
    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(jwtInterceptor)
                .addPathPatterns("/api/**")
                .excludePathPatterns(
                        "/api/user/login",      // 登录
                        "/api/user/add",        // 注册
                        "/api/user/forget",     // 找回密码（需邮箱验证码）
                        "/api/user/public-key", // 登录密码 RSA 加密公钥下发
                        "/api/user/username/**",// 注册时校验用户名/邮箱是否存在
                        "/api/email/**",        // 邮件验证码
                        "/api/img/**",          // 图片资源
                        "/api/file/**"          // 文件资源
                );
    }
}
