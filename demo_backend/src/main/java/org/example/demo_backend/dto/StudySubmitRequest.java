package org.example.demo_backend.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class StudySubmitRequest {
    @NotNull(message = "userId cannot be null")
    private Long userId;

    @NotBlank(message = "bookTitle cannot be empty")
    private String bookTitle;

    private Long wordId;

    @NotBlank(message = "word cannot be empty")
    private String word;

    @NotBlank(message = "meaning cannot be empty")
    private String meaning;

    @NotNull(message = "isCorrect cannot be null")
    private Boolean isCorrect;

    private String selectedAnswer;
    private String correctAnswer;
    private String sentence;
    private String reason;
}
