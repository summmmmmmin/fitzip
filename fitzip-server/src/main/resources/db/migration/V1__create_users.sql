CREATE TABLE users (
    id          BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    email       VARCHAR(255)    NOT NULL,
    password_hash VARCHAR(255)  NULL,
    provider    ENUM('LOCAL','KAKAO','GOOGLE') NOT NULL DEFAULT 'LOCAL',
    provider_id VARCHAR(255)    NULL,
    name        VARCHAR(100)    NOT NULL,
    gender      ENUM('MALE','FEMALE') NOT NULL,
    birth_date  DATE            NOT NULL,
    role        ENUM('USER','ADMIN') NOT NULL DEFAULT 'USER',
    created_at  DATETIME        NOT NULL DEFAULT NOW(),
    updated_at  DATETIME        NOT NULL DEFAULT NOW() ON UPDATE NOW(),
    deleted_at  DATETIME        NULL,

    UNIQUE KEY uq_users_email (email),
    INDEX idx_users_provider (provider, provider_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
