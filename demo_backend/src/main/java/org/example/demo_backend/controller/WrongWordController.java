package org.example.demo_backend.controller;

import org.example.demo_backend.common.Result;
import org.example.demo_backend.entity.WrongWord;
import org.example.demo_backend.service.WrongWordService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;


import java.util.List;

@RestController
public class WrongWordController {
    private final WrongWordService wrongWordService;

    public WrongWordController(WrongWordService wrongWordService) {
        this.wrongWordService = wrongWordService;
    }

    @GetMapping("/api/wrong-words")
    public Result<List<WrongWord>> listWrongWords(@RequestParam Long userId) {
        return Result.success(wrongWordService.findByUserId(userId));
    }

    @DeleteMapping("/api/wrong-words/{id}")
    public Result<String> deleteWrongWord(@PathVariable Long id, @RequestParam Long userId) {
        return wrongWordService.deleteById(id, userId);
    }

}
