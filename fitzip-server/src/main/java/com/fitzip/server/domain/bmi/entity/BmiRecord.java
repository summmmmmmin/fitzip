package com.fitzip.server.domain.bmi.entity;

import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "bmi_records")
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class BmiRecord {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "user_id", nullable = false)
    private Long userId;

    @Column(name = "height_cm", nullable = false, precision = 5, scale = 1)
    private BigDecimal heightCm;

    @Column(name = "weight_kg", nullable = false, precision = 5, scale = 1)
    private BigDecimal weightKg;

    @Column(nullable = false, precision = 4, scale = 1)
    private BigDecimal bmi;

    @Enumerated(EnumType.STRING)
    @Column(name = "bmi_category", nullable = false)
    private BmiCategory bmiCategory;

    @Column(name = "age_at_measurement", nullable = false)
    private Integer ageAtMeasurement;

    @Column(name = "ideal_weight_kg", nullable = false, precision = 5, scale = 1)
    private BigDecimal idealWeightKg;

    @Column(name = "weight_diff_kg", nullable = false, precision = 5, scale = 1)
    private BigDecimal weightDiffKg;

    @Column(name = "measured_at", nullable = false)
    private LocalDateTime measuredAt;

    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt;

    @Column(name = "deleted_at")
    private LocalDateTime deletedAt;

    @PrePersist
    protected void onCreate() {
        createdAt = updatedAt = LocalDateTime.now();
        if (measuredAt == null) measuredAt = LocalDateTime.now();
    }

    @PreUpdate
    protected void onUpdate() { updatedAt = LocalDateTime.now(); }

    @Builder
    public BmiRecord(Long userId, BigDecimal heightCm, BigDecimal weightKg,
                     BigDecimal bmi, BmiCategory bmiCategory, Integer ageAtMeasurement,
                     BigDecimal idealWeightKg, BigDecimal weightDiffKg) {
        this.userId = userId;
        this.heightCm = heightCm;
        this.weightKg = weightKg;
        this.bmi = bmi;
        this.bmiCategory = bmiCategory;
        this.ageAtMeasurement = ageAtMeasurement;
        this.idealWeightKg = idealWeightKg;
        this.weightDiffKg = weightDiffKg;
    }

    public enum BmiCategory { UNDERWEIGHT, NORMAL, OVERWEIGHT, OBESE }
}
