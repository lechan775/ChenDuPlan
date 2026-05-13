package org.example.demo_backend.dto;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class UpdateProfileRequest {
    private Long userId;

    @NotBlank(message = "nickname cannot be empty")
    private String nickname;

    @Min(value = 1, message = "daily target must be greater than 0")
    private Integer dailyTarget;

    private String signature;

    private Long selectedBookId;
}
