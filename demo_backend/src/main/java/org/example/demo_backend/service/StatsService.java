package org.example.demo_backend.service;

import org.example.demo_backend.common.Result;
import org.example.demo_backend.dto.StatsOverviewResponse;
import org.example.demo_backend.mapper.StatsMapper;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;

@Service
public class StatsService {
    private final StatsMapper statsMapper;

    public StatsService(StatsMapper statsMapper) {
        this.statsMapper = statsMapper;
    }

    public Result<StatsOverviewResponse> overview(Long userId) {
        StatsOverviewResponse response = statsMapper.findUserStats(userId);

        if (response == null) {
            return Result.error("user not found");
        }

        response.setTotalLearnedWords(statsMapper.findTotalLearnedWords(userId));
        response.setAccuracyRate(statsMapper.findAccuracyRate(userId));
        response.setStreakDays(calculateStreak(statsMapper.findStudyDates(userId)));
        response.setTodayFinishedWords(statsMapper.findTodayFinishedWords(userId));
        response.setTodayCorrectRate(statsMapper.findTodayCorrectRate(userId));

        return Result.success(response);
    }

    private Integer calculateStreak(List<LocalDate> studyDates) {
        if (studyDates == null || studyDates.isEmpty()) {
            return 0;
        }

        int streak = 0;
        LocalDate cursor = LocalDate.now();

        for (LocalDate studyDate : studyDates) {
            if (studyDate.equals(cursor)) {
                streak++;
                cursor = cursor.minusDays(1);
            } else if (studyDate.isBefore(cursor)) {
                break;
            }
        }

        return streak;
    }
}
