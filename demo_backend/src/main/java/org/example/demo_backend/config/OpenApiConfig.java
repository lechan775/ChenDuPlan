package org.example.demo_backend.config;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Contact;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.info.License;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * OpenAPI / Swagger 配置，访问 http://localhost:8080/swagger-ui.html 浏览 API 文档。
 */
@Configuration
public class OpenApiConfig {

    @Bean
    public OpenAPI chenDuPlanOpenAPI() {
        return new OpenAPI()
                .info(new Info()
                        .title("晨读计划 API 文档")
                        .description("ChenDu Plan — 基于 HarmonyOS + Spring Boot 的背单词应用后端 RESTful API")
                        .version("0.0.1")
                        .contact(new Contact()
                                .name("lechan775")
                                .url("https://github.com/lechan775/ChenDuPlan"))
                        .license(new License()
                                .name("MIT")
                                .url("https://github.com/lechan775/ChenDuPlan/blob/main/LICENSE")));
    }
}
