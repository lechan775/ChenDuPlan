package org.example.demo_backend.entity;

import lombok.Data;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
public class StudyRecord {
    private Long id;
    private Long userId;
    private LocalDate studyDate;
    private String bookTitle;
    private Integer newCount;
    private Integer reviewCount;
    private Integer correctRate;
    private Integer finishedWords;
    private Integer durationMinutes;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
