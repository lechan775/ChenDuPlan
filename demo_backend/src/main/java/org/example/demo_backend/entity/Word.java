package org.example.demo_backend.entity;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class Word {
    private Long id;
    private Long bookId;
    private String word;
    private String phonetic;
    private String meaning;
    private String memoryTip;
    private String exampleText;
    private String translationText;
    private String answer;
    private String difficulty;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
