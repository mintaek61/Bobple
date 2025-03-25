
-- users 테이블 생성
CREATE TABLE users (
    user_idx BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    name VARCHAR(50) NULL,
    birthdate DATE NULL,
    nick_name VARCHAR(50) NULL DEFAULT '',
    profile_image VARCHAR(255) NULL DEFAULT '기본이미지',
    enabled BOOLEAN NOT NULL,
    provider VARCHAR(20) NULL,
    company_id BIGINT NOT NULL,
    report_count INT NOT NULL DEFAULT 0,
    point INT NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- recipe 테이블 생성
CREATE TABLE recipe (
    recipe_idx BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_idx BIGINT NOT NULL,
    title VARCHAR(500) NOT NULL,
    content TEXT NOT NULL,
    category VARCHAR(50) NULL,
    picture VARCHAR(255) NULL,
    likes_count INT NOT NULL DEFAULT 0,
    comments_count INT NOT NULL DEFAULT 0,
    views_count INT NOT NULL DEFAULT 0,
    tag VARCHAR(255) NULL,
    report_count INT NOT NULL DEFAULT 0,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_idx) REFERENCES users(user_idx)
);

-- like_recipe 테이블 생성
CREATE TABLE like_recipe (
    like_recipe_idx BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_idx BIGINT NOT NULL,
    recipe_idx BIGINT NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_idx) REFERENCES users(user_idx),
    FOREIGN KEY (recipe_idx) REFERENCES recipe(recipe_idx)
);

-- recipe_comments 테이블 생성
CREATE TABLE recipe_comments (
    recipe_comment_idx BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_idx BIGINT NOT NULL,
    recipe_idx BIGINT NULL,
    recipe_content TEXT NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_idx) REFERENCES users(user_idx),
    INDEX (recipe_idx),
    FOREIGN KEY (recipe_idx) REFERENCES recipe(recipe_idx)
);

-- chat_rooms 테이블 생성
CREATE TABLE chat_rooms (
    chat_room_idx BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    chat_room_title VARCHAR(100) NOT NULL,
    room_people INT NOT NULL,
    room_link VARCHAR(256) NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- chats 테이블 생성
CREATE TABLE chats (
    chat_idx BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    chat_room_idx BIGINT NOT NULL,
    user_idx BIGINT NOT NULL,
    content TEXT NOT NULL,
    read_status DATETIME NULL,
    system_message BOOLEAN NOT NULL DEFAULT 0,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    chat_code INT NULL,
    FOREIGN KEY (chat_room_idx) REFERENCES chat_rooms(chat_room_idx),
    FOREIGN KEY (user_idx) REFERENCES users(user_idx)
);

-- notifications 테이블 생성
CREATE TABLE notifications (
    notification_idx BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_idx BIGINT NOT NULL,
    recipe_idx BIGINT NULL,
    chat_room_idx BIGINT NULL,
    type ENUM('RECIPE_COMMENT', 'RECIPE_LIKE', 'POINT_GET', 'POINT_USE', 'CHAT_JOIN') NOT NULL,
    content TEXT NOT NULL,
    link VARCHAR(255) NULL,
    metadata JSON NULL,
    is_read BOOLEAN NOT NULL DEFAULT 0,
    is_dismissed BOOLEAN NOT NULL DEFAULT 0,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_idx) REFERENCES users(user_idx),
    FOREIGN KEY (recipe_idx) REFERENCES recipe(recipe_idx),
    FOREIGN KEY (chat_room_idx) REFERENCES chat_rooms(chat_room_idx)
);

-- betting_image 테이블 생성
CREATE TABLE betting_image (
    betting VARCHAR(255) NOT NULL PRIMARY KEY,
    image_url VARCHAR(255) NOT NULL
);

-- gotta_game 테이블 생성
CREATE TABLE gotta_game (
    gotta_idx BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    score INT NOT NULL,
    probability DOUBLE NOT NULL
);

-- closeup_game 테이블 생성
CREATE TABLE closeup_game (
    closeup_idx BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    closeup_image_url VARCHAR(255) NULL,
    origin_image_url VARCHAR(255) NULL,
    food_name VARCHAR(20) NULL
);

-- poop_game 테이블 생성
CREATE TABLE poop_game (
    poop_idx BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY
);

-- slot_machine_game 테이블 생성
CREATE TABLE slot_machine_game (
    slot_idx BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    slot_image_url VARCHAR(255) NULL,
    probability DOUBLE NULL
);

-- point 테이블 생성
CREATE TABLE point (
    point_idx BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_idx BIGINT NOT NULL,
    point_value BIGINT NULL,
    point_state ENUM('P', 'M') NULL,
    point_comment VARCHAR(255) NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_idx) REFERENCES users(user_idx)
);

-- point_shop 테이블 생성
CREATE TABLE point_shop (
    gift_idx BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    gift_category VARCHAR(20) NULL,
    gift_brand VARCHAR(20) NULL,
    gift_description VARCHAR(255) NULL,
    gift_point INT NULL,
    gift_image_url VARCHAR(255) NULL,
    gift_barcode_url VARCHAR(255) NULL
);

