package org.example.springboot.config;

import org.example.springboot.util.RsaUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.util.StringUtils;

import jakarta.annotation.PostConstruct;
import java.util.Map;

/**
 * RSA 密钥持有配置
 *
 * 密钥来源（优先级从高到低）：
 * 1. 环境变量/配置项 APP_RSA_PRIVATE_KEY + APP_RSA_PUBLIC_KEY（生产推荐，
 *    保证多实例部署时所有节点持有相同密钥）
 * 2. 应用启动时随机生成（仅单实例开发环境使用，重启后旧公钥失效）
 *
 * 生成固定密钥对的方式：
 *   openssl genrsa -out rsa_private.pem 2048
 *   openssl rsa -in rsa_private.pem -pubout -out rsa_public.pem
 * （PEM 为 Base64 内容去掉头尾行后即可注入环境变量）
 */
@Configuration
public class RsaKeyConfig {

    private static final Logger LOGGER = LoggerFactory.getLogger(RsaKeyConfig.class);

    @Value("${app.security.rsa-private-key:}")
    private String privateKey;

    @Value("${app.security.rsa-public-key:}")
    private String publicKey;

    public static String PRIVATE_KEY;
    public static String PUBLIC_KEY;

    @PostConstruct
    public void init() throws Exception {
        if (StringUtils.hasText(privateKey) && StringUtils.hasText(publicKey)) {
            PRIVATE_KEY = privateKey.trim();
            PUBLIC_KEY = publicKey.trim();
            LOGGER.info("RSA 密钥已从配置加载");
        } else {
            Map<String, String> pair = RsaUtils.generateKeyPair();
            PRIVATE_KEY = pair.get("privateKey");
            PUBLIC_KEY = pair.get("publicKey");
            LOGGER.warn("未配置 APP_RSA_PRIVATE_KEY/APP_RSA_PUBLIC_KEY，已随机生成 RSA 密钥（重启后失效，仅限开发环境）");
        }
    }
}
