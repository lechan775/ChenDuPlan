package org.example.demo_backend.controller;

import jakarta.validation.Valid;
import org.example.demo_backend.common.Result;
import org.example.demo_backend.dto.StudySubmitRequest;
import org.example.demo_backend.service.StudyService;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/study")
public class StudyController {
    private final StudyService studyService;

    public StudyController(StudyService studyService) {
        this.studyService = studyService;
    }

    @PostMapping("/submit")
    public Result<String> submit(@Valid @RequestBody StudySubmitRequest request) {
        return studyService.submit(request);
    }
}
