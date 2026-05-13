package org.example.demo_backend.service;

import org.example.demo_backend.entity.Book;
import org.example.demo_backend.mapper.BookMapper;
import org.springframework.stereotype.Service;
import org.example.demo_backend.dto.BookProgressResponse;


import java.util.List;

@Service
public class BookService {
    private final BookMapper bookMapper;

    public BookService(BookMapper bookMapper) {
        this.bookMapper = bookMapper;
    }

    public List<Book> findAll() {
        return bookMapper.findAll();
    }

    public List<BookProgressResponse> findProgressByUserId(Long userId) {
        return bookMapper.findProgressByUserId(userId);
    }

}
