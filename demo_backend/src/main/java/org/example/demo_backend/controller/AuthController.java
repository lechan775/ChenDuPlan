package org.example.demo_backend.controller;

import jakarta.validation.Valid;
import org.example.demo_backend.common.Result;
import org.example.demo_backend.dto.LoginRequest;
import org.example.demo_backend.dto.RegisterRequest;
import org.example.demo_backend.dto.UserResponse;
import org.example.demo_backend.service.UserService;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
public class AuthController {
    private final UserService userService;

    public AuthController(UserService userService) {
        this.userService = userService;
    }

    @PostMapping("/register")
    public Result<UserResponse> register(@Valid @RequestBody RegisterRequest request) {
        return userService.register(request);
    }

    @PostMapping("/login")
    public Result<UserResponse> login(@Valid @RequestBody LoginRequest request) {
        return userService.login(request);
    }
}
