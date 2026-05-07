package com.fitzip.server.domain.analysis.entity;

import com.fitzip.server.domain.auth.entity.User;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "body_type_recommendations")
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class BodyTypeRecommendation {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Enumerated(EnumType.STRING)
    @Column(name = "body_type", nullable = false)
    private BodyAnalysisResult.BodyType bodyType;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private User.Gender gender;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private StyleCategory category;

    @Column(name = "item_name", nullable = false)
    private String itemName;

    @Column(name = "recommendation_reason", nullable = false, columnDefinition = "TEXT")
    private String recommendationReason;

    @Column(name = "avoid_items", columnDefinition = "TEXT")
    private String avoidItems;

    @Column(name = "image_url")
    private String imageUrl;

    @Column(nullable = false)
    private Integer priority;

    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt;

    @Column(name = "deleted_at")
    private LocalDateTime deletedAt;

    public enum StyleCategory { TOP, BOTTOM, OUTER, DRESS, SHOES, ACCESSORY }
}
