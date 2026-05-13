package org.example.demo_backend.dto;

import lombok.Data;

@Data
public class BookProgressResponse {
    private Long id;
    private String title;
    private String levelTag;
    private String description;
    private Integer totalWords;
    private String accentColor;
    private String softColor;

    private Integer learnedWords;
    private Integer todayNew;
    private Integer todayReview;
    private Integer progress;
}
