package org.example.springboot.config;

import jakarta.servlet.http.HttpServletRequest;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.slf4j.MDC;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import java.util.UUID;

/**
 * API 访问日志切面
 * <p>
 * 每个请求生成唯一 traceId 写入 MDC（日志格式中 %X{traceId} 可输出），
 * 便于跨日志行追踪一次请求的完整链路；同时记录请求耗时，慢请求（>2s）WARN 级别提示。
 */
@Aspect
@Component
public class ApiLoggingAspect {

    private static final Logger LOGGER = LoggerFactory.getLogger(ApiLoggingAspect.class);
    private static final long SLOW_THRESHOLD_MS = 2000L;

    @Around("execution(* org.example.springboot.controller..*(..))")
    public Object around(ProceedingJoinPoint joinPoint) throws Throwable {
        long start = System.currentTimeMillis();
        String traceId = UUID.randomUUID().toString().replace("-", "").substring(0, 16);
        MDC.put("traceId", traceId);

        String method = null;
        String uri = null;
        try {
            ServletRequestAttributes attrs =
                    (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
            if (attrs != null) {
                HttpServletRequest request = attrs.getRequest();
                method = request.getMethod();
                uri = request.getRequestURI();
            }
        } catch (Exception ignored) {
            // 非 Web 上下文（如定时任务调用）时忽略
        }

        try {
            Object result = joinPoint.proceed();
            long cost = System.currentTimeMillis() - start;
            if (cost > SLOW_THRESHOLD_MS) {
                LOGGER.warn("[SLOW] {} {} cost={}ms", method, uri, cost);
            } else {
                LOGGER.info("{} {} cost={}ms", method, uri, cost);
            }
            return result;
        } finally {
            MDC.remove("traceId");
        }
    }
}
