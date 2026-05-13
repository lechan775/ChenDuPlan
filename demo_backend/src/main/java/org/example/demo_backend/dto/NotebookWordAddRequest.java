package org.example.demo_backend.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class NotebookWordAddRequest {
    @NotNull(message = "userId cannot be null")
    private Long userId;

    private Long wordId;

    @NotBlank(message = "word cannot be empty")
    private String word;

    @NotBlank(message = "meaning cannot be empty")
    private String meaning;

    @NotBlank(message = "bookTitle cannot be empty")
    private String bookTitle;

    private String masteryLabel;
    private String nextReview;
    private String noteText;
}
