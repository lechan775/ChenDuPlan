package org.example.demo_backend.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.example.demo_backend.entity.NotebookWord;
import org.apache.ibatis.annotations.Insert;
import org.example.demo_backend.dto.NotebookWordAddRequest;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Delete;




import java.util.List;

@Mapper
public interface NotebookWordMapper {
    @Select("""
        SELECT id, user_id AS userId,
               word_id AS wordId,
               word, meaning,
               book_title AS bookTitle,
               mastery_label AS masteryLabel,
               next_review AS nextReview,
               added_at AS addedAt,
               note_text AS noteText,
               created_at AS createdAt,
               updated_at AS updatedAt
        FROM notebook_words
        WHERE user_id = #{userId}
        ORDER BY added_at DESC
    """)
    List<NotebookWord> findByUserId(Long userId);

    @Select("""
        SELECT COUNT(*)
        FROM notebook_words
        WHERE user_id = #{request.userId}
          AND word = #{request.word}
    """)
    int countByUserIdAndWord(@Param("request") NotebookWordAddRequest request);

    @Insert("""
    INSERT INTO notebook_words(user_id, word_id, word, meaning, book_title, mastery_label, next_review, note_text)
    VALUES(#{request.userId}, #{request.wordId}, #{request.word}, #{request.meaning}, #{request.bookTitle}, #{request.masteryLabel}, #{request.nextReview}, #{request.noteText})
""")
    int insert(@Param("request") NotebookWordAddRequest request);

    @Delete("DELETE FROM notebook_words WHERE id = #{id} AND user_id = #{userId}")
    int deleteById(@Param("id") Long id, @Param("userId") Long userId);



}
