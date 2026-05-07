package com.fitzip.server.domain.auth.dto;

import com.fitzip.server.domain.auth.entity.User;
import jakarta.validation.constraints.*;
import lombok.Getter;

import java.time.LocalDate;

@Getter
public class SignUpRequest {

    @NotBlank(message = "이름을 입력해주세요.")
    @Size(max = 100)
    private String name;

    @NotBlank(message = "이메일을 입력해주세요.")
    @Email(message = "올바른 이메일 형식이 아닙니다.")
    private String email;

    @NotBlank(message = "비밀번호를 입력해주세요.")
    @Size(min = 8, message = "비밀번호는 8자 이상이어야 합니다.")
    private String password;

    @NotNull(message = "성별을 선택해주세요.")
    private User.Gender gender;

    @NotNull(message = "생년월일을 입력해주세요.")
    @Past(message = "올바른 생년월일이 아닙니다.")
    private LocalDate birthDate;
}
