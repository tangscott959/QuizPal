-- Add missing quizquestion table for compatibility with existing code
CREATE TABLE IF NOT EXISTS `quiz_db_new`.`quizquestion` (
  `quiz_question_id` INT NOT NULL AUTO_INCREMENT,
  `quiz_id` INT NOT NULL,
  `question_id` INT NOT NULL,
  `choice_id` INT NOT NULL,
  `marked` BOOLEAN NOT NULL DEFAULT FALSE,
  PRIMARY KEY (`quiz_question_id`),
  INDEX `fk_quizquestion_quiz_idx` (`quiz_id` ASC),
  INDEX `fk_quizquestion_question_idx` (`question_id` ASC),
  INDEX `fk_quizquestion_choice_idx` (`choice_id` ASC),
  CONSTRAINT `fk_quizquestion_quiz`
    FOREIGN KEY (`quiz_id`)
    REFERENCES `quiz_db_new`.`quiz` (`quiz_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_quizquestion_question`
    FOREIGN KEY (`question_id`)
    REFERENCES `quiz_db_new`.`question` (`question_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_quizquestion_choice`
    FOREIGN KEY (`choice_id`)
    REFERENCES `quiz_db_new`.`choice` (`choice_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

-- Add missing feedback table
CREATE TABLE IF NOT EXISTS `quiz_db_new`.`feedback` (
  `feedback_id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NULL,
  `feedback_text` TEXT NOT NULL,
  `rating` INT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`feedback_id`),
  INDEX `fk_feedback_user_idx` (`user_id` ASC),
  CONSTRAINT `fk_feedback_user`
    FOREIGN KEY (`user_id`)
    REFERENCES `quiz_db_new`.`user` (`user_id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;

-- Add missing contact table
CREATE TABLE IF NOT EXISTS `quiz_db_new`.`contact` (
  `contact_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `email` VARCHAR(255) NOT NULL,
  `message` TEXT NOT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`contact_id`))
ENGINE = InnoDB;
