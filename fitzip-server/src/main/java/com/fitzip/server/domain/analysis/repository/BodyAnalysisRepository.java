package com.fitzip.server.domain.analysis.repository;

import com.fitzip.server.domain.analysis.entity.BodyAnalysisResult;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface BodyAnalysisRepository extends JpaRepository<BodyAnalysisResult, Long> {
    Page<BodyAnalysisResult> findByUserIdAndDeletedAtIsNullOrderByCreatedAtDesc(Long userId, Pageable pageable);
    Optional<BodyAnalysisResult> findTopByUserIdAndDeletedAtIsNullOrderByCreatedAtDesc(Long userId);
}
