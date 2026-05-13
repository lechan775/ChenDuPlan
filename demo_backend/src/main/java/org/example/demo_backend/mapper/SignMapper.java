package org.example.demo_backend.mapper;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

@Mapper
public interface SignMapper {
    @Select("""
        SELECT COUNT(*)
        FROM sign_records
        WHERE user_id = #{userId}
          AND sign_date = CURDATE()
    """)
    int countTodayByUserId(@Param("userId") Long userId);

    @Insert("""
        INSERT INTO sign_records(user_id, sign_date)
        VALUES(#{userId}, CURDATE())
    """)
    int insertToday(@Param("userId") Long userId);
}
