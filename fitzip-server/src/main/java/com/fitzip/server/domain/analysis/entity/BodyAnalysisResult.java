package com.fitzip.server.domain.analysis.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "body_analysis_results")
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class BodyAnalysisResult {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "user_id", nullable = false)
    private Long userId;

    @Column(name = "image_url", nullable = false)
    private String imageUrl;

    @Enumerated(EnumType.STRING)
    @Column(name = "body_type")
    private BodyType bodyType;

    @Column(name = "confidence_score", precision = 4, scale = 3)
    private BigDecimal confidenceScore;

    @JdbcTypeCode(SqlTypes.JSON)
    @Column(name = "landmarks_json", columnDefinition = "json")
    private String landmarksJson;

    @Column(name = "shoulder_width", precision = 6, scale = 4)
    private BigDecimal shoulderWidth;

    @Column(name = "hip_width", precision = 6, scale = 4)
    private BigDecimal hipWidth;

    @Column(name = "waist_ratio", precision = 6, scale = 4)
    private BigDecimal waistRatio;

    @Column(name = "shoulder_hip_ratio", precision = 6, scale = 4)
    private BigDecimal shoulderHipRatio;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private AnalysisStatus status;

    @Column(name = "error_message", columnDefinition = "TEXT")
    private String errorMessage;

    @Column(name = "analyzed_at")
    private LocalDateTime analyzedAt;

    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt;

    @Column(name = "deleted_at")
    private LocalDateTime deletedAt;

    @PrePersist
    protected void onCreate() { createdAt = updatedAt = LocalDateTime.now(); }

    @PreUpdate
    protected void onUpdate() { updatedAt = LocalDateTime.now(); }

    @Builder
    public BodyAnalysisResult(Long userId, String imageUrl) {
        this.userId = userId;
        this.imageUrl = imageUrl;
        this.status = AnalysisStatus.PENDING;
    }

    public void complete(BodyType bodyType, BigDecimal confidence, String landmarksJson,
                         BigDecimal shoulderWidth, BigDecimal hipWidth,
                         BigDecimal waistRatio, BigDecimal shoulderHipRatio) {
        this.bodyType = bodyType;
        this.confidenceScore = confidence;
        this.landmarksJson = landmarksJson;
        this.shoulderWidth = shoulderWidth;
        this.hipWidth = hipWidth;
        this.waistRatio = waistRatio;
        this.shoulderHipRatio = shoulderHipRatio;
        this.status = AnalysisStatus.COMPLETED;
        this.analyzedAt = LocalDateTime.now();
    }

    public void fail(String errorMessage) {
        this.status = AnalysisStatus.FAILED;
        this.errorMessage = errorMessage;
    }

    public enum BodyType { STRAIGHT, NATURAL, WAVE }
    public enum AnalysisStatus { PENDING, PROCESSING, COMPLETED, FAILED }
}
