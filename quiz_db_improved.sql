-- Improved Database Schema for QuizPal Project
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `mydb`;

-- -----------------------------------------------------
-- Table `mydb`.`user`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`user` (
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

-- -----------------------------------------------------
-- Table `mydb`.`category`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`category` (
  `category_id` INT NOT NULL AUTO_INCREMENT,
  `category_name` VARCHAR(100) NOT NULL,
  `description` TEXT NULL,
  `is_active` BOOLEAN NOT NULL DEFAULT TRUE,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`category_id`),
  UNIQUE INDEX `idx_category_name` (`category_name` ASC))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `mydb`.`question`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`question` (
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
    REFERENCES `mydb`.`category` (`category_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `mydb`.`choice`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`choice` (
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
    REFERENCES `mydb`.`question` (`question_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `mydb`.`quiz`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`quiz` (
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
    REFERENCES `mydb`.`user` (`user_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_quiz_category`
    FOREIGN KEY (`category_id`)
    REFERENCES `mydb`.`category` (`category_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `mydb`.`quiz_answer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`quiz_answer` (
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
    REFERENCES `mydb`.`quiz` (`quiz_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_answer_question`
    FOREIGN KEY (`question_id`)
    REFERENCES `mydb`.`question` (`question_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_answer_choice`
    FOREIGN KEY (`selected_choice_id`)
    REFERENCES `mydb`.`choice` (`choice_id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `mydb`.`contact`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`contact` (
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
    REFERENCES `mydb`.`user` (`user_id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `mydb`.`feedback`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`feedback` (
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
    REFERENCES `mydb`.`user` (`user_id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Views for common queries
-- -----------------------------------------------------

-- View for quiz results with user and category info
CREATE OR REPLACE VIEW `quiz_results_view` AS
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

-- View for question statistics
CREATE OR REPLACE VIEW `question_stats_view` AS
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

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
