package org.example.springboot.util;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.example.springboot.entity.Product;
import org.springframework.util.DigestUtils;

import java.util.StringJoiner;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * 缓存工具类
 * 1. 提供分页缓存指纹生成功能
 * 2. 提供邮箱验证码的存取与校验（5 分钟有效期，用于注册/找回密码）
 * 3. 提供登录失败次数限制（同一用户名 15 分钟内最多失败 5 次）
 */
public class CacheUtil {

    /** 邮箱验证码缓存：key = email, value = [code, expireAtMillis] */
    private static final Map<String, Object[]> EMAIL_CODE_CACHE = new ConcurrentHashMap<>();
    private static final long EMAIL_CODE_TTL_MS = 5 * 60 * 1000L;

    /** 登录失败计数缓存：key = username, value = [失败次数, 窗口起始毫秒] */
    private static final Map<String, Object[]> LOGIN_FAIL_CACHE = new ConcurrentHashMap<>();
    /** 登录失败最大次数 */
    private static final int LOGIN_FAIL_MAX = 5;
    /** 登录失败计数窗口（15 分钟） */
    private static final long LOGIN_FAIL_WINDOW_MS = 15 * 60 * 1000L;
    /** 登录失败后的锁定时长（15 分钟） */
    private static final long LOGIN_LOCK_MS = 15 * 60 * 1000L;

    /**
     * 生成分页结果 ID 指纹
     * 1. 提取分页结果中所有商品的 ID
     * 2. 使用竖线拼接 ID 字符串
     * 3. 对拼接后的字符串进行 MD5 哈希计算
     *
     * @param page 分页查询结果对象
     * @return 32 位 MD5 哈希字符串
     */
    public static String generateIdFingerprint(Page<Product> page) {
        StringJoiner sj = new StringJoiner("|");
        page.getRecords().forEach(p -> sj.add(p.getId().toString()));
        return DigestUtils.md5DigestAsHex(sj.toString().getBytes());
    }

    /**
     * 保存邮箱验证码，5 分钟后自动过期
     */
    public static void saveEmailCode(String email, String code) {
        EMAIL_CODE_CACHE.put(email, new Object[]{code, System.currentTimeMillis() + EMAIL_CODE_TTL_MS});
    }

    /**
     * 校验邮箱验证码：验证通过后立即失效（一次性使用）
     *
     * @return true 表示验证通过
     */
    public static boolean verifyEmailCode(String email, String code) {
        if (email == null || code == null) {
            return false;
        }
        Object[] entry = EMAIL_CODE_CACHE.get(email);
        if (entry == null) {
            return false;
        }
        String savedCode = (String) entry[0];
        long expireAt = (long) entry[1];
        if (System.currentTimeMillis() > expireAt) {
            EMAIL_CODE_CACHE.remove(email);
            return false;
        }
        if (savedCode.equals(code.trim())) {
            EMAIL_CODE_CACHE.remove(email); // 一次性使用
            return true;
        }
        return false;
    }

    /**
     * 判断用户名是否因连续登录失败被锁定
     * <p>
     * 记录结构：[失败次数, 首次失败毫秒]。失败次数达到上限后，
     * 以"达到上限时刻"起 {@link #LOGIN_LOCK_MS} 内禁止登录。
     * 简化实现：锁定截止 = 窗口起始 + 窗口时长 与 窗口起始 + 锁定时长 的较大值。
     *
     * @return 0 表示未锁定；>0 表示剩余锁定秒数
     */
    public static long getLoginLockRemainSeconds(String username) {
        if (username == null) {
            return 0;
        }
        Object[] entry = LOGIN_FAIL_CACHE.get(username);
        if (entry == null) {
            return 0;
        }
        int count = (int) entry[0];
        long windowStart = (long) entry[1];
        if (count < LOGIN_FAIL_MAX) {
            return 0;
        }
        long lockEnd = windowStart + Math.max(LOGIN_FAIL_WINDOW_MS, LOGIN_LOCK_MS);
        long remain = lockEnd - System.currentTimeMillis();
        return remain > 0 ? remain / 1000 : 0;
    }

    /**
     * 记录一次登录失败；达到上限后锁定
     */
    public static void recordLoginFailure(String username) {
        if (username == null) {
            return;
        }
        long now = System.currentTimeMillis();
        LOGIN_FAIL_CACHE.compute(username, (k, entry) -> {
            if (entry == null || now - (long) entry[1] > LOGIN_FAIL_WINDOW_MS) {
                return new Object[]{1, now};
            }
            return new Object[]{(int) entry[0] + 1, entry[1]};
        });
    }

    /**
     * 登录成功后清除失败计数
     */
    public static void clearLoginFailures(String username) {
        if (username != null) {
            LOGIN_FAIL_CACHE.remove(username);
        }
    }
}
