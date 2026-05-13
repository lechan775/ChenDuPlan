package org.example.demo_backend.dto;

import lombok.Data;
import org.example.demo_backend.entity.User;

@Data
public class UserResponse {
    private Long id;
    private String account;
    private String nickname;
    private Integer dailyTarget;
    private String signature;
    private Long selectedBookId;
    private Integer totalLearnedWords;
    private Integer streakDays;
    private Integer accuracyRate;
    private Integer reviewDue;

    public static UserResponse from(User user) {
        UserResponse response = new UserResponse();
        response.setId(user.getId());
        response.setAccount(user.getAccount());
        response.setNickname(user.getNickname());
        response.setDailyTarget(user.getDailyTarget());
        response.setSignature(user.getSignature());
        response.setSelectedBookId(user.getSelectedBookId());
        response.setTotalLearnedWords(user.getTotalLearnedWords());
        response.setStreakDays(user.getStreakDays());
        response.setAccuracyRate(user.getAccuracyRate());
        response.setReviewDue(user.getReviewDue());
        return response;
    }
}
