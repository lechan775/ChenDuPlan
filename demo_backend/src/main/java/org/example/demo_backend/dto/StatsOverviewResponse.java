package org.example.demo_backend.dto;

import lombok.Data;

@Data
public class StatsOverviewResponse {
    private Long userId;
    private Integer totalLearnedWords;
    private Integer streakDays;
    private Integer accuracyRate;
    private Integer reviewDue;
    private Integer todayFinishedWords;
    private Integer todayCorrectRate;
}
