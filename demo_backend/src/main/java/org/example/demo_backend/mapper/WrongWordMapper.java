package org.example.demo_backend.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.example.demo_backend.entity.WrongWord;
import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Param;


import java.util.List;

@Mapper
public interface WrongWordMapper {
    @Select("""
        SELECT id, user_id AS userId,
               word_id AS wordId,
               word, meaning,
               book_title AS bookTitle,
               wrong_count AS wrongCount,
               last_wrong_at AS lastWrongAt,
               sentence_text AS sentenceText,
               reason_text AS reasonText,
               created_at AS createdAt,
               updated_at AS updatedAt
        FROM wrong_words
        WHERE user_id = #{userId}
        ORDER BY last_wrong_at DESC
    """)
    List<WrongWord> findByUserId(Long userId);

    @Delete("DELETE FROM wrong_words WHERE id = #{id} AND user_id = #{userId}")
    int deleteById(@Param("id") Long id, @Param("userId") Long userId);

}
