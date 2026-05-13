package org.example.demo_backend.entity;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class Book {
    private Long id;
    private String title;
    private String levelTag;
    private String description;
    private Integer totalWords;
    private String accentColor;
    private String softColor;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