-- gift_history 테이블 생성
CREATE TABLE gift_history (
    history_idx BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_idx BIGINT NOT NULL,
    gift_idx BIGINT NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    barcode_image_url VARCHAR(255) NOT NULL,
    use_status BOOLEAN NULL,
    expired_at DATETIME NOT NULL,
    FOREIGN KEY (user_idx) REFERENCES users(user_idx),
    FOREIGN KEY (gift_idx) REFERENCES point_shop(gift_idx)
);

-- recommend_theme 테이블 생성
CREATE TABLE recommend_theme (
    theme_idx BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    theme_name VARCHAR(30) NULL,
    theme_description VARCHAR(50) NULL,
    theme_image_url VARCHAR(255) NOT NULL DEFAULT 0
);

-- food_theme 테이블 생성
CREATE TABLE food_theme (
    theme_food_idx BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    theme_idx BIGINT NOT NULL,
    food_idx BIGINT NOT NULL,
    FOREIGN KEY (theme_idx) REFERENCES recommend_theme(theme_idx)
);

-- restaurant_category 테이블 생성
CREATE TABLE restaurant_category (
    category_idx BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    major_category VARCHAR(20) NOT NULL,
    minor_category VARCHAR(20) NOT NULL
);

-- food_category 테이블 생성
CREATE TABLE food_category (
    food_idx BIGINT NOT NULL PRIMARY KEY,
    category_idx BIGINT NOT NULL,
    food_name VARCHAR(20) NOT NULL,
    food_image_url VARCHAR(255) NOT NULL,
    FOREIGN KEY (category_idx) REFERENCES restaurant_category(category_idx)
);

-- company 테이블 생성
CREATE TABLE company (
    company_idx BIGINT NOT NULL PRIMARY KEY,
    user_idx BIGINT NOT NULL,
    latitude DECIMAL(10, 8) NULL,
    longitude DECIMAL(11, 8) NULL,
    FOREIGN KEY (user_idx) REFERENCES users(user_idx)
);

-- notice 테이블 생성
CREATE TABLE notice (
    notice_idx BIGINT NOT NULL PRIMARY KEY,
    notice_title VARCHAR(20) NOT NULL,
    notice_description VARCHAR(255) NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- question 테이블 생성
CREATE TABLE question (
    que_idx BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_idx BIGINT NOT NULL,
    que_title VARCHAR(25) NOT NULL,
    que_description VARCHAR(255) NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status BOOLEAN NULL,
    FOREIGN KEY (user_idx) REFERENCES users(user_idx)
);

-- answer 테이블 생성
CREATE TABLE answer (
    ans_idx BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    que_idx BIGINT NOT NULL,
    answer VARCHAR(255) NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (que_idx) REFERENCES question(que_idx)
);

-- free_board 테이블 생성
CREATE TABLE free_board (
    free_board_idx BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_idx BIGINT NOT NULL,
    title VARCHAR(500) NOT NULL,
    content TEXT NOT NULL,
    category VARCHAR(50) NULL,
    picture VARCHAR(255) NULL,
    video VARCHAR(255) NULL,
    likes_count INT NOT NULL DEFAULT 0,
    comments_count INT NOT NULL DEFAULT 0,
    views_count INT NOT NULL DEFAULT 0,
    tag VARCHAR(255) NULL,
    report_count INT NOT NULL DEFAULT 0,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_idx) REFERENCES users(user_idx)
);

-- PurchasedGift 테이블 생성
CREATE TABLE purchasedGift (
    purchase_idx BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_idx BIGINT,
    gift_idx BIGINT,
    purchase_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_used BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (user_idx) REFERENCES users(user_idx),
    FOREIGN KEY (gift_idx) REFERENCES point_shop(gift_idx)
);

-- 닉네임 시퀀스 및 트리거 생성
CREATE TABLE nick_name_seq (
    id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY
);

DELIMITER $$
CREATE FUNCTION get_next_nick_name() RETURNS VARCHAR(50)
BEGIN
    DECLARE next_id BIGINT;
    DECLARE next_nick_name VARCHAR(50);
    INSERT INTO nick_name_seq VALUES (NULL);
    SET next_id = LAST_INSERT_ID();
    SET next_nick_name = CONCAT('bobple', next_id);
    RETURN next_nick_name;
END $$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER before_insert_users
BEFORE INSERT ON users
FOR EACH ROW
BEGIN
    IF NEW.nick_name = '' THEN
        SET NEW.nick_name = get_next_nick_name();
    END IF;
END $$
DELIMITER ;

-- 실시간 인기 검색어 초기화 스케줄 이벤트
DROP EVENT IF EXISTS reset_search_keywords;
CREATE EVENT reset_search_keywords
ON SCHEDULE EVERY 1 DAY
STARTS '2024-07-25 12:00:00'
DO
TRUNCATE TABLE search_keywords;

SET GLOBAL event_scheduler = ON;
