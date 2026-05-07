CREATE TABLE bmi_records (
    id                  BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id             BIGINT UNSIGNED NOT NULL,
    height_cm           DECIMAL(5,1)    NOT NULL,
    weight_kg           DECIMAL(5,1)    NOT NULL,
    bmi                 DECIMAL(4,1)    NOT NULL,
    bmi_category        ENUM('UNDERWEIGHT','NORMAL','OVERWEIGHT','OBESE') NOT NULL,
    age_at_measurement  TINYINT UNSIGNED NOT NULL,
    ideal_weight_kg     DECIMAL(5,1)    NOT NULL  COMMENT '나이 기준 이상 체중 (BMI 22.0 기준)',
    weight_diff_kg      DECIMAL(5,1)    NOT NULL  COMMENT '양수=증량 필요, 음수=감량 필요',
    measured_at         DATETIME        NOT NULL DEFAULT NOW(),
    created_at          DATETIME        NOT NULL DEFAULT NOW(),
    updated_at          DATETIME        NOT NULL DEFAULT NOW() ON UPDATE NOW(),
    deleted_at          DATETIME        NULL,

    INDEX idx_bmi_records_user (user_id),
    INDEX idx_bmi_records_measured (measured_at),
    CONSTRAINT fk_bmi_records_user FOREIGN KEY (user_id) REFERENCES users(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
