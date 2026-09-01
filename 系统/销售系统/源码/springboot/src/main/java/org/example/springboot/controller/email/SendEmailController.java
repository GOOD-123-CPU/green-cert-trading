package org.example.springboot.controller.email;


import jakarta.annotation.Resource;
import org.example.springboot.common.Result;
import org.example.springboot.entity.User;
import org.example.springboot.service.UserService;
import org.example.springboot.util.CacheUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.web.bind.annotation.*;

import java.security.SecureRandom;

/**
 * 邮件验证码接口
 * 安全说明：验证码只发送到邮箱，不在接口响应中返回（防止接口被滥用直接读取验证码）
 * 跨域：由 WebConfig 中全局 CORS 配置统一处理
 */
@RestController
@RequestMapping("/email")
public class SendEmailController {
    private static final Logger LOGGER = LoggerFactory.getLogger(SendEmailController.class);

    @Resource
    JavaMailSender javaMailSender;

    @Value("${user.fromEmail}")
    private String FROM_EMAIL;

    @Resource
    UserService userService;

    private static final SecureRandom RANDOM = new SecureRandom();

    /**
     * 发送注册验证码（邮箱未被占用时才发送）
     */
    @GetMapping("/sendEmail/{email}")
    public Result<?> emailRegister(@PathVariable String email) {
        if (userService.getByEmail(email) != null) {
            return Result.error("-1", "邮箱已被注册");
        }
        return sendCode(email, "注册", "注册验证码");
    }

    /**
     * 发送找回密码验证码（邮箱需已注册）
     */
    @GetMapping("/findByEmail/{email}")
    public Result<?> findByEmail(@PathVariable String email) {
        if (userService.getByEmail(email) == null) {
            // 不暴露邮箱是否存在，统一提示发送结果
            LOGGER.info("找回密码请求，邮箱未注册: {}", email);
        }
        return sendCode(email, "找回密码", "找回密码验证码");
    }

    private Result<?> sendCode(String email, String scene, String subject) {
        String code = String.valueOf(100000 + RANDOM.nextInt(900000));
        SimpleMailMessage message = new SimpleMailMessage();
        message.setFrom(FROM_EMAIL);
        message.setTo(email);
        message.setSubject(subject);
        message.setText("您的" + scene + "验证码为：" + code + "，有效期5分钟，请勿泄露给他人。");
        try {
            javaMailSender.send(message);
            // 验证码保存在服务端缓存中，5 分钟有效，不返回给前端
            CacheUtil.saveEmailCode(email, code);
            LOGGER.info("{}验证码邮件已发送至 {}", scene, email);
            return Result.success("验证码已发送，请查收邮件");
        } catch (Exception e) {
            LOGGER.error("邮件发送异常：{}", e.getMessage());
            return Result.error("-1", "验证码发送异常，请稍后重试");
        }
    }
}
