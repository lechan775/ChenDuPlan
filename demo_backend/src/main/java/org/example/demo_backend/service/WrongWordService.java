package org.example.demo_backend.service;

import org.example.demo_backend.entity.WrongWord;
import org.example.demo_backend.mapper.WrongWordMapper;
import org.springframework.stereotype.Service;
import org.example.demo_backend.common.Result;

import java.util.List;

@Service
public class WrongWordService {
    private final WrongWordMapper wrongWordMapper;

    public WrongWordService(WrongWordMapper wrongWordMapper) {
        this.wrongWordMapper = wrongWordMapper;
    }

    public List<WrongWord> findByUserId(Long userId) {
        return wrongWordMapper.findByUserId(userId);
    }

    public Result<String> deleteById(Long id, Long userId) {
        int rows = wrongWordMapper.deleteById(id, userId);

        if (rows == 0) {
            return Result.error("wrong word not found");
        }

        return Result.success("delete wrong word success");
    }

}
