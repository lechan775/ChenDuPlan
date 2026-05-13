package org.example.demo_backend.dto;

import lombok.Data;

@Data
public class WordSearchResponse {
    private Long id;
    private String word;
    private String phonetic;
    private String meaning;
    private String exampleText;
    private String source;
}
