package org.example.demo_backend.controller;

import jakarta.validation.Valid;
import org.example.demo_backend.common.Result;
import org.example.demo_backend.dto.UpdateProfileRequest;
import org.example.demo_backend.dto.UserResponse;
import org.example.demo_backend.service.UserService;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/user")
public class UserController {
    private final UserService userService;

    public UserController(UserService userService) {
        this.userService = userService;
    }

    @GetMapping("/profile")
    public Result<UserResponse> getProfile(@RequestParam Long userId) {
        return userService.getProfile(userId);
    }

    @PutMapping("/profile")
    public Result<UserResponse> updateProfile(@Valid @RequestBody UpdateProfileRequest request) {
        return userService.updateProfile(request);
    }
}
