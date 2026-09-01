package org.example.springboot.config;

import io.swagger.v3.oas.models.Components;
import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Contact;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.security.SecurityRequirement;
import io.swagger.v3.oas.models.security.SecurityScheme;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * OpenAPI 3 文档配置。
 * 启动后访问 /swagger-ui.html 查看交互式文档，/v3/api-docs 获取 OpenAPI JSON。
 * 生产环境可通过环境变量 SPRINGDOC_SWAGGER_UI_ENABLED=false 关闭。
 */
@Configuration
public class OpenApiConfig {

    private static final String SECURITY_SCHEME_NAME = "token";

    @Bean
    public OpenAPI greenCertOpenAPI() {
        return new OpenAPI()
                .info(new Info()
                        .title("绿证交易平台 API")
                        .description("可再生能源绿色电力证书在线交易系统后端接口文档。"
                                + "除登录/注册/验证码等白名单接口外，均需在请求头携带 token 字段。")
                        .version("1.0.0")
                        .contact(new Contact().name("GreenCert Contributors")))
                .addSecurityItem(new SecurityRequirement().addList(SECURITY_SCHEME_NAME))
                .components(new Components()
                        .addSecuritySchemes(SECURITY_SCHEME_NAME,
                                new SecurityScheme()
                                        .type(SecurityScheme.Type.APIKEY)
                                        .in(SecurityScheme.In.HEADER)
                                        .name("token")
                                        .description("登录接口返回的 JWT token")));
    }
}
