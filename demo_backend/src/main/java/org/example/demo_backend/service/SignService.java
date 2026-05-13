package org.example.demo_backend.service;

import org.example.demo_backend.common.Result;
import org.example.demo_backend.mapper.SignMapper;
import org.springframework.stereotype.Service;

@Service
public class SignService {
    private final SignMapper signMapper;

    public SignService(SignMapper signMapper) {
        this.signMapper = signMapper;
    }

    public Result<Boolean> status(Long userId) {
        return Result.success(signMapper.countTodayByUserId(userId) > 0);
    }

    public Result<String> sign(Long userId) {
        if (signMapper.countTodayByUserId(userId) > 0) {
            return Result.success("already signed");
        }

        signMapper.insertToday(userId);
        return Result.success("sign success");
    }
}
