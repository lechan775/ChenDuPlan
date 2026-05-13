package org.example.demo_backend.controller;

import org.example.demo_backend.common.Result;
import org.example.demo_backend.entity.StudyRecord;
import org.example.demo_backend.service.StudyRecordService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
public class StudyRecordController {
    private final StudyRecordService studyRecordService;

    public StudyRecordController(StudyRecordService studyRecordService) {
        this.studyRecordService = studyRecordService;
    }

    @GetMapping("/api/study-records")
    public Result<List<StudyRecord>> listStudyRecords(@RequestParam Long userId) {
        return Result.success(studyRecordService.findByUserId(userId));
    }
}
