package org.example.demo_backend.entity;

import lombok.Data;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
public class NotebookWord {
    private Long id;
    private Long userId;
    private Long wordId;
    private String word;
    private String meaning;
    private String bookTitle;
    private String masteryLabel;
    private LocalDate nextReview;
    private LocalDateTime addedAt;
    private String noteText;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
