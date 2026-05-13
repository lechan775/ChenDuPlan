package org.example.demo_backend.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.example.demo_backend.entity.Word;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Options;
import org.apache.ibatis.annotations.Param;
import org.example.demo_backend.dto.WordSearchResponse;


import java.util.List;

@Mapper
public interface WordMapper {
    @Select("""
        SELECT COUNT(*)
        FROM words
        WHERE book_id = #{bookId}
          AND (difficulty IS NULL OR difficulty <> 'API')
    """)
    int countOfficialByBookId(Long bookId);

    @Select("""
        SELECT COUNT(*)
        FROM words
        WHERE book_id = #{bookId}
          AND word = #{word}
          AND (difficulty IS NULL OR difficulty <> 'API')
    """)
    int countOfficialByBookIdAndWord(@Param("bookId") Long bookId,
                                     @Param("word") String word);

    @Select("""
        SELECT id, book_id AS bookId, word, phonetic, meaning,
               memory_tip AS memoryTip,
               example_text AS exampleText,
               translation_text AS translationText,
               answer, difficulty,
               created_at AS createdAt,
               updated_at AS updatedAt
        FROM words
        WHERE book_id = #{bookId}
          AND (difficulty IS NULL OR difficulty <> 'API')
        ORDER BY id
    """)
    List<Word> findByBookId(Long bookId);

    @Select("""
    SELECT id, book_id AS bookId, word, phonetic, meaning,
           memory_tip AS memoryTip,
           example_text AS exampleText,
           translation_text AS translationText,
           answer, difficulty,
           created_at AS createdAt,
           updated_at AS updatedAt
    FROM words
    WHERE book_id = #{bookId}
      AND (difficulty IS NULL OR difficulty <> 'API')
    ORDER BY RAND()
    LIMIT 1
""")
    Word findRandomByBookId(Long bookId);

    @Select("""
    SELECT id, word, phonetic, meaning,
           example_text AS exampleText,
           'local cache' AS source
    FROM words
    WHERE word = #{keyword}
      AND (difficulty IS NULL OR difficulty <> 'API')
    LIMIT 1
""")
    WordSearchResponse findSearchCache(String keyword);

    @Insert("""
    INSERT INTO words(book_id, word, phonetic, meaning, memory_tip, example_text, translation_text, answer, difficulty)
    VALUES(#{bookId}, #{word}, #{phonetic}, #{meaning}, #{memoryTip}, #{exampleText}, '', #{meaning}, 'API')
""")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insertFromApi(Word word);

    @Insert("""
        INSERT INTO words(book_id, word, phonetic, meaning, memory_tip, example_text, translation_text, answer, difficulty)
        VALUES(#{bookId}, #{word}, #{phonetic}, #{meaning}, #{memoryTip}, #{exampleText}, #{translationText}, #{answer}, #{difficulty})
    """)
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insertExternalPracticeWord(Word word);

}
