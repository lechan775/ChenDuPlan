package org.example.demo_backend.entity;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class User {
    private Long id;
    private String account;
    private String passwordHash;
    private String nickname;
    private Integer dailyTarget;
    private String signature;
    private Long selectedBookId;
    private Integer totalLearnedWords;
    private Integer streakDays;
    private Integer accuracyRate;
    private Integer reviewDue;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
