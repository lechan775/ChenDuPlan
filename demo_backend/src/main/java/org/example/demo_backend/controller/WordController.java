package org.example.demo_backend.controller;

import org.example.demo_backend.common.Result;
import org.example.demo_backend.entity.Word;
import org.example.demo_backend.service.WordService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.example.demo_backend.dto.WordSearchResponse;


import java.util.List;

@RestController
public class WordController {
    private final WordService wordService;

    public WordController(WordService wordService) {
        this.wordService = wordService;
    }



    @GetMapping("/api/words")
    public Result<List<Word>> listWords(@RequestParam Long bookId) {
        return Result.success(wordService.findByBookId(bookId));
    }

    @GetMapping("/api/words/next")
    public Result<Word> nextWord(@RequestParam Long bookId) {
        return wordService.findNextByBookId(bookId);
    }

    @GetMapping("/api/words/search")
    public Result<WordSearchResponse> searchWord(@RequestParam String keyword) {
        return wordService.search(keyword);
    }

    @PostMapping("/api/words/import")
    public Result<Integer> importExternalWords(@RequestParam Long bookId,
                                               @RequestParam(defaultValue = "300") Integer target) {
        return wordService.importExternalWords(bookId, target);
    }

}
