CREATE TABLE body_type_recommendations (
    id                      BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    body_type               ENUM('STRAIGHT','NATURAL','WAVE') NOT NULL,
    gender                  ENUM('MALE','FEMALE') NOT NULL,
    category                ENUM('TOP','BOTTOM','OUTER','DRESS','SHOES','ACCESSORY') NOT NULL,
    item_name               VARCHAR(200)    NOT NULL,
    recommendation_reason   TEXT            NOT NULL,
    avoid_items             TEXT            NULL,
    image_url               VARCHAR(500)    NULL,
    priority                TINYINT UNSIGNED NOT NULL DEFAULT 0,
    created_at              DATETIME        NOT NULL DEFAULT NOW(),
    updated_at              DATETIME        NOT NULL DEFAULT NOW() ON UPDATE NOW(),
    deleted_at              DATETIME        NULL,

    INDEX idx_recommendations_type_gender (body_type, gender),
    INDEX idx_recommendations_priority (priority)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
