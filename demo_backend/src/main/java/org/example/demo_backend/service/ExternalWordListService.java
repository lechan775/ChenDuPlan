package org.example.demo_backend.service;

import org.example.demo_backend.entity.Word;
import org.example.demo_backend.mapper.WordMapper;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;

import java.time.Duration;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Service
public class ExternalWordListService {
    private static final int DEFAULT_TARGET_COUNT = 300;
    private static final int MAX_TARGET_COUNT = 1000;

    private final WebClient datamuseClient = WebClient.create("https://api.datamuse.com");
    private final WordMapper wordMapper;

    public ExternalWordListService(WordMapper wordMapper) {
        this.wordMapper = wordMapper;
    }

    public int ensureWordsForBook(Long bookId) {
        return ensureWordsForBook(bookId, DEFAULT_TARGET_COUNT);
    }

    public int ensureWordsForBook(Long bookId, Integer targetCount) {
        int safeTarget = normalizeTarget(targetCount);
        int currentCount = wordMapper.countOfficialByBookId(bookId);
        if (currentCount >= safeTarget) {
            return 0;
        }

        int addedCount = 0;
        String[] seeds = seedsForBook(bookId);
        for (String seed : seeds) {
            List<WordCandidate> candidates = fetchCandidates(seed, safeTarget);
            if (candidates.isEmpty()) {
                return addedCount;
            }

            for (WordCandidate candidate : candidates) {
                if (wordMapper.countOfficialByBookIdAndWord(bookId, candidate.word) > 0) {
                    continue;
                }

                Word word = buildWord(bookId, candidate);
                if (word.getMeaning() == null || word.getMeaning().isBlank()) {
                    continue;
                }

                wordMapper.insertExternalPracticeWord(word);
                addedCount++;
                currentCount++;

                if (currentCount >= safeTarget) {
                    return addedCount;
                }
            }
        }

        return addedCount;
    }

    private int normalizeTarget(Integer targetCount) {
        if (targetCount == null || targetCount <= 0) {
            return DEFAULT_TARGET_COUNT;
        }
        return Math.min(targetCount, MAX_TARGET_COUNT);
    }

    private String[] seedsForBook(Long bookId) {
        if (bookId != null && bookId == 2L) {
            return new String[] {
                    "academic", "analysis", "technology", "research", "society", "economy",
                    "education", "culture", "policy", "environment", "innovation", "psychology"
            };
        }
        if (bookId != null && bookId == 3L) {
            return new String[] {
                    "theory", "research", "argument", "evidence", "concept", "logic",
                    "methodology", "hypothesis", "interpretation", "framework", "literature", "critique"
            };
        }
        return new String[] {
                "study", "daily", "school", "learning", "reading", "memory",
                "communication", "travel", "health", "work", "family", "technology"
        };
    }

    private List<WordCandidate> fetchCandidates(String seed, int targetCount) {
        try {
            List<Map<String, Object>> response = datamuseClient.get()
                    .uri(uriBuilder -> uriBuilder
                            .path("/words")
                            .queryParam("ml", seed)
                            .queryParam("md", "d")
                            .queryParam("max", Math.max(50, targetCount))
                            .build())
                    .retrieve()
                    .bodyToMono(List.class)
                    .block(Duration.ofSeconds(5));

            List<WordCandidate> candidates = new ArrayList<>();
            if (response == null) {
                return candidates;
            }

            for (Map<String, Object> item : response) {
                Object wordValue = item.get("word");
                if (!(wordValue instanceof String wordText)) {
                    continue;
                }

                String cleanWord = wordText.trim().toLowerCase();
                if (!cleanWord.matches("[a-z]{3,20}")) {
                    continue;
                }

                candidates.add(new WordCandidate(cleanWord, firstDefinition(item)));
            }
            return candidates;
        } catch (Exception e) {
            return new ArrayList<>();
        }
    }

    private String firstDefinition(Map<String, Object> item) {
        Object defsValue = item.get("defs");
        if (!(defsValue instanceof List<?> defs) || defs.isEmpty()) {
            return "";
        }

        Object first = defs.get(0);
        if (!(first instanceof String definition)) {
            return "";
        }

        int tabIndex = definition.indexOf('\t');
        if (tabIndex >= 0 && tabIndex < definition.length() - 1) {
            return definition.substring(tabIndex + 1).trim();
        }
        return definition.trim();
    }

    private Word buildWord(Long bookId, WordCandidate candidate) {
        String meaning = candidate.definition;

        Word word = new Word();
        word.setBookId(bookId);
        word.setWord(candidate.word);
        word.setPhonetic("");
        word.setMeaning(meaning);
        word.setMemoryTip("From Datamuse word list API");
        word.setExampleText("");
        word.setTranslationText("");
        word.setAnswer(meaning);
        word.setDifficulty("External");
        return word;
    }

    private static class WordCandidate {
        private final String word;
        private final String definition;

        private WordCandidate(String word, String definition) {
            this.word = word;
            this.definition = definition;
        }
    }
}
