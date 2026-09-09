-- QuizPal schema and seed data for local setup.
-- This script drops quiz_db_new if it exists.

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

DROP DATABASE IF EXISTS `quiz_db_new`;
CREATE DATABASE `quiz_db_new` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `quiz_db_new`;

CREATE TABLE IF NOT EXISTS `quiz_db_new`.`user` (
  `user_id` INT NOT NULL AUTO_INCREMENT,
  `user_name` VARCHAR(50) NOT NULL,
  `user_password` VARCHAR(255) NOT NULL COMMENT 'Hashed password',
  `firstname` VARCHAR(100) NULL,
  `lastname` VARCHAR(100) NULL,
  `email` VARCHAR(255) NOT NULL,
  `phone` VARCHAR(20) NULL,
  `is_active` BOOLEAN NOT NULL DEFAULT TRUE,
  `is_admin` BOOLEAN NOT NULL DEFAULT FALSE,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`),
  UNIQUE INDEX `idx_username` (`user_name` ASC),
  UNIQUE INDEX `idx_email` (`email` ASC),
  INDEX `idx_active` (`is_active` ASC))
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `quiz_db_new`.`category` (
  `category_id` INT NOT NULL AUTO_INCREMENT,
  `category_name` VARCHAR(100) NOT NULL,
  `description` TEXT NULL,
  `is_active` BOOLEAN NOT NULL DEFAULT TRUE,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`category_id`),
  UNIQUE INDEX `idx_category_name` (`category_name` ASC))
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `quiz_db_new`.`question` (
  `question_id` INT NOT NULL AUTO_INCREMENT,
  `category_id` INT NOT NULL,
  `question_text` TEXT NOT NULL,
  `question_type` ENUM('MULTIPLE_CHOICE', 'TRUE_FALSE', 'SHORT_ANSWER') NOT NULL DEFAULT 'MULTIPLE_CHOICE',
  `difficulty_level` ENUM('EASY', 'MEDIUM', 'HARD') NOT NULL DEFAULT 'MEDIUM',
  `points` INT NOT NULL DEFAULT 1,
  `is_active` BOOLEAN NOT NULL DEFAULT TRUE,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`question_id`),
  INDEX `fk_question_category_idx` (`category_id` ASC),
  INDEX `idx_active` (`is_active` ASC),
  INDEX `idx_difficulty` (`difficulty_level` ASC),
  CONSTRAINT `fk_question_category`
    FOREIGN KEY (`category_id`)
    REFERENCES `quiz_db_new`.`category` (`category_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `quiz_db_new`.`choice` (
  `choice_id` INT NOT NULL AUTO_INCREMENT,
  `question_id` INT NOT NULL,
  `choice_text` TEXT NOT NULL,
  `is_correct` BOOLEAN NOT NULL DEFAULT FALSE,
  `choice_order` INT NOT NULL DEFAULT 0,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`choice_id`),
  INDEX `fk_choice_question_idx` (`question_id` ASC),
  INDEX `idx_correct` (`is_correct` ASC),
  CONSTRAINT `fk_choice_question`
    FOREIGN KEY (`question_id`)
    REFERENCES `quiz_db_new`.`question` (`question_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `quiz_db_new`.`quiz` (
  `quiz_id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NOT NULL,
  `category_id` INT NOT NULL,
  `quiz_name` VARCHAR(255) NULL,
  `quiz_time_start` TIMESTAMP NULL,
  `quiz_time_end` TIMESTAMP NULL,
  `time_limit_minutes` INT NULL COMMENT 'Time limit in minutes',
  `total_questions` INT NOT NULL DEFAULT 0,
  `score` INT NOT NULL DEFAULT 0,
  `max_score` INT NOT NULL DEFAULT 0,
  `status` ENUM('IN_PROGRESS', 'COMPLETED', 'ABANDONED') NOT NULL DEFAULT 'IN_PROGRESS',
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`quiz_id`),
  INDEX `fk_quiz_user_idx` (`user_id` ASC),
  INDEX `fk_quiz_category_idx` (`category_id` ASC),
  INDEX `idx_status` (`status` ASC),
  INDEX `idx_start_time` (`quiz_time_start` ASC),
  CONSTRAINT `fk_quiz_user`
    FOREIGN KEY (`user_id`)
    REFERENCES `quiz_db_new`.`user` (`user_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_quiz_category`
    FOREIGN KEY (`category_id`)
    REFERENCES `quiz_db_new`.`category` (`category_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `quiz_db_new`.`quiz_answer` (
  `answer_id` INT NOT NULL AUTO_INCREMENT,
  `quiz_id` INT NOT NULL,
  `question_id` INT NOT NULL,
  `selected_choice_id` INT NULL,
  `answer_text` TEXT NULL COMMENT 'For short answer questions',
  `is_correct` BOOLEAN NULL COMMENT 'NULL if not yet graded',
  `points_earned` INT NOT NULL DEFAULT 0,
  `time_taken_seconds` INT NULL,
  `answered_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`answer_id`),
  INDEX `fk_answer_quiz_idx` (`quiz_id` ASC),
  INDEX `fk_answer_question_idx` (`question_id` ASC),
  INDEX `fk_answer_choice_idx` (`selected_choice_id` ASC),
  UNIQUE INDEX `idx_quiz_question` (`quiz_id` ASC, `question_id` ASC),
  CONSTRAINT `fk_answer_quiz`
    FOREIGN KEY (`quiz_id`)
    REFERENCES `quiz_db_new`.`quiz` (`quiz_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_answer_question`
    FOREIGN KEY (`question_id`)
    REFERENCES `quiz_db_new`.`question` (`question_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_answer_choice`
    FOREIGN KEY (`selected_choice_id`)
    REFERENCES `quiz_db_new`.`choice` (`choice_id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `quiz_db_new`.`contact` (
  `contact_id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NULL,
  `firstname` VARCHAR(100) NULL,
  `lastname` VARCHAR(100) NULL,
  `email` VARCHAR(255) NOT NULL,
  `subject` VARCHAR(255) NOT NULL,
  `message` TEXT NOT NULL,
  `status` ENUM('NEW', 'READ', 'REPLIED') NOT NULL DEFAULT 'NEW',
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`contact_id`),
  INDEX `fk_contact_user_idx` (`user_id` ASC),
  INDEX `idx_status` (`status` ASC),
  INDEX `idx_created_at` (`created_at` ASC),
  CONSTRAINT `fk_contact_user`
    FOREIGN KEY (`user_id`)
    REFERENCES `quiz_db_new`.`user` (`user_id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `quiz_db_new`.`feedback` (
  `feedback_id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NULL,
  `rating` INT NOT NULL CHECK (`rating` BETWEEN 1 AND 5),
  `message` TEXT NULL,
  `feedback_type` ENUM('GENERAL', 'QUIZ', 'BUG_REPORT', 'SUGGESTION') NOT NULL DEFAULT 'GENERAL',
  `is_resolved` BOOLEAN NOT NULL DEFAULT FALSE,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`feedback_id`),
  INDEX `fk_feedback_user_idx` (`user_id` ASC),
  INDEX `idx_rating` (`rating` ASC),
  INDEX `idx_type` (`feedback_type` ASC),
  INDEX `idx_resolved` (`is_resolved` ASC),
  CONSTRAINT `fk_feedback_user`
    FOREIGN KEY (`user_id`)
    REFERENCES `quiz_db_new`.`user` (`user_id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;

CREATE OR REPLACE VIEW `quiz_db_new`.`quiz_results_view` AS
SELECT
    q.quiz_id,
    q.quiz_name,
    q.status,
    q.score,
    q.max_score,
    ROUND((q.score / NULLIF(q.max_score, 0)) * 100, 2) AS percentage,
    q.quiz_time_start,
    q.quiz_time_end,
    TIMESTAMPDIFF(SECOND, q.quiz_time_start, q.quiz_time_end) AS duration_seconds,
    u.user_id,
    u.user_name,
    CONCAT(u.firstname, ' ', u.lastname) AS full_name,
    c.category_id,
    c.category_name
FROM quiz q
JOIN user u ON q.user_id = u.user_id
JOIN category c ON q.category_id = c.category_id;

CREATE OR REPLACE VIEW `quiz_db_new`.`question_stats_view` AS
SELECT
    q.question_id,
    q.question_text,
    q.difficulty_level,
    q.points,
    c.category_name,
    COUNT(qa.answer_id) AS times_answered,
    COUNT(CASE WHEN qa.is_correct = TRUE THEN 1 END) AS times_correct,
    ROUND((COUNT(CASE WHEN qa.is_correct = TRUE THEN 1 END) /
           NULLIF(COUNT(qa.answer_id), 0)) * 100, 2) AS success_rate
FROM question q
JOIN category c ON q.category_id = c.category_id
LEFT JOIN quiz_answer qa ON q.question_id = qa.question_id
GROUP BY q.question_id, q.question_text, q.difficulty_level, q.points, c.category_name;

INSERT INTO category (category_name, description) VALUES
('Mathematics', 'Basic arithmetic and mathematical operations'),
('Science', 'General science questions'),
('History', 'World history and historical events'),
('Geography', 'Countries, capitals, and geographical features');

-- Seeded local accounts. Password for all three is: password
INSERT INTO user (user_name, user_password, firstname, lastname, email, is_admin, is_active) VALUES
('admin', '$2a$06$DCq7YPn5Rq63x1Lad4cll.2yIhH87Kz8Nto9PO6j6ztDk5dCcGkWa', 'System', 'Administrator', 'admin@quiz.com', 1, 1),
('teacher1', '$2a$06$DCq7YPn5Rq63x1Lad4cll.2yIhH87Kz8Nto9PO6j6ztDk5dCcGkWa', 'John', 'Teacher', 'teacher@quiz.com', 0, 1),
('student1', '$2a$06$DCq7YPn5Rq63x1Lad4cll.2yIhH87Kz8Nto9PO6j6ztDk5dCcGkWa', 'Jane', 'Student', 'student@quiz.com', 0, 1);

INSERT INTO question (category_id, question_text, question_type, difficulty_level, points) VALUES
(1, 'What is 2 + 2?', 'MULTIPLE_CHOICE', 'EASY', 1),
(1, 'What is 10 × 5?', 'MULTIPLE_CHOICE', 'EASY', 1),
(1, 'What is 15 - 7?', 'MULTIPLE_CHOICE', 'EASY', 1),
(1, 'What is 100 ÷ 4?', 'MULTIPLE_CHOICE', 'EASY', 1),
(1, 'What is 3 squared (3²)?', 'MULTIPLE_CHOICE', 'EASY', 1),
(2, 'What is the chemical symbol for water?', 'MULTIPLE_CHOICE', 'MEDIUM', 2),
(2, 'Which planet is closest to the Sun?', 'MULTIPLE_CHOICE', 'EASY', 1),
(2, 'What gas do plants absorb from the air?', 'MULTIPLE_CHOICE', 'EASY', 1),
(2, 'What is the center of an atom called?', 'MULTIPLE_CHOICE', 'MEDIUM', 2),
(2, 'What force keeps us on the ground?', 'MULTIPLE_CHOICE', 'EASY', 1),
(3, 'In which year did World War II end?', 'MULTIPLE_CHOICE', 'MEDIUM', 2),
(3, 'Who was the first President of the United States?', 'MULTIPLE_CHOICE', 'EASY', 1),
(3, 'In which year did World War I begin?', 'MULTIPLE_CHOICE', 'MEDIUM', 2),
(3, 'What ancient civilization built the pyramids at Giza?', 'MULTIPLE_CHOICE', 'EASY', 1),
(3, 'In which year did the Berlin Wall fall?', 'MULTIPLE_CHOICE', 'MEDIUM', 2),
(4, 'What is the capital of France?', 'MULTIPLE_CHOICE', 'EASY', 1),
(4, 'Which is the largest continent by area?', 'MULTIPLE_CHOICE', 'EASY', 1),
(4, 'What is the longest river in the world?', 'MULTIPLE_CHOICE', 'MEDIUM', 2),
(4, 'Which country has the largest population?', 'MULTIPLE_CHOICE', 'MEDIUM', 2),
(4, 'What is the smallest country in the world?', 'MULTIPLE_CHOICE', 'HARD', 3),
(4, 'Which desert is the largest in the world?', 'MULTIPLE_CHOICE', 'HARD', 3);

INSERT INTO choice (question_id, choice_text, is_correct, choice_order) VALUES
(1, '3', FALSE, 1),
(1, '4', TRUE, 2),
(1, '5', FALSE, 3),
(1, '6', FALSE, 4),
(2, '50', TRUE, 1),
(2, '40', FALSE, 2),
(2, '60', FALSE, 3),
(2, '55', FALSE, 4),
(3, '8', TRUE, 1),
(3, '6', FALSE, 2),
(3, '7', FALSE, 3),
(3, '9', FALSE, 4),
(4, '25', TRUE, 1),
(4, '20', FALSE, 2),
(4, '30', FALSE, 3),
(4, '40', FALSE, 4),
(5, '9', TRUE, 1),
(5, '6', FALSE, 2),
(5, '12', FALSE, 3),
(5, '27', FALSE, 4),
(6, 'H2O', TRUE, 1),
(6, 'CO2', FALSE, 2),
(6, 'O2', FALSE, 3),
(6, 'N2', FALSE, 4),
(7, 'Mercury', TRUE, 1),
(7, 'Venus', FALSE, 2),
(7, 'Earth', FALSE, 3),
(7, 'Mars', FALSE, 4),
(8, 'Carbon dioxide', TRUE, 1),
(8, 'Oxygen', FALSE, 2),
(8, 'Nitrogen', FALSE, 3),
(8, 'Hydrogen', FALSE, 4),
(9, 'Nucleus', TRUE, 1),
(9, 'Electron', FALSE, 2),
(9, 'Proton shell', FALSE, 3),
(9, 'Neutron cloud', FALSE, 4),
(10, 'Gravity', TRUE, 1),
(10, 'Magnetism', FALSE, 2),
(10, 'Friction', FALSE, 3),
(10, 'Pressure', FALSE, 4),
(11, '1945', TRUE, 1),
(11, '1944', FALSE, 2),
(11, '1946', FALSE, 3),
(11, '1943', FALSE, 4),
(12, 'George Washington', TRUE, 1),
(12, 'Thomas Jefferson', FALSE, 2),
(12, 'Abraham Lincoln', FALSE, 3),
(12, 'John Adams', FALSE, 4),
(13, '1914', TRUE, 1),
(13, '1918', FALSE, 2),
(13, '1939', FALSE, 3),
(13, '1900', FALSE, 4),
(14, 'Ancient Egypt', TRUE, 1),
(14, 'Ancient Rome', FALSE, 2),
(14, 'Ancient Greece', FALSE, 3),
(14, 'Mesopotamia', FALSE, 4),
(15, '1989', TRUE, 1),
(15, '1991', FALSE, 2),
(15, '1985', FALSE, 3),
(15, '1979', FALSE, 4),
(16, 'London', FALSE, 1),
(16, 'Paris', TRUE, 2),
(16, 'Berlin', FALSE, 3),
(16, 'Madrid', FALSE, 4),
(17, 'Africa', FALSE, 1),
(17, 'Asia', TRUE, 2),
(17, 'Europe', FALSE, 3),
(17, 'North America', FALSE, 4),
(18, 'Amazon', FALSE, 1),
(18, 'Nile', TRUE, 2),
(18, 'Yangtze', FALSE, 3),
(18, 'Mississippi', FALSE, 4),
(19, 'India', FALSE, 1),
(19, 'United States', FALSE, 2),
(19, 'China', TRUE, 3),
(19, 'Brazil', FALSE, 4),
(20, 'Monaco', FALSE, 1),
(20, 'San Marino', FALSE, 2),
(20, 'Vatican City', TRUE, 3),
(20, 'Liechtenstein', FALSE, 4),
(21, 'Sahara', FALSE, 1),
(21, 'Arabian', FALSE, 2),
(21, 'Antarctica', TRUE, 3),
(21, 'Gobi', FALSE, 4);

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
