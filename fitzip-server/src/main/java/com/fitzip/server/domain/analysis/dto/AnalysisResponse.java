package com.fitzip.server.domain.analysis.dto;

import com.fitzip.server.domain.analysis.entity.BodyAnalysisResult;
import com.fitzip.server.domain.analysis.entity.BodyTypeRecommendation;
import lombok.Builder;
import lombok.Getter;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Getter
@Builder
public class AnalysisResponse {

    private Long id;
    private String status;
    private String bodyType;
    private String bodyTypeLabel;
    private String bodyTypeDescription;
    private BigDecimal confidenceScore;
    private BigDecimal shoulderHipRatio;
    private List<RecommendationDto> recommendations;
    private LocalDateTime analyzedAt;

    public static AnalysisResponse from(BodyAnalysisResult result, List<BodyTypeRecommendation> recs) {
        String label = result.getBodyType() == null ? null : switch (result.getBodyType()) {
            case STRAIGHT -> "스트레이트";
            case NATURAL -> "내추럴";
            case WAVE -> "웨이브";
        };

        String desc = result.getBodyType() == null ? null : switch (result.getBodyType()) {
            case STRAIGHT -> "어깨와 힙의 너비가 비슷하고 직선적인 실루엣을 가진 체형입니다.";
            case NATURAL -> "어깨가 살짝 넓고 균형잡힌 비율을 가진 체형입니다.";
            case WAVE -> "허리 굴곡이 뚜렷하고 곡선미가 강조되는 체형입니다.";
        };

        return AnalysisResponse.builder()
                .id(result.getId())
                .status(result.getStatus().name())
                .bodyType(result.getBodyType() == null ? null : result.getBodyType().name())
                .bodyTypeLabel(label)
                .bodyTypeDescription(desc)
                .confidenceScore(result.getConfidenceScore())
                .shoulderHipRatio(result.getShoulderHipRatio())
                .recommendations(recs.stream().map(RecommendationDto::from).toList())
                .analyzedAt(result.getAnalyzedAt())
                .build();
    }

    @Getter
    @Builder
    public static class RecommendationDto {
        private Long id;
        private String category;
        private String itemName;
        private String reason;
        private String avoidItems;
        private String imageUrl;

        public static RecommendationDto from(BodyTypeRecommendation r) {
            return RecommendationDto.builder()
                    .id(r.getId())
                    .category(r.getCategory().name())
                    .itemName(r.getItemName())
                    .reason(r.getRecommendationReason())
                    .avoidItems(r.getAvoidItems())
                    .imageUrl(r.getImageUrl())
                    .build();
        }
    }
}
