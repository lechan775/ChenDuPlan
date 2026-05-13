package org.example.demo_backend.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.example.demo_backend.entity.StudyRecord;

import java.util.List;

@Mapper
public interface StudyRecordMapper {
    @Select("""
        SELECT id, user_id AS userId,
               study_date AS studyDate,
               book_title AS bookTitle,
               new_count AS newCount,
               review_count AS reviewCount,
               correct_rate AS correctRate,
               finished_words AS finishedWords,
               duration_minutes AS durationMinutes,
               created_at AS createdAt,
               updated_at AS updatedAt
        FROM study_records
        WHERE user_id = #{userId}
        ORDER BY study_date DESC
    """)
    List<StudyRecord> findByUserId(Long userId);
}
