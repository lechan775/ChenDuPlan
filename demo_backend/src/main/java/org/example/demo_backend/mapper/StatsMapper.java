package org.example.demo_backend.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.example.demo_backend.dto.StatsOverviewResponse;

import java.time.LocalDate;
import java.util.List;

@Mapper
public interface StatsMapper {
    @Select("""
        SELECT id AS userId,
               review_due AS reviewDue
        FROM users
        WHERE id = #{userId}
    """)
    StatsOverviewResponse findUserStats(Long userId);

    @Select("""
        SELECT COALESCE(SUM(finished_words), 0)
        FROM study_records
        WHERE user_id = #{userId}
    """)
    Integer findTotalLearnedWords(Long userId);

    @Select("""
        SELECT COALESCE(ROUND(AVG(correct_rate)), 0)
        FROM study_records
        WHERE user_id = #{userId}
    """)
    Integer findAccuracyRate(Long userId);

    @Select("""
        SELECT DISTINCT study_date
        FROM study_records
        WHERE user_id = #{userId}
        ORDER BY study_date DESC
    """)
    List<LocalDate> findStudyDates(Long userId);

    @Select("""
        SELECT COALESCE(SUM(finished_words), 0)
        FROM study_records
        WHERE user_id = #{userId}
          AND study_date = CURDATE()
    """)
    Integer findTodayFinishedWords(Long userId);

    @Select("""
        SELECT COALESCE(ROUND(AVG(correct_rate)), 0)
        FROM study_records
        WHERE user_id = #{userId}
          AND study_date = CURDATE()
    """)
    Integer findTodayCorrectRate(Long userId);
}
