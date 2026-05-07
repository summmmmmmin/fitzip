package com.fitzip.server.domain.bmi.dto;

import jakarta.validation.constraints.*;
import lombok.Getter;

import java.math.BigDecimal;

@Getter
public class BmiRequest {

    @NotNull(message = "키를 입력해주세요.")
    @DecimalMin(value = "100.0", message = "키는 100cm 이상이어야 합니다.")
    @DecimalMax(value = "250.0", message = "키는 250cm 이하이어야 합니다.")
    private BigDecimal heightCm;

    @NotNull(message = "몸무게를 입력해주세요.")
    @DecimalMin(value = "20.0", message = "몸무게는 20kg 이상이어야 합니다.")
    @DecimalMax(value = "300.0", message = "몸무게는 300kg 이하이어야 합니다.")
    private BigDecimal weightKg;
}
