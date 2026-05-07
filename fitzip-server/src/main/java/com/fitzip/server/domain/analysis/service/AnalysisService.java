package com.fitzip.server.domain.analysis.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fitzip.server.common.exception.BusinessException;
import com.fitzip.server.common.exception.ErrorCode;
import com.fitzip.server.domain.analysis.dto.AnalysisResponse;
import com.fitzip.server.domain.analysis.entity.BodyAnalysisResult;
import com.fitzip.server.domain.analysis.entity.BodyTypeRecommendation;
import com.fitzip.server.domain.analysis.repository.BodyAnalysisRepository;
import com.fitzip.server.domain.analysis.repository.RecommendationRepository;
import com.fitzip.server.domain.auth.entity.User;
import com.fitzip.server.domain.auth.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.MediaType;
import org.springframework.http.client.MultipartBodyBuilder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.reactive.function.BodyInserters;
import org.springframework.web.reactive.function.client.WebClient;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class AnalysisService {

    private final BodyAnalysisRepository analysisRepository;
    private final RecommendationRepository recommendationRepository;
    private final UserRepository userRepository;
    private final WebClient aiWebClient;
    private final ObjectMapper objectMapper;

    @Transactional
    public AnalysisResponse analyze(Long userId, MultipartFile image) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new BusinessException(ErrorCode.USER_NOT_FOUND));

        // 임시 이미지 URL (실제 배포 시 S3 업로드로 교체)
        String imageUrl = "uploads/" + image.getOriginalFilename();

        BodyAnalysisResult result = BodyAnalysisResult.builder()
                .userId(userId)
                .imageUrl(imageUrl)
                .build();
        analysisRepository.save(result);

        try {
            Map<?, ?> aiResult = callAiService(image);

            String bodyTypeStr = (String) aiResult.get("body_type");
            BodyAnalysisResult.BodyType bodyType = BodyAnalysisResult.BodyType.valueOf(bodyTypeStr);
            double confidence = ((Number) aiResult.get("confidence")).doubleValue();
            double shoulderWidth = ((Number) aiResult.get("shoulder_width")).doubleValue();
            double hipWidth = ((Number) aiResult.get("hip_width")).doubleValue();
            double waistRatio = ((Number) aiResult.get("waist_ratio")).doubleValue();
            double shoulderHipRatio = ((Number) aiResult.get("shoulder_hip_ratio")).doubleValue();
            String landmarksJson = objectMapper.writeValueAsString(aiResult.get("landmarks"));

            result.complete(
                    bodyType,
                    BigDecimal.valueOf(confidence),
                    landmarksJson,
                    BigDecimal.valueOf(shoulderWidth),
                    BigDecimal.valueOf(hipWidth),
                    BigDecimal.valueOf(waistRatio),
                    BigDecimal.valueOf(shoulderHipRatio)
            );

        } catch (BusinessException e) {
            result.fail(e.getMessage());
            throw e;
        } catch (Exception e) {
            log.error("AI 분석 실패 - resultId={}", result.getId(), e);
            result.fail(e.getMessage());
            throw new BusinessException(ErrorCode.ANALYSIS_FAILED);
        }

        List<BodyTypeRecommendation> recommendations = recommendationRepository
                .findByBodyTypeAndGenderAndDeletedAtIsNullOrderByPriorityAsc(result.getBodyType(), user.getGender());

        return AnalysisResponse.from(result, recommendations);
    }

    public AnalysisResponse getResult(Long userId, Long analysisId) {
        BodyAnalysisResult result = analysisRepository.findById(analysisId)
                .orElseThrow(() -> new BusinessException(ErrorCode.ANALYSIS_NOT_FOUND));

        if (!result.getUserId().equals(userId)) {
            throw new BusinessException(ErrorCode.FORBIDDEN);
        }

        User user = userRepository.findById(userId)
                .orElseThrow(() -> new BusinessException(ErrorCode.USER_NOT_FOUND));

        List<BodyTypeRecommendation> recommendations = result.getBodyType() == null
                ? List.of()
                : recommendationRepository.findByBodyTypeAndGenderAndDeletedAtIsNullOrderByPriorityAsc(
                        result.getBodyType(), user.getGender());

        return AnalysisResponse.from(result, recommendations);
    }

    public Page<AnalysisResponse> getHistory(Long userId, Pageable pageable) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new BusinessException(ErrorCode.USER_NOT_FOUND));

        return analysisRepository
                .findByUserIdAndDeletedAtIsNullOrderByCreatedAtDesc(userId, pageable)
                .map(r -> {
                    List<BodyTypeRecommendation> recs = r.getBodyType() == null ? List.of()
                            : recommendationRepository.findByBodyTypeAndGenderAndDeletedAtIsNullOrderByPriorityAsc(
                                    r.getBodyType(), user.getGender());
                    return AnalysisResponse.from(r, recs);
                });
    }

    @SuppressWarnings("unchecked")
    private Map<?, ?> callAiService(MultipartFile image) {
        try {
            MultipartBodyBuilder builder = new MultipartBodyBuilder();
            builder.part("file", new ByteArrayResource(image.getBytes()) {
                @Override
                public String getFilename() { return image.getOriginalFilename(); }
            }).contentType(MediaType.parseMediaType(
                    image.getContentType() != null ? image.getContentType() : "image/jpeg"));

            return aiWebClient.post()
                    .uri("/analysis/body-type")
                    .contentType(MediaType.MULTIPART_FORM_DATA)
                    .body(BodyInserters.fromMultipartData(builder.build()))
                    .retrieve()
                    .onStatus(status -> status.value() == 422,
                            res -> res.bodyToMono(String.class)
                                    .map(body -> new BusinessException(ErrorCode.BODY_NOT_DETECTED)))
                    .bodyToMono(Map.class)
                    .block();
        } catch (BusinessException e) {
            throw e;
        } catch (Exception e) {
            throw new BusinessException(ErrorCode.ANALYSIS_FAILED);
        }
    }
}
