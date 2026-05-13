package org.example.demo_backend.mapper;

import org.apache.ibatis.annotations.*;
import org.example.demo_backend.dto.StudySubmitRequest;

@Mapper
public interface StudyMapper {
    @Insert("""
        INSERT INTO study_records(user_id, study_date, book_title, new_count, review_count, correct_rate, finished_words, duration_minutes)
        VALUES(#{userId}, CURDATE(), #{bookTitle}, 1, 0, #{correctRate}, 1, 1)
    """)
    int insertStudyRecord(@Param("userId") Long userId,
                          @Param("bookTitle") String bookTitle,
                          @Param("correctRate") Integer correctRate);

    @Insert("""
        INSERT INTO wrong_words(user_id, word_id, word, meaning, book_title, wrong_count, sentence_text, reason_text)
        VALUES(#{request.userId}, #{request.wordId}, #{request.word}, #{request.meaning}, #{request.bookTitle}, 1, #{request.sentence}, #{request.reason})
    """)
    int insertWrongWord(@Param("request") StudySubmitRequest request);

    @Update("""
        UPDATE users
        SET total_learned_words = total_learned_words + 1,
            accuracy_rate = #{correctRate},
            review_due = CASE WHEN #{isCorrect} = true THEN review_due ELSE review_due + 1 END
        WHERE id = #{userId}
    """)
    int updateUserStats(@Param("userId") Long userId,
                        @Param("correctRate") Integer correctRate,
                        @Param("isCorrect") Boolean isCorrect);

    @Insert("""
        INSERT IGNORE INTO user_books(user_id, book_id, learned_words, today_new, today_review, progress)
        SELECT #{userId}, book_id, 0, 0, 0, 0
        FROM words
        WHERE id = #{wordId}
          AND (difficulty IS NULL OR difficulty <> 'API')
    """)
    int ensureUserBook(@Param("userId") Long userId,
                       @Param("wordId") Long wordId);

    @Update("""
        UPDATE user_books ub
        JOIN words w ON ub.book_id = w.book_id
        JOIN (
            SELECT book_id, COUNT(*) AS total_words
            FROM words
            WHERE difficulty IS NULL OR difficulty <> 'API'
            GROUP BY book_id
        ) actual_words ON actual_words.book_id = ub.book_id
        SET ub.learned_words = ub.learned_words + 1,
            ub.today_new = ub.today_new + 1,
            ub.progress = LEAST(100, ROUND((ub.learned_words + 1) * 100 / actual_words.total_words))
        WHERE ub.user_id = #{userId}
          AND w.id = #{wordId}
          AND (w.difficulty IS NULL OR w.difficulty <> 'API')
    """)
    int updateUserBookProgress(@Param("userId") Long userId,
                               @Param("wordId") Long wordId);
}
