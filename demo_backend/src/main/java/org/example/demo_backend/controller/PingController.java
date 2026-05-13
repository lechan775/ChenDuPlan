package org.example.demo_backend.controller;

import org.example.demo_backend.common.Result;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class PingController {

    @GetMapping("/api/ping")
    public Result<String> ping() {
        return Result.success("pong");
    }
}
