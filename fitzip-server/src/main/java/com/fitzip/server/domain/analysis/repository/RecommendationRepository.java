package com.fitzip.server.domain.analysis.repository;

import com.fitzip.server.domain.analysis.entity.BodyAnalysisResult;
import com.fitzip.server.domain.analysis.entity.BodyTypeRecommendation;
import com.fitzip.server.domain.auth.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface RecommendationRepository extends JpaRepository<BodyTypeRecommendation, Long> {
    List<BodyTypeRecommendation> findByBodyTypeAndGenderAndDeletedAtIsNullOrderByPriorityAsc(
            BodyAnalysisResult.BodyType bodyType, User.Gender gender);
}
