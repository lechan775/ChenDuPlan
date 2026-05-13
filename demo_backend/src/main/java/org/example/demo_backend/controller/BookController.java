package org.example.demo_backend.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.example.demo_backend.common.Result;
import org.example.demo_backend.entity.Book;
import org.example.demo_backend.service.BookService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import org.example.demo_backend.dto.BookProgressResponse;
import org.springframework.web.bind.annotation.RequestParam;


import java.util.List;

@Tag(name = "词书", description = "词书列表与学习进度接口")
@RestController
public class BookController {
    private final BookService bookService;

    public BookController(BookService bookService) {
        this.bookService = bookService;
    }

    @Operation(summary = "获取全部词书列表")
    @GetMapping("/api/books")
    public Result<List<Book>> listBooks() {
        return Result.success(bookService.findAll());
    }

    @Operation(summary = "获取用户词书学习进度")
    @GetMapping("/api/books/progress")
    public Result<List<BookProgressResponse>> listBookProgress(
            @Parameter(description = "用户 ID") @RequestParam Long userId) {
        return Result.success(bookService.findProgressByUserId(userId));
    }

}
