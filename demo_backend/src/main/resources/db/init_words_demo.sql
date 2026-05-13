-- words_demo database initialization script.
-- Execute this file manually in the MySQL console or DevEco/IDEA Database console.
-- It is intentionally not named schema.sql/data.sql, so Spring Boot will not run it automatically.

SET NAMES utf8mb4;

CREATE DATABASE IF NOT EXISTS words_demo
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_unicode_ci;

USE words_demo;

CREATE TABLE IF NOT EXISTS books (
  id BIGINT NOT NULL AUTO_INCREMENT,
  title VARCHAR(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  level_tag VARCHAR(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  description VARCHAR(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  total_words INT NOT NULL DEFAULT 0,
  accent_color VARCHAR(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  soft_color VARCHAR(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS users (
  id BIGINT NOT NULL AUTO_INCREMENT,
  account VARCHAR(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  password_hash VARCHAR(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  nickname VARCHAR(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  daily_target INT NOT NULL,
  signature VARCHAR(255) COLLATE utf8mb4_unicode_ci DEFAULT '',
  selected_book_id BIGINT NOT NULL,
  total_learned_words INT NOT NULL DEFAULT 0,
  streak_days INT NOT NULL DEFAULT 0,
  accuracy_rate INT NOT NULL DEFAULT 0,
  review_due INT NOT NULL DEFAULT 0,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY account (account)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS user_books (
  id BIGINT NOT NULL AUTO_INCREMENT,
  user_id BIGINT NOT NULL,
  book_id BIGINT NOT NULL,
  learned_words INT NOT NULL DEFAULT 0,
  today_new INT NOT NULL DEFAULT 0,
  today_review INT NOT NULL DEFAULT 0,
  progress INT NOT NULL DEFAULT 0,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uk_user_books (user_id, book_id),
  KEY fk_user_books_book (book_id),
  CONSTRAINT fk_user_books_book FOREIGN KEY (book_id) REFERENCES books (id),
  CONSTRAINT fk_user_books_user FOREIGN KEY (user_id) REFERENCES users (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS words (
  id BIGINT NOT NULL AUTO_INCREMENT,
  book_id BIGINT NOT NULL,
  word VARCHAR(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  phonetic VARCHAR(100) COLLATE utf8mb4_unicode_ci DEFAULT '',
  meaning VARCHAR(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  memory_tip VARCHAR(255) COLLATE utf8mb4_unicode_ci DEFAULT '',
  example_text VARCHAR(255) COLLATE utf8mb4_unicode_ci DEFAULT '',
  translation_text VARCHAR(255) COLLATE utf8mb4_unicode_ci DEFAULT '',
  answer VARCHAR(255) COLLATE utf8mb4_unicode_ci DEFAULT '',
  difficulty VARCHAR(50) COLLATE utf8mb4_unicode_ci DEFAULT '',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY fk_words_book (book_id),
  CONSTRAINT fk_words_book FOREIGN KEY (book_id) REFERENCES books (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS notebook_words (
  id BIGINT NOT NULL AUTO_INCREMENT,
  user_id BIGINT NOT NULL,
  word_id BIGINT DEFAULT NULL,
  word VARCHAR(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  meaning VARCHAR(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  book_title VARCHAR(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  mastery_label VARCHAR(50) COLLATE utf8mb4_unicode_ci DEFAULT '',
  next_review DATE DEFAULT NULL,
  added_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  note_text VARCHAR(255) COLLATE utf8mb4_unicode_ci DEFAULT '',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY fk_notebook_words_user (user_id),
  CONSTRAINT fk_notebook_words_user FOREIGN KEY (user_id) REFERENCES users (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS wrong_words (
  id BIGINT NOT NULL AUTO_INCREMENT,
  user_id BIGINT NOT NULL,
  word_id BIGINT DEFAULT NULL,
  word VARCHAR(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  meaning VARCHAR(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  book_title VARCHAR(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  wrong_count INT NOT NULL DEFAULT 1,
  last_wrong_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  sentence_text VARCHAR(255) COLLATE utf8mb4_unicode_ci DEFAULT '',
  reason_text VARCHAR(255) COLLATE utf8mb4_unicode_ci DEFAULT '',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY fk_wrong_words_user (user_id),
  CONSTRAINT fk_wrong_words_user FOREIGN KEY (user_id) REFERENCES users (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS study_records (
  id BIGINT NOT NULL AUTO_INCREMENT,
  user_id BIGINT NOT NULL,
  study_date DATE NOT NULL,
  book_title VARCHAR(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  new_count INT NOT NULL DEFAULT 0,
  review_count INT NOT NULL DEFAULT 0,
  correct_rate INT NOT NULL DEFAULT 0,
  finished_words INT NOT NULL DEFAULT 0,
  duration_minutes INT NOT NULL DEFAULT 0,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_study_record_user_date (user_id, study_date),
  CONSTRAINT fk_study_records_user FOREIGN KEY (user_id) REFERENCES users (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS sign_records (
  id BIGINT NOT NULL AUTO_INCREMENT,
  user_id BIGINT NOT NULL,
  sign_date DATE NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uk_sign_records (user_id, sign_date),
  CONSTRAINT fk_sign_records_user FOREIGN KEY (user_id) REFERENCES users (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO books (id, title, level_tag, description, total_words, accent_color, soft_color)
VALUES
  (1, '四级高频词汇', 'CET-4', '适合大学英语四级备考的高频核心词汇。', 30, '#F97316', '#FFF1E6'),
  (2, '六级高频词汇', 'CET-6', '覆盖六级阅读和写作常见高频词。', 30, '#0EA5A4', '#E8FFFB'),
  (3, '考研核心词汇', '考研', '面向考研英语阅读和写作的核心词汇。', 30, '#7C3AED', '#F4EDFF')
ON DUPLICATE KEY UPDATE
  title = VALUES(title),
  level_tag = VALUES(level_tag),
  description = VALUES(description),
  total_words = VALUES(total_words),
  accent_color = VALUES(accent_color),
  soft_color = VALUES(soft_color);

INSERT INTO users (
  id, account, password_hash, nickname, daily_target, signature,
  selected_book_id, total_learned_words, streak_days, accuracy_rate, review_due
)
VALUES (
  1,
  'demo_user',
  '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92',
  '测试用户',
  30,
  '坚持学习，让每天的进步看得见',
  1,
  9,
  2,
  100,
  0
)
ON DUPLICATE KEY UPDATE
  password_hash = VALUES(password_hash),
  nickname = VALUES(nickname),
  daily_target = VALUES(daily_target),
  signature = VALUES(signature),
  selected_book_id = VALUES(selected_book_id),
  total_learned_words = VALUES(total_learned_words),
  streak_days = VALUES(streak_days),
  accuracy_rate = VALUES(accuracy_rate),
  review_due = VALUES(review_due);

INSERT INTO words (
  id, book_id, word, phonetic, meaning, memory_tip,
  example_text, translation_text, answer, difficulty
)
VALUES
  (1, 1, 'abandon', '/əˈbændən/', '放弃；抛弃', '常见搭配 abandon a plan，表示放弃计划。', 'Do not abandon your daily plan.', '不要放弃你的每日计划。', '放弃；抛弃', '四级核心词'),
  (2, 1, 'benefit', '/ˈbenɪfɪt/', '益处；有益于', '既可以作名词，也可以作动词。', 'Reading aloud can benefit your memory.', '朗读有助于记忆。', '益处；有益于', '四级核心词'),
  (3, 1, 'improve', '/ɪmˈpruːv/', '提高；改善', '常见搭配 improve efficiency，表示提高效率。', 'Practice can improve your speaking skills.', '练习能提高你的口语能力。', '提高；改善', '四级核心词'),
  (4, 1, 'common', '/ˈkɒmən/', '常见的；普通的', 'common mistake 表示常见错误。', 'This is a common mistake in writing.', '这是写作中的常见错误。', '常见的；普通的', '四级核心词'),
  (5, 1, 'increase', '/ɪnˈkriːs/', '增加；增长', '可作动词或名词，注意重音变化。', 'The number of learners continues to increase.', '学习者数量持续增加。', '增加；增长', '四级核心词'),
  (6, 1, 'reduce', '/rɪˈdjuːs/', '减少；降低', '常见搭配 reduce pressure，表示减轻压力。', 'Good planning can reduce stress.', '好的计划可以减轻压力。', '减少；降低', '四级核心词'),
  (7, 1, 'support', '/səˈpɔːt/', '支持；支撑', 'support an idea 表示支持一个观点。', 'Evidence can support your opinion.', '证据可以支持你的观点。', '支持；支撑', '四级核心词'),
  (8, 1, 'detail', '/ˈdiːteɪl/', '细节；详细说明', 'pay attention to details 表示注意细节。', 'Please check every detail before submitting.', '提交前请检查每个细节。', '细节；详细说明', '四级核心词'),
  (9, 1, 'review', '/rɪˈvjuː/', '复习；回顾', 'review words 表示复习单词。', 'You should review new words every day.', '你应该每天复习新单词。', '复习；回顾', '四级核心词'),
  (10, 1, 'choice', '/tʃɔɪs/', '选择；选项', 'make a choice 表示做出选择。', 'The right choice saves time.', '正确的选择能节省时间。', '选择；选项', '四级核心词'),
  (11, 2, 'allocate', '/ˈæləkeɪt/', '分配；拨出', '常和 time、resource、budget 搭配。', 'We should allocate more time to review.', '我们应该分配更多时间复习。', '分配；拨出', '六级核心词'),
  (12, 2, 'adequate', '/ˈædɪkwət/', '足够的；适当的', 'adequate preparation 表示充分准备。', 'Adequate sleep helps concentration.', '充足睡眠有助于集中注意力。', '足够的；适当的', '六级核心词'),
  (13, 2, 'approach', '/əˈprəʊtʃ/', '方法；接近', 'an effective approach 表示有效方法。', 'This approach works well for vocabulary learning.', '这种方法很适合词汇学习。', '方法；接近', '六级核心词'),
  (14, 2, 'complex', '/ˈkɒmpleks/', '复杂的', 'complex problem 表示复杂问题。', 'The text explains a complex idea clearly.', '这篇文章清楚解释了一个复杂观点。', '复杂的', '六级核心词'),
  (15, 2, 'confirm', '/kənˈfɜːm/', '确认；证实', 'confirm information 表示确认信息。', 'Please confirm the answer before you submit.', '提交前请确认答案。', '确认；证实', '六级核心词'),
  (16, 2, 'contrast', '/ˈkɒntrɑːst/', '对比；差异', 'in contrast 表示相比之下。', 'The chart shows a clear contrast.', '图表显示出明显对比。', '对比；差异', '六级核心词'),
  (17, 2, 'efficient', '/ɪˈfɪʃnt/', '高效的', 'efficient method 表示高效方法。', 'An efficient plan can improve learning.', '高效计划能提升学习效果。', '高效的', '六级核心词'),
  (18, 2, 'factor', '/ˈfæktə/', '因素；要素', 'key factor 表示关键因素。', 'Motivation is an important factor in study.', '动力是学习中的重要因素。', '因素；要素', '六级核心词'),
  (19, 2, 'indicate', '/ˈɪndɪkeɪt/', '表明；指出', 'indicate that 表示表明某事。', 'The results indicate steady progress.', '结果表明进步稳定。', '表明；指出', '六级核心词'),
  (20, 2, 'strategy', '/ˈstrætədʒi/', '策略；计划', 'learning strategy 表示学习策略。', 'A clear strategy makes review easier.', '清晰策略让复习更容易。', '策略；计划', '六级核心词'),
  (21, 3, 'empirical', '/ɪmˈpɪrɪkəl/', '经验主义的；实证的', '学术文章中常见，表示基于实验或观察。', 'The paper provides empirical evidence.', '论文提供了实证证据。', '经验主义的；实证的', '考研核心词'),
  (22, 3, 'analyze', '/ˈænəlaɪz/', '分析', 'analyze data 表示分析数据。', 'We need to analyze the structure of the passage.', '我们需要分析文章结构。', '分析', '考研核心词'),
  (23, 3, 'concept', '/ˈkɒnsept/', '概念；观念', 'basic concept 表示基本概念。', 'The concept appears often in academic writing.', '这个概念常出现在学术写作中。', '概念；观念', '考研核心词'),
  (24, 3, 'derive', '/dɪˈraɪv/', '获得；源于', 'derive from 表示来源于。', 'Many words derive from Latin.', '许多单词源于拉丁语。', '获得；源于', '考研核心词'),
  (25, 3, 'establish', '/ɪˈstæblɪʃ/', '建立；确立', 'establish a theory 表示确立理论。', 'Researchers established a new model.', '研究者建立了一个新模型。', '建立；确立', '考研核心词'),
  (26, 3, 'interpret', '/ɪnˈtɜːprɪt/', '解释；理解', 'interpret evidence 表示解释证据。', 'Students should interpret the sentence carefully.', '学生应仔细理解这个句子。', '解释；理解', '考研核心词'),
  (27, 3, 'logical', '/ˈlɒdʒɪkl/', '合乎逻辑的', 'logical connection 表示逻辑联系。', 'A logical argument is easier to follow.', '有逻辑的论证更容易理解。', '合乎逻辑的', '考研核心词'),
  (28, 3, 'perspective', '/pəˈspektɪv/', '观点；视角', 'from a different perspective 表示从不同视角。', 'The author offers a new perspective.', '作者提供了一个新视角。', '观点；视角', '考研核心词'),
  (29, 3, 'significant', '/sɪɡˈnɪfɪkənt/', '重要的；显著的', 'significant change 表示显著变化。', 'The study shows significant improvement.', '研究显示出显著提升。', '重要的；显著的', '考研核心词'),
  (30, 3, 'theory', '/ˈθɪəri/', '理论；学说', 'theory and practice 表示理论与实践。', 'The theory explains the result well.', '该理论很好地解释了结果。', '理论；学说', '考研核心词')
ON DUPLICATE KEY UPDATE
  book_id = VALUES(book_id),
  word = VALUES(word),
  phonetic = VALUES(phonetic),
  meaning = VALUES(meaning),
  memory_tip = VALUES(memory_tip),
  example_text = VALUES(example_text),
  translation_text = VALUES(translation_text),
  answer = VALUES(answer),
  difficulty = VALUES(difficulty);

INSERT INTO user_books (
  id, user_id, book_id, learned_words, today_new, today_review, progress
)
VALUES
  (1, 1, 1, 9, 3, 0, 90),
  (2, 1, 2, 0, 0, 0, 0),
  (3, 1, 3, 0, 0, 0, 0)
ON DUPLICATE KEY UPDATE
  learned_words = VALUES(learned_words),
  today_new = VALUES(today_new),
  today_review = VALUES(today_review),
  progress = VALUES(progress);

INSERT INTO study_records (
  id, user_id, study_date, book_title, new_count,
  review_count, correct_rate, finished_words, duration_minutes
)
VALUES
  (1001, 1, DATE_SUB(CURDATE(), INTERVAL 1 DAY), '四级高频词汇', 4, 0, 100, 4, 8),
  (1002, 1, CURDATE(), '四级高频词汇', 5, 0, 100, 5, 10)
ON DUPLICATE KEY UPDATE
  user_id = VALUES(user_id),
  study_date = VALUES(study_date),
  book_title = VALUES(book_title),
  new_count = VALUES(new_count),
  review_count = VALUES(review_count),
  correct_rate = VALUES(correct_rate),
  finished_words = VALUES(finished_words),
  duration_minutes = VALUES(duration_minutes);

INSERT INTO notebook_words (
  id, user_id, word_id, word, meaning, book_title,
  mastery_label, next_review, note_text
)
VALUES
  (1001, 1, 1, 'abandon', '放弃；抛弃', '四级高频词汇', '待复习', DATE_ADD(CURDATE(), INTERVAL 1 DAY), '常见搭配 abandon a plan。'),
  (1002, 1, 3, 'allocate', '分配；拨出', '六级高频词汇', '重点词', DATE_ADD(CURDATE(), INTERVAL 2 DAY), '常和 time、resource、budget 搭配。')
ON DUPLICATE KEY UPDATE
  user_id = VALUES(user_id),
  word_id = VALUES(word_id),
  word = VALUES(word),
  meaning = VALUES(meaning),
  book_title = VALUES(book_title),
  mastery_label = VALUES(mastery_label),
  next_review = VALUES(next_review),
  note_text = VALUES(note_text);

INSERT INTO wrong_words (
  id, user_id, word_id, word, meaning, book_title,
  wrong_count, sentence_text, reason_text
)
VALUES
  (1001, 1, 2, 'benefit', '益处；有益于', '四级高频词汇', 1, 'Reading aloud can benefit your memory.', '名词和动词词性容易混淆。')
ON DUPLICATE KEY UPDATE
  user_id = VALUES(user_id),
  word_id = VALUES(word_id),
  word = VALUES(word),
  meaning = VALUES(meaning),
  book_title = VALUES(book_title),
  wrong_count = VALUES(wrong_count),
  sentence_text = VALUES(sentence_text),
  reason_text = VALUES(reason_text);

INSERT INTO sign_records (id, user_id, sign_date)
VALUES (1001, 1, CURDATE())
ON DUPLICATE KEY UPDATE
  user_id = VALUES(user_id),
  sign_date = VALUES(sign_date);
