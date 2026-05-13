package org.example.demo_backend.controller;

import org.example.demo_backend.common.Result;
import org.example.demo_backend.entity.Book;
import org.example.demo_backend.service.BookService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import org.example.demo_backend.dto.BookProgressResponse;
import org.springframework.web.bind.annotation.RequestParam;


import java.util.List;

@RestController
public class BookController {
    private final BookService bookService;

    public BookController(BookService bookService) {
        this.bookService = bookService;
    }

    @GetMapping("/api/books")
    public Result<List<Book>> listBooks() {
        return Result.success(bookService.findAll());
    }

    @GetMapping("/api/books/progress")
    public Result<List<BookProgressResponse>> listBookProgress(@RequestParam Long userId) {
        return Result.success(bookService.findProgressByUserId(userId));
    }

}
