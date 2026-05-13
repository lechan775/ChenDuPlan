package org.example.demo_backend.common;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.springframework.http.HttpStatus;
import org.springframework.validation.BeanPropertyBindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;

import static org.assertj.core.api.Assertions.assertThat;

@DisplayName("GlobalExceptionHandler 单元测试")
class GlobalExceptionHandlerTest {

    private final GlobalExceptionHandler handler = new GlobalExceptionHandler();

    @Nested
    @DisplayName("handleValidation()")
    class HandleValidation {

        @Test
        @DisplayName("单个字段校验失败，返回包含字段名和错误消息的统一格式")
        void shouldReturnUnifiedFormatForSingleFieldError() {
            BeanPropertyBindingResult bindingResult =
                    new BeanPropertyBindingResult(new Object(), "request");
            bindingResult.addError(new FieldError("request", "account", "账号不能为空"));

            MethodArgumentNotValidException ex =
                    new MethodArgumentNotValidException(null, bindingResult);

            Result<Void> result = handler.handleValidation(ex);

            assertThat(result.getCode()).isEqualTo(400);
            assertThat(result.getMessage()).contains("account");
            assertThat(result.getMessage()).contains("账号不能为空");
            assertThat(result.getData()).isNull();
        }

        @Test
        @DisplayName("多个字段校验失败，返回分号分隔的所有错误")
        void shouldJoinMultipleFieldErrors() {
            BeanPropertyBindingResult bindingResult =
                    new BeanPropertyBindingResult(new Object(), "request");
            bindingResult.addError(new FieldError("request", "account", "账号不能为空"));
            bindingResult.addError(new FieldError("request", "password", "密码至少 6 位"));

            MethodArgumentNotValidException ex =
                    new MethodArgumentNotValidException(null, bindingResult);

            Result<Void> result = handler.handleValidation(ex);

            assertThat(result.getMessage()).contains("account:");
            assertThat(result.getMessage()).contains("password:");
            assertThat(result.getMessage()).contains(";");
        }

        @Test
        @DisplayName("空错误列表兜底处理")
        void shouldHandleEmptyErrorsGracefully() {
            BeanPropertyBindingResult bindingResult =
                    new BeanPropertyBindingResult(new Object(), "request");
            MethodArgumentNotValidException ex =
                    new MethodArgumentNotValidException(null, bindingResult);

            Result<Void> result = handler.handleValidation(ex);

            assertThat(result.getCode()).isEqualTo(400);
            assertThat(result.getMessage()).isEqualTo("参数校验失败");
        }
    }

    @Nested
    @DisplayName("handleGeneral()")
    class HandleGeneral {

        @Test
        @DisplayName("通用异常返回 500，不暴露内部错误详情")
        void shouldReturn500WithoutExposingDetails() {
            Exception ex = new RuntimeException("内部敏感错误信息");

            Result<Void> result = handler.handleGeneral(ex);

            assertThat(result.getCode()).isEqualTo(500);
            assertThat(result.getMessage()).isEqualTo("服务器内部错误");
            assertThat(result.getData()).isNull();
        }
    }

    @Test
    @DisplayName("handleValidation 的 @ResponseStatus 注解应标注 HttpStatus.BAD_REQUEST")
    void shouldHaveBadRequestResponseStatus() throws NoSuchMethodException {
        var method = GlobalExceptionHandler.class.getMethod(
                "handleValidation", MethodArgumentNotValidException.class);
        var annotation = method.getAnnotation(
                org.springframework.web.bind.annotation.ResponseStatus.class);

        assertThat(annotation).isNotNull();
        assertThat(annotation.value()).isEqualTo(HttpStatus.BAD_REQUEST);
    }
}
