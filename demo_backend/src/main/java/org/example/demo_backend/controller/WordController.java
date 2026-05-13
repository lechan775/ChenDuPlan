package org.example.demo_backend.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.example.demo_backend.common.Result;
import org.example.demo_backend.entity.Word;
import org.example.demo_backend.service.WordService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.example.demo_backend.dto.WordSearchResponse;


import java.util.List;

@Tag(name = "单词", description = "单词学习与查询接口")
@RestController
public class WordController {
    private final WordService wordService;

    public WordController(WordService wordService) {
        this.wordService = wordService;
    }

    @Operation(summary = "获取词书单词列表")
    @GetMapping("/api/words")
    public Result<List<Word>> listWords(
            @Parameter(description = "词书 ID") @RequestParam Long bookId) {
        return Result.success(wordService.findByBookId(bookId));
    }

    @Operation(summary = "获取下一个待学单词")
    @GetMapping("/api/words/next")
    public Result<Word> nextWord(
            @Parameter(description = "词书 ID") @RequestParam Long bookId) {
        return wordService.findNextByBookId(bookId);
    }

    @Operation(summary = "搜索单词")
    @GetMapping("/api/words/search")
    public Result<WordSearchResponse> searchWord(
            @Parameter(description = "搜索关键词") @RequestParam String keyword) {
        return wordService.search(keyword);
    }

    @Operation(summary = "从外部词典导入单词")
    @PostMapping("/api/words/import")
    public Result<Integer> importExternalWords(
            @Parameter(description = "词书 ID") @RequestParam Long bookId,
            @Parameter(description = "导入目标数量") @RequestParam(defaultValue = "300") Integer target) {
        return wordService.importExternalWords(bookId, target);
    }

}
