package org.example.demo_backend.controller;

import org.example.demo_backend.common.Result;
import org.example.demo_backend.service.SignService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class SignController {
    private final SignService signService;

    public SignController(SignService signService) {
        this.signService = signService;
    }

    @GetMapping("/api/sign/status")
    public Result<Boolean> status(@RequestParam Long userId) {
        return signService.status(userId);
    }

    @PostMapping("/api/sign")
    public Result<String> sign(@RequestParam Long userId) {
        return signService.sign(userId);
    }
}
