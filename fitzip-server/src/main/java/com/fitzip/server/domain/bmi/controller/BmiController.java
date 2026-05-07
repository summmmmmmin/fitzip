package com.fitzip.server.domain.bmi.controller;

import com.fitzip.server.common.response.ApiResponse;
import com.fitzip.server.domain.bmi.dto.BmiRequest;
import com.fitzip.server.domain.bmi.dto.BmiResponse;
import com.fitzip.server.domain.bmi.service.BmiService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

@Tag(name = "BMI", description = "BMI 계산 및 이력 조회")
@RestController
@RequestMapping("/api/v1/bmi")
@RequiredArgsConstructor
public class BmiController {

    private final BmiService bmiService;

    @Operation(summary = "BMI 계산 및 저장")
    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<BmiResponse> calculate(
            @AuthenticationPrincipal Long userId,
            @Valid @RequestBody BmiRequest request) {
        return ApiResponse.ok(bmiService.calculate(userId, request));
    }

    @Operation(summary = "최근 BMI 조회")
    @GetMapping("/latest")
    public ApiResponse<BmiResponse> getLatest(@AuthenticationPrincipal Long userId) {
        return ApiResponse.ok(bmiService.getLatest(userId));
    }

    @Operation(summary = "BMI 이력 조회 (페이징)")
    @GetMapping("/history")
    public ApiResponse<Page<BmiResponse>> getHistory(
            @AuthenticationPrincipal Long userId,
            @PageableDefault(size = 10) Pageable pageable) {
        return ApiResponse.ok(bmiService.getHistory(userId, pageable));
    }
}
