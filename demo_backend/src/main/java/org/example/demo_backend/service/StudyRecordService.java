package org.example.demo_backend.service;

import org.example.demo_backend.entity.StudyRecord;
import org.example.demo_backend.mapper.StudyRecordMapper;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class StudyRecordService {
    private final StudyRecordMapper studyRecordMapper;

    public StudyRecordService(StudyRecordMapper studyRecordMapper) {
        this.studyRecordMapper = studyRecordMapper;
    }

    public List<StudyRecord> findByUserId(Long userId) {
        return studyRecordMapper.findByUserId(userId);
    }
}
