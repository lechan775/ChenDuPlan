package org.example.demo_backend.controller;

import org.example.demo_backend.common.Result;
import org.example.demo_backend.entity.NotebookWord;
import org.example.demo_backend.service.NotebookWordService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import jakarta.validation.Valid;
import org.example.demo_backend.dto.NotebookWordAddRequest;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;



import java.util.List;

@RestController
public class NotebookWordController {
    private final NotebookWordService notebookWordService;

    public NotebookWordController(NotebookWordService notebookWordService) {
        this.notebookWordService = notebookWordService;
    }

    @GetMapping("/api/notebook-words")
    public Result<List<NotebookWord>> listNotebookWords(@RequestParam Long userId) {
        return Result.success(notebookWordService.findByUserId(userId));
    }

    @PostMapping("/api/notebook-words")
    public Result<String> addNotebookWord(@Valid @RequestBody NotebookWordAddRequest request) {
        return notebookWordService.add(request);
    }

    @DeleteMapping("/api/notebook-words/{id}")
    public Result<String> deleteNotebookWord(@PathVariable Long id, @RequestParam Long userId) {
        return notebookWordService.deleteById(id, userId);
    }


}
