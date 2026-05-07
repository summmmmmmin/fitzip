CREATE TABLE body_analysis_results (
    id                  BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id             BIGINT UNSIGNED NOT NULL,
    image_url           VARCHAR(500)    NOT NULL,
    body_type           ENUM('STRAIGHT','NATURAL','WAVE') NULL,
    confidence_score    DECIMAL(4,3)    NULL,
    landmarks_json      JSON            NULL          COMMENT 'MediaPipe 랜드마크 원본',
    shoulder_width      DECIMAL(6,4)    NULL,
    hip_width           DECIMAL(6,4)    NULL,
    waist_ratio         DECIMAL(6,4)    NULL,
    shoulder_hip_ratio  DECIMAL(6,4)    NULL,
    status              ENUM('PENDING','PROCESSING','COMPLETED','FAILED') NOT NULL DEFAULT 'PENDING',
    error_message       TEXT            NULL,
    analyzed_at         DATETIME        NULL,
    created_at          DATETIME        NOT NULL DEFAULT NOW(),
    updated_at          DATETIME        NOT NULL DEFAULT NOW() ON UPDATE NOW(),
    deleted_at          DATETIME        NULL,

    INDEX idx_body_analysis_user (user_id),
    INDEX idx_body_analysis_status (status),
    CONSTRAINT fk_body_analysis_user FOREIGN KEY (user_id) REFERENCES users(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
