package org.example.springboot;

import org.example.springboot.util.CacheUtil;
import org.example.springboot.util.RsaUtils;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.util.Map;

import static org.junit.jupiter.api.Assertions.*;

/**
 * 纯工具类单元测试（不依赖 Spring 容器与数据库，CI 可快速执行）
 */
class UtilTests {

    @Test
    @DisplayName("邮箱验证码：正确验证码通过且一次性失效")
    void emailCode_shouldPassOnce() {
        CacheUtil.saveEmailCode("t1@example.com", "886754");
        assertTrue(CacheUtil.verifyEmailCode("t1@example.com", "886754"), "正确验证码应通过");
        assertFalse(CacheUtil.verifyEmailCode("t1@example.com", "886754"), "验证码应一次性失效");
    }

    @Test
    @DisplayName("邮箱验证码：错误验证码不通过")
    void emailCode_shouldRejectWrongCode() {
        CacheUtil.saveEmailCode("t2@example.com", "112233");
        assertFalse(CacheUtil.verifyEmailCode("t2@example.com", "445566"));
        assertFalse(CacheUtil.verifyEmailCode(null, "112233"));
        assertFalse(CacheUtil.verifyEmailCode("t2@example.com", null));
    }

    @Test
    @DisplayName("登录失败锁定：未失败时未锁定")
    void loginLock_unlockedInitially() {
        assertTrue(CacheUtil.getLoginLockRemainSeconds("ghost-user") == 0);
    }

    @Test
    @DisplayName("登录失败锁定：连续失败达上限后锁定")
    void loginLock_locksAfterMaxFailures() {
        String user = "lock-test-user";
        for (int i = 0; i < 5; i++) {
            CacheUtil.recordLoginFailure(user);
        }
        assertTrue(CacheUtil.getLoginLockRemainSeconds(user) > 0, "达到 5 次失败后应锁定");
        CacheUtil.clearLoginFailures(user);
        assertEquals(0, CacheUtil.getLoginLockRemainSeconds(user), "清除后应解锁");
    }

    @Test
    @DisplayName("RSA：公钥加密私钥解密往返一致")
    void rsa_roundTrip() throws Exception {
        Map<String, String> pair = RsaUtils.generateKeyPair();
        String plain = "GreenCert@2026";
        String cipher = RsaUtils.encrypt(pair.get("publicKey"), plain);
        assertNotEquals(plain, cipher);
        assertEquals(plain, RsaUtils.decrypt(pair.get("privateKey"), cipher));
    }

    @Test
    @DisplayName("RSA：不同密钥对无法解密")
    void rsa_wrongKeyFails() throws Exception {
        Map<String, String> pairA = RsaUtils.generateKeyPair();
        Map<String, String> pairB = RsaUtils.generateKeyPair();
        String cipher = RsaUtils.encrypt(pairA.get("publicKey"), "secret");
        assertThrows(Exception.class,
                () -> RsaUtils.decrypt(pairB.get("privateKey"), cipher));
    }
}
