package com.fitzip.server.domain.bmi.service;

import com.fitzip.server.common.exception.BusinessException;
import com.fitzip.server.common.exception.ErrorCode;
import com.fitzip.server.domain.auth.entity.User;
import com.fitzip.server.domain.auth.repository.UserRepository;
import com.fitzip.server.domain.bmi.dto.BmiRequest;
import com.fitzip.server.domain.bmi.dto.BmiResponse;
import com.fitzip.server.domain.bmi.entity.BmiRecord;
import com.fitzip.server.domain.bmi.repository.BmiRecordRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.MathContext;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.Period;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class BmiService {

    private final BmiRecordRepository bmiRecordRepository;
    private final UserRepository userRepository;

    // 아시아 기준 BMI 범위
    private static final BigDecimal IDEAL_BMI = new BigDecimal("22.0");
    private static final BigDecimal NORMAL_MIN = new BigDecimal("18.5");
    private static final BigDecimal NORMAL_MAX = new BigDecimal("22.9");
    private static final BigDecimal OVERWEIGHT_MAX = new BigDecimal("24.9");

    @Transactional
    public BmiResponse calculate(Long userId, BmiRequest request) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new BusinessException(ErrorCode.USER_NOT_FOUND));

        int age = Period.between(user.getBirthDate(), LocalDate.now()).getYears();

        BigDecimal heightM = request.getHeightCm().divide(BigDecimal.valueOf(100), 4, RoundingMode.HALF_UP);
        BigDecimal bmi = request.getWeightKg()
                .divide(heightM.multiply(heightM), 1, RoundingMode.HALF_UP);

        BmiRecord.BmiCategory category = categorize(bmi);

        // 나이대별 이상 BMI: 65세 이상은 약간 높은 기준 적용
        BigDecimal targetBmi = age >= 65 ? new BigDecimal("23.0") : IDEAL_BMI;
        BigDecimal idealWeight = targetBmi.multiply(heightM.multiply(heightM))
                .setScale(1, RoundingMode.HALF_UP);
        BigDecimal weightDiff = idealWeight.subtract(request.getWeightKg())
                .setScale(1, RoundingMode.HALF_UP);

        BmiRecord record = BmiRecord.builder()
                .userId(userId)
                .heightCm(request.getHeightCm())
                .weightKg(request.getWeightKg())
                .bmi(bmi)
                .bmiCategory(category)
                .ageAtMeasurement(age)
                .idealWeightKg(idealWeight)
                .weightDiffKg(weightDiff)
                .build();

        return BmiResponse.from(bmiRecordRepository.save(record));
    }

    public Page<BmiResponse> getHistory(Long userId, Pageable pageable) {
        return bmiRecordRepository
                .findByUserIdAndDeletedAtIsNullOrderByMeasuredAtDesc(userId, pageable)
                .map(BmiResponse::from);
    }

    public BmiResponse getLatest(Long userId) {
        return bmiRecordRepository
                .findTopByUserIdAndDeletedAtIsNullOrderByMeasuredAtDesc(userId)
                .map(BmiResponse::from)
                .orElseThrow(() -> new BusinessException(ErrorCode.BMI_RECORD_NOT_FOUND));
    }

    private BmiRecord.BmiCategory categorize(BigDecimal bmi) {
        if (bmi.compareTo(NORMAL_MIN) < 0) return BmiRecord.BmiCategory.UNDERWEIGHT;
        if (bmi.compareTo(NORMAL_MAX) <= 0) return BmiRecord.BmiCategory.NORMAL;
        if (bmi.compareTo(OVERWEIGHT_MAX) <= 0) return BmiRecord.BmiCategory.OVERWEIGHT;
        return BmiRecord.BmiCategory.OBESE;
    }
}
