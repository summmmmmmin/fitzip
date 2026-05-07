package com.fitzip.server.domain.analysis.controller;

import com.fitzip.server.common.response.ApiResponse;
import com.fitzip.server.domain.analysis.dto.AnalysisResponse;
import com.fitzip.server.domain.analysis.service.AnalysisService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

@Tag(name = "Analysis", description = "체형 분석")
@RestController
@RequestMapping("/api/v1/analysis")
@RequiredArgsConstructor
public class AnalysisController {

    private final AnalysisService analysisService;

    @Operation(summary = "체형 분석 요청 (이미지 업로드)")
    @PostMapping(consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<AnalysisResponse> analyze(
            @AuthenticationPrincipal Long userId,
            @RequestPart("image") MultipartFile image) {
        return ApiResponse.ok(analysisService.analyze(userId, image));
    }

    @Operation(summary = "분석 결과 단건 조회")
    @GetMapping("/{id}")
    public ApiResponse<AnalysisResponse> getResult(
            @AuthenticationPrincipal Long userId,
            @PathVariable Long id) {
        return ApiResponse.ok(analysisService.getResult(userId, id));
    }

    @Operation(summary = "분석 이력 조회 (페이징)")
    @GetMapping("/history")
    public ApiResponse<Page<AnalysisResponse>> getHistory(
            @AuthenticationPrincipal Long userId,
            @PageableDefault(size = 10) Pageable pageable) {
        return ApiResponse.ok(analysisService.getHistory(userId, pageable));
    }
}
