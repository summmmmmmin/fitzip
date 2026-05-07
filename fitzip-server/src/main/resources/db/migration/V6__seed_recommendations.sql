-- ══════════════════════════════════════════════════════════════
-- 체형별 스타일링 추천 시드 데이터
-- ══════════════════════════════════════════════════════════════

-- ── STRAIGHT 여성 ─────────────────────────────────────────────
INSERT INTO body_type_recommendations (body_type, gender, category, item_name, recommendation_reason, avoid_items, priority) VALUES
('STRAIGHT','FEMALE','TOP','크롭 탑 / 숏 블라우스','허리 라인을 강조해 곡선을 만들어줍니다.','오버사이즈 루즈핏 상의',1),
('STRAIGHT','FEMALE','TOP','러플 블라우스','볼륨감을 추가해 여성스러운 실루엣을 연출합니다.', NULL, 2),
('STRAIGHT','FEMALE','BOTTOM','플레어 스커트','힙부터 퍼지는 실루엣으로 곡선미를 강조합니다.','일자형 스트레이트 팬츠',1),
('STRAIGHT','FEMALE','BOTTOM','A라인 스커트','자연스럽게 허리 라인을 잡아줍니다.', NULL, 2),
('STRAIGHT','FEMALE','OUTER','벨티드 코트 / 트렌치코트','허리 벨트로 라인을 만들어 슬림하게 보입니다.','오버사이즈 박시 자켓',1),
('STRAIGHT','FEMALE','DRESS','머메이드 드레스','바디 라인을 그대로 살려 우아함을 강조합니다.','H라인 시프트 드레스',1);

-- ── STRAIGHT 남성 ─────────────────────────────────────────────
INSERT INTO body_type_recommendations (body_type, gender, category, item_name, recommendation_reason, avoid_items, priority) VALUES
('STRAIGHT','MALE','TOP','피케 셔츠 / 핏 티셔츠','적당한 핏으로 균형잡힌 체형을 돋보이게 합니다.','헐렁한 빅사이즈',1),
('STRAIGHT','MALE','BOTTOM','슬림 치노 팬츠','깔끔한 라인으로 세련된 느낌을 줍니다.','와이드 배기 팬츠',1),
('STRAIGHT','MALE','OUTER','슬림핏 수트 자켓','어깨 라인을 강조하고 전체적으로 샤프하게 보입니다.', NULL, 1);

-- ── NATURAL 여성 ──────────────────────────────────────────────
INSERT INTO body_type_recommendations (body_type, gender, category, item_name, recommendation_reason, avoid_items, priority) VALUES
('NATURAL','FEMALE','TOP','V넥 블라우스','균형잡힌 체형을 자연스럽게 살려줍니다.', NULL, 1),
('NATURAL','FEMALE','TOP','스트라이프 니트','세로 라인으로 키가 커 보이는 효과를 줍니다.', NULL, 2),
('NATURAL','FEMALE','BOTTOM','하이웨이스트 청바지','허리에서 시작하는 라인으로 다리를 길어보이게 합니다.', NULL, 1),
('NATURAL','FEMALE','BOTTOM','미디 스커트','균형잡힌 비율을 극대화합니다.', NULL, 2),
('NATURAL','FEMALE','OUTER','테일러드 자켓','구조적인 실루엣으로 세련된 느낌을 줍니다.', NULL, 1),
('NATURAL','FEMALE','DRESS','랩 드레스','자연스러운 체형 라인을 그대로 살립니다.', NULL, 1);

-- ── NATURAL 남성 ──────────────────────────────────────────────
INSERT INTO body_type_recommendations (body_type, gender, category, item_name, recommendation_reason, avoid_items, priority) VALUES
('NATURAL','MALE','TOP','레귤러핏 셔츠','균형잡힌 체형에 딱 맞는 깔끔한 실루엣입니다.', NULL, 1),
('NATURAL','MALE','BOTTOM','레귤러핏 슬랙스','자연스러운 체형 라인을 살립니다.', NULL, 1),
('NATURAL','MALE','OUTER','레더 자켓 / 봄버 자켓','어깨 라인을 강조해 더욱 멋스럽게 보입니다.', NULL, 1);

-- ── WAVE 여성 ─────────────────────────────────────────────────
INSERT INTO body_type_recommendations (body_type, gender, category, item_name, recommendation_reason, avoid_items, priority) VALUES
('WAVE','FEMALE','TOP','오프숄더 탑','어깨와 데콜테 라인을 강조해 균형을 맞춥니다.','두꺼운 패딩이나 숄더 패드',1),
('WAVE','FEMALE','TOP','스퀘어넥 블라우스','어깨를 넓어 보이게 해 허리~힙 비율을 균형있게 합니다.', NULL, 2),
('WAVE','FEMALE','BOTTOM','스트레이트 팬츠','히프 볼륨을 자연스럽게 잡아줍니다.','미니스커트, 타이트한 튜브 스커트',1),
('WAVE','FEMALE','BOTTOM','A라인 미디 스커트','허리의 잘록함을 살리면서 아랫부분을 균형 있게 커버합니다.', NULL, 2),
('WAVE','FEMALE','OUTER','크롭 자켓','상체에 볼륨을 더해 전체 비율을 맞춥니다.','롱 오버사이즈 코트',1),
('WAVE','FEMALE','DRESS','핏앤플레어 드레스','허리를 강조하고 아래로 퍼지며 완벽한 모래시계 실루엣을 만듭니다.', NULL, 1);

-- ── WAVE 남성 ─────────────────────────────────────────────────
INSERT INTO body_type_recommendations (body_type, gender, category, item_name, recommendation_reason, avoid_items, priority) VALUES
('WAVE','MALE','TOP','숄더 패드 셔츠 / 구조적 자켓','어깨를 넓어 보이게 해 상체와 하체 비율을 맞춥니다.', NULL, 1),
('WAVE','MALE','BOTTOM','테이퍼드 팬츠','허벅지에서 발목으로 자연스럽게 좁아지며 전체 실루엣을 정돈합니다.','와이드 배기 팬츠',1),
('WAVE','MALE','OUTER','패드 숄더 코트','어깨 라인을 살려 상하체 균형을 맞춥니다.', NULL, 1);
