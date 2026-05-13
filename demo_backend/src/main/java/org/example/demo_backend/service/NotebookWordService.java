package org.example.demo_backend.service;

import org.example.demo_backend.entity.NotebookWord;
import org.example.demo_backend.mapper.NotebookWordMapper;
import org.springframework.stereotype.Service;
import org.example.demo_backend.common.Result;
import org.example.demo_backend.dto.NotebookWordAddRequest;


import java.util.List;

@Service
public class NotebookWordService {
    private final NotebookWordMapper notebookWordMapper;

    public NotebookWordService(NotebookWordMapper notebookWordMapper) {
        this.notebookWordMapper = notebookWordMapper;
    }

    public List<NotebookWord> findByUserId(Long userId) {
        return notebookWordMapper.findByUserId(userId);
    }

    public Result<String> add(NotebookWordAddRequest request) {
        if (request.getMasteryLabel() == null || request.getMasteryLabel().isBlank()) {
            request.setMasteryLabel("待复习");
        }

        if (request.getNoteText() == null) {
            request.setNoteText("");
        }

        if (notebookWordMapper.countByUserIdAndWord(request) > 0) {
            return Result.success("notebook word already exists");
        }

        notebookWordMapper.insert(request);
        return Result.success("add notebook word success");
    }

    public Result<String> deleteById(Long id, Long userId) {
        int rows = notebookWordMapper.deleteById(id, userId);

        if (rows == 0) {
            return Result.error("notebook word not found");
        }

        return Result.success("delete notebook word success");
    }

}



