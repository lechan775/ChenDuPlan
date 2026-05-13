package org.example.demo_backend.service;

import org.example.demo_backend.common.Result;
import org.example.demo_backend.dto.StudySubmitRequest;
import org.example.demo_backend.mapper.StudyMapper;
import org.springframework.stereotype.Service;

@Service
public class StudyService {
    private final StudyMapper studyMapper;

    public StudyService(StudyMapper studyMapper) {
        this.studyMapper = studyMapper;
    }

    public Result<String> submit(StudySubmitRequest request) {
        Integer correctRate = request.getIsCorrect() ? 100 : 0;

        studyMapper.insertStudyRecord(request.getUserId(), request.getBookTitle(), correctRate);

        if (!request.getIsCorrect()) {
            studyMapper.insertWrongWord(request);
        }

        studyMapper.updateUserStats(request.getUserId(), correctRate, request.getIsCorrect());

        if (request.getWordId() != null) {
            studyMapper.ensureUserBook(request.getUserId(), request.getWordId());
            studyMapper.updateUserBookProgress(request.getUserId(), request.getWordId());
        }

        return Result.success("submit success");
    }
}
