package org.example.springboot.util;

import javax.crypto.Cipher;
import java.security.KeyFactory;
import java.security.KeyPair;
import java.security.KeyPairGenerator;
import java.security.PrivateKey;
import java.security.PublicKey;
import java.security.spec.PKCS8EncodedKeySpec;
import java.security.spec.X509EncodedKeySpec;
import java.util.Base64;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * RSA 加解密工具：用于登录密码的传输加密
 *
 * 背景：HTTPS 之外，登录密码明文传输易被抓包。前端使用 JSEncrypt 以
 * 服务端下发的 RSA 公钥加密密码后传输，服务端私钥解密，即使流量被截获
 * 也无法直接还原密码。
 *
 * 流程：
 * 1. 前端调用 GET /api/user/public-key 获取 RSA 公钥（Base64）
 * 2. 前端用公钥加密明文密码 -> POST /api/user/login
 * 3. 服务端用私钥解密后再走 BCrypt 校验
 *
 * 密钥来源：优先读配置 app.security.rsa-private-key / rsa-public-key
 * （生产环境通过环境变量注入固定密钥，多实例部署才可共享会话）；
 * 未配置时应用启动自动生成（仅适合单实例开发环境）。
 */
public final class RsaUtils {

    /** RSA 密钥算法 */
    private static final String ALGORITHM = "RSA";
    /** 密钥长度 */
    private static final int KEY_SIZE = 2048;
    /** 加密填充方式（与前端 JSEncrypt 默认一致） */
    private static final String CIPHER_TRANSFORMATION = "RSA/ECB/PKCS1Padding";

    /** 解密结果缓存：cipherText(Base64) -> 明文，避免重复解密（一次性使用后移除） */
    private static final Map<String, String> DECRYPT_CACHE = new ConcurrentHashMap<>();

    private RsaUtils() {
    }

    /**
     * 生成 RSA 密钥对
     *
     * @return Map: publicKey(Base64) / privateKey(Base64)
     */
    public static Map<String, String> generateKeyPair() throws Exception {
        KeyPairGenerator generator = KeyPairGenerator.getInstance(ALGORITHM);
        generator.initialize(KEY_SIZE);
        KeyPair keyPair = generator.generateKeyPair();
        String publicKey = Base64.getEncoder().encodeToString(keyPair.getPublic().getEncoded());
        String privateKey = Base64.getEncoder().encodeToString(keyPair.getPrivate().getEncoded());
        return Map.of("publicKey", publicKey, "privateKey", privateKey);
    }

    /**
     * 私钥解密（Base64 密文 -> 明文）
     */
    public static String decrypt(String privateKeyBase64, String cipherTextBase64) throws Exception {
        byte[] keyBytes = Base64.getDecoder().decode(privateKeyBase64);
        PrivateKey privateKey = KeyFactory.getInstance(ALGORITHM)
                .generatePrivate(new PKCS8EncodedKeySpec(keyBytes));
        Cipher cipher = Cipher.getInstance(CIPHER_TRANSFORMATION);
        cipher.init(Cipher.DECRYPT_MODE, privateKey);
        byte[] decrypted = cipher.doFinal(Base64.getDecoder().decode(cipherTextBase64));
        return new String(decrypted);
    }

    /**
     * 公钥加密（明文 -> Base64 密文），供测试与调试使用
     */
    public static String encrypt(String publicKeyBase64, String plainText) throws Exception {
        byte[] keyBytes = Base64.getDecoder().decode(publicKeyBase64);
        PublicKey publicKey = KeyFactory.getInstance(ALGORITHM)
                .generatePublic(new X509EncodedKeySpec(keyBytes));
        Cipher cipher = Cipher.getInstance(CIPHER_TRANSFORMATION);
        cipher.init(Cipher.ENCRYPT_MODE, publicKey);
        return Base64.getEncoder().encodeToString(cipher.doFinal(plainText.getBytes()));
    }

    private static String cacheKey(String privateKeyBase64, String cipherTextBase64) {
        return privateKeyBase64.hashCode() + ":" + cipherTextBase64;
    }
}
