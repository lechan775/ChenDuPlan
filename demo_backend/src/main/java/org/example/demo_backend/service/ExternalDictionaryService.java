package org.example.demo_backend.service;

import org.example.demo_backend.dto.WordSearchResponse;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;

import java.util.List;
import java.util.Map;

@Service
public class ExternalDictionaryService {
    private final WebClient webClient = WebClient.create("https://api.dictionaryapi.dev");

    public WordSearchResponse search(String keyword) {
        List<Map<String, Object>> response = webClient.get()
                .uri("/api/v2/entries/en/{word}", keyword)
                .retrieve()
                .bodyToMono(List.class)
                .block();

        if (response == null || response.isEmpty()) {
            return null;
        }

        Map<String, Object> first = response.get(0);

        WordSearchResponse result = new WordSearchResponse();
        result.setWord((String) first.get("word"));
        result.setSource("Free Dictionary API");

        List<Map<String, Object>> phonetics = (List<Map<String, Object>>) first.get("phonetics");
        if (phonetics != null && !phonetics.isEmpty()) {
            result.setPhonetic((String) phonetics.get(0).get("text"));
        }

        List<Map<String, Object>> meanings = (List<Map<String, Object>>) first.get("meanings");
        if (meanings != null && !meanings.isEmpty()) {
            List<Map<String, Object>> definitions = (List<Map<String, Object>>) meanings.get(0).get("definitions");
            if (definitions != null && !definitions.isEmpty()) {
                Map<String, Object> definition = definitions.get(0);
                result.setMeaning((String) definition.get("definition"));
                result.setExampleText((String) definition.get("example"));
            }
        }

        return result;
    }
}
