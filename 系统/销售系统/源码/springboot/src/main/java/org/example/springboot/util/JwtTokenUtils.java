package org.example.springboot.util;


import cn.hutool.core.date.DateUtil;
import com.auth0.jwt.JWT;
import com.auth0.jwt.algorithms.Algorithm;
import com.baomidou.mybatisplus.core.toolkit.StringUtils;

import jakarta.annotation.PostConstruct;
import jakarta.annotation.Resource;
import jakarta.servlet.http.HttpServletRequest;
import org.example.springboot.entity.User;
import org.example.springboot.service.UserService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import java.util.Date;

/**
 * JWT 工具类：生成 token、解析当前登录用户
 */
@Component
public class JwtTokenUtils {
    private static UserService staticUserService;
    private static String jwtSecret;

    @Resource
    private UserService userService;

    @Value("${app.jwt.secret}")
    private String secret;

    public static final Logger LOGGER = LoggerFactory.getLogger(JwtTokenUtils.class);

    @PostConstruct
    public void init() {
        staticUserService = userService;
        jwtSecret = secret;
    }

    /**
     * 使用服务端统一密钥签发 token，有效期 2 小时
     */
    public static String genToken(String userId) {
        return JWT.create()
                .withAudience(userId)
                .withExpiresAt(DateUtil.offsetHour(new Date(), 2))
                .sign(Algorithm.HMAC256(jwtSecret));
    }

    /**
     * 从当前请求中解析登录用户，失败返回 null
     */
    public static User getCurrentUser() {
        String token = null;
        try {
            HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
            token = request.getHeader("token");
            if (StringUtils.isBlank(token)) {
                token = request.getParameter("token");
            }
            if (StringUtils.isBlank(token)) {
                LOGGER.error("获取当前登录的token失败");
                return null;
            }
            String userId = JWT.decode(token).getAudience().get(0);
            return staticUserService.getUserById(Integer.parseInt(userId));
        } catch (Exception e) {
            LOGGER.error("获取当前用户信息失败，token{}", token, e);
            return null;
        }
    }
}
