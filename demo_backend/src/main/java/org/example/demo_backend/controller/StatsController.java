package org.example.demo_backend.controller;

import org.example.demo_backend.common.Result;
import org.example.demo_backend.dto.StatsOverviewResponse;
import org.example.demo_backend.service.StatsService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class StatsController {
    private final StatsService statsService;

    public StatsController(StatsService statsService) {
        this.statsService = statsService;
    }

    @GetMapping("/api/stats/overview")
    public Result<StatsOverviewResponse> overview(@RequestParam Long userId) {
        return statsService.overview(userId);
    }
}
