package org.example.demo_backend.service;

import org.example.demo_backend.entity.Word;
import org.example.demo_backend.mapper.WordMapper;
import org.springframework.stereotype.Service;
import org.example.demo_backend.common.Result;
import org.example.demo_backend.dto.WordSearchResponse;


import java.util.List;

@Service
public class WordService {
    private final WordMapper wordMapper;
    private final ExternalDictionaryService externalDictionaryService;
    private final ExternalWordListService externalWordListService;

    public WordService(WordMapper wordMapper,
                       ExternalDictionaryService externalDictionaryService,
                       ExternalWordListService externalWordListService) {
        this.wordMapper = wordMapper;
        this.externalDictionaryService = externalDictionaryService;
        this.externalWordListService = externalWordListService;
    }


    public List<Word> findByBookId(Long bookId) {
        externalWordListService.ensureWordsForBook(bookId);
        return wordMapper.findByBookId(bookId);
    }

    public Result<Integer> importExternalWords(Long bookId, Integer targetCount) {
        return Result.success(externalWordListService.ensureWordsForBook(bookId, targetCount));
    }

    public Result<Word> findNextByBookId(Long bookId) {
        Word word = wordMapper.findRandomByBookId(bookId);

        if (word == null) {
            return Result.error("word not found");
        }

        return Result.success(word);
    }

    public Result<WordSearchResponse> search(String keyword) {
        String cleanKeyword = keyword.trim().toLowerCase();

        WordSearchResponse cached = wordMapper.findSearchCache(cleanKeyword);
        if (cached != null) {
            return Result.success(cached);
        }

        WordSearchResponse response = externalDictionaryService.search(cleanKeyword);
        if (response == null) {
            return Result.error("word not found");
        }

        return Result.success(response);
    }

}
