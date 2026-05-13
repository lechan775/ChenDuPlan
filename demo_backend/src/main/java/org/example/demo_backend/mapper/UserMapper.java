package org.example.demo_backend.mapper;

import org.apache.ibatis.annotations.*;
import org.example.demo_backend.entity.User;

@Mapper
public interface UserMapper {
    @Select("""
        SELECT id, account, password_hash AS passwordHash, nickname,
               daily_target AS dailyTarget, signature,
               selected_book_id AS selectedBookId,
               total_learned_words AS totalLearnedWords,
               streak_days AS streakDays,
               accuracy_rate AS accuracyRate,
               review_due AS reviewDue,
               created_at AS createdAt,
               updated_at AS updatedAt
        FROM users
        WHERE account = #{account}
    """)
    User findByAccount(String account);

    @Insert("""
        INSERT INTO users(account, password_hash, nickname, daily_target, signature, selected_book_id)
        VALUES(#{account}, #{passwordHash}, #{nickname}, #{dailyTarget}, #{signature}, #{selectedBookId})
    """)
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(User user);

    @Select("""
    SELECT id, account, password_hash AS passwordHash, nickname,
           daily_target AS dailyTarget, signature,
           selected_book_id AS selectedBookId,
           total_learned_words AS totalLearnedWords,
           streak_days AS streakDays,
           accuracy_rate AS accuracyRate,
           review_due AS reviewDue,
           created_at AS createdAt,
           updated_at AS updatedAt
    FROM users
    WHERE id = #{id}
""")
    User findById(Long id);

    @Update("""
    UPDATE users
    SET nickname = #{nickname},
        daily_target = #{dailyTarget},
        signature = #{signature},
        selected_book_id = #{selectedBookId}
    WHERE id = #{id}
""")
    int updateProfile(User user);

}
