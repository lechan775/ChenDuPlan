package org.example.demo_backend.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.example.demo_backend.common.Result;
import org.example.demo_backend.dto.LoginRequest;
import org.example.demo_backend.dto.RegisterRequest;
import org.example.demo_backend.dto.UserResponse;
import org.example.demo_backend.service.UserService;
import org.springframework.web.bind.annotation.*;

@Tag(name = "认证", description = "用户注册与登录接口")
@RestController
@RequestMapping("/api/auth")
public class AuthController {
    private final UserService userService;

    public AuthController(UserService userService) {
        this.userService = userService;
    }

    @Operation(summary = "用户注册", description = "创建新用户账号，密码使用 SHA-256 哈希存储")
    @PostMapping("/register")
    public Result<UserResponse> register(@Valid @RequestBody RegisterRequest request) {
        return userService.register(request);
    }

    @Operation(summary = "用户登录", description = "验证账号密码，登录成功返回用户信息")
    @PostMapping("/login")
    public Result<UserResponse> login(@Valid @RequestBody LoginRequest request) {
        return userService.login(request);
    }
}
