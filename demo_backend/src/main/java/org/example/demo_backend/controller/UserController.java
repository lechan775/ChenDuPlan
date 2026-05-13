package org.example.demo_backend.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.example.demo_backend.common.Result;
import org.example.demo_backend.dto.UpdateProfileRequest;
import org.example.demo_backend.dto.UserResponse;
import org.example.demo_backend.service.UserService;
import org.springframework.web.bind.annotation.*;

@Tag(name = "用户", description = "用户个人信息管理接口")
@RestController
@RequestMapping("/api/user")
public class UserController {
    private final UserService userService;

    public UserController(UserService userService) {
        this.userService = userService;
    }

    @Operation(summary = "获取个人信息", description = "根据用户 ID 返回个人资料和学习统计")
    @GetMapping("/profile")
    public Result<UserResponse> getProfile(
            @Parameter(description = "用户 ID") @RequestParam Long userId) {
        return userService.getProfile(userId);
    }

    @Operation(summary = "修改个人信息", description = "更新昵称、每日目标、签名、默认词书")
    @PutMapping("/profile")
    public Result<UserResponse> updateProfile(@Valid @RequestBody UpdateProfileRequest request) {
        return userService.updateProfile(request);
    }
}
