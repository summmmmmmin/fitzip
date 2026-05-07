package com.fitzip.server.common.exception;

import lombok.Getter;
import org.springframework.http.HttpStatus;

@Getter
public enum ErrorCode {

    // Common
    INVALID_INPUT("C001", "입력값이 올바르지 않습니다.", HttpStatus.BAD_REQUEST),
    INTERNAL_ERROR("C002", "서버 내부 오류가 발생했습니다.", HttpStatus.INTERNAL_SERVER_ERROR),

    // Auth
    EMAIL_ALREADY_EXISTS("A001", "이미 사용 중인 이메일입니다.", HttpStatus.CONFLICT),
    INVALID_CREDENTIALS("A002", "이메일 또는 비밀번호가 올바르지 않습니다.", HttpStatus.UNAUTHORIZED),
    INVALID_TOKEN("A003", "유효하지 않은 토큰입니다.", HttpStatus.UNAUTHORIZED),
    EXPIRED_TOKEN("A004", "만료된 토큰입니다.", HttpStatus.UNAUTHORIZED),
    UNAUTHORIZED("A005", "인증이 필요합니다.", HttpStatus.UNAUTHORIZED),
    FORBIDDEN("A006", "접근 권한이 없습니다.", HttpStatus.FORBIDDEN),

    // User
    USER_NOT_FOUND("U001", "사용자를 찾을 수 없습니다.", HttpStatus.NOT_FOUND),

    // BMI
    BMI_RECORD_NOT_FOUND("B001", "BMI 기록을 찾을 수 없습니다.", HttpStatus.NOT_FOUND),

    // Analysis
    ANALYSIS_NOT_FOUND("AN001", "분석 결과를 찾을 수 없습니다.", HttpStatus.NOT_FOUND),
    ANALYSIS_FAILED("AN002", "체형 분석에 실패했습니다.", HttpStatus.INTERNAL_SERVER_ERROR),
    BODY_NOT_DETECTED("AN003", "인체를 감지하지 못했습니다. 전신이 보이는 사진을 사용해주세요.", HttpStatus.UNPROCESSABLE_ENTITY);

    private final String code;
    private final String message;
    private final HttpStatus status;

    ErrorCode(String code, String message, HttpStatus status) {
        this.code = code;
        this.message = message;
        this.status = status;
    }
}
