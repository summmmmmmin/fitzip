package com.fitzip.server.domain.bmi.repository;

import com.fitzip.server.domain.bmi.entity.BmiRecord;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface BmiRecordRepository extends JpaRepository<BmiRecord, Long> {
    Page<BmiRecord> findByUserIdAndDeletedAtIsNullOrderByMeasuredAtDesc(Long userId, Pageable pageable);
    Optional<BmiRecord> findTopByUserIdAndDeletedAtIsNullOrderByMeasuredAtDesc(Long userId);
}
