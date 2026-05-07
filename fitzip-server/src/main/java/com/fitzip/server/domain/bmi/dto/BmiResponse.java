package com.fitzip.server.domain.bmi.dto;

import com.fitzip.server.domain.bmi.entity.BmiRecord;
import lombok.Builder;
import lombok.Getter;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Getter
@Builder
public class BmiResponse {

    private Long id;
    private BigDecimal heightCm;
    private BigDecimal weightKg;
    private BigDecimal bmi;
    private String bmiCategory;
    private String bmiCategoryLabel;
    private Integer age;
    private BigDecimal idealWeightKg;
    private BigDecimal weightDiffKg;
    private String weightAdvice;
    private LocalDateTime measuredAt;

    public static BmiResponse from(BmiRecord record) {
        String label = switch (record.getBmiCategory()) {
            case UNDERWEIGHT -> "저체중";
            case NORMAL -> "정상";
            case OVERWEIGHT -> "과체중";
            case OBESE -> "비만";
        };

        BigDecimal diff = record.getWeightDiffKg();
        String advice;
        if (diff.compareTo(BigDecimal.ZERO) > 0) {
            advice = String.format("정상 체중 유지를 위해 %.1fkg 증량이 필요합니다.", diff);
        } else if (diff.compareTo(BigDecimal.ZERO) < 0) {
            advice = String.format("정상 체중 유지를 위해 %.1fkg 감량이 필요합니다.", diff.abs());
        } else {
            advice = "현재 이상적인 체중입니다!";
        }

        return BmiResponse.builder()
                .id(record.getId())
                .heightCm(record.getHeightCm())
                .weightKg(record.getWeightKg())
                .bmi(record.getBmi())
                .bmiCategory(record.getBmiCategory().name())
                .bmiCategoryLabel(label)
                .age(record.getAgeAtMeasurement())
                .idealWeightKg(record.getIdealWeightKg())
                .weightDiffKg(diff)
                .weightAdvice(advice)
                .measuredAt(record.getMeasuredAt())
                .build();
    }
}
