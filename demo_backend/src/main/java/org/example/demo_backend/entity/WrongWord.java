package org.example.demo_backend.entity;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class WrongWord {
    private Long id;
    private Long userId;
    private Long wordId;
    private String word;
    private String meaning;
    private String bookTitle;
    private Integer wrongCount;
    private LocalDateTime lastWrongAt;
    private String sentenceText;
    private String reasonText;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
