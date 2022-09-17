-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`feedback`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`feedback` (
  `feedback_id` INT NOT NULL,
  `message` VARCHAR(255) NULL,
  `rating` INT NULL,
  `submit_date` TIMESTAMP NULL,
  PRIMARY KEY (`feedback_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`contact`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`contact` (
  `contact_id` INT NOT NULL,
  `firstname` VARCHAR(45) NULL,
  `lastname` VARCHAR(45) NULL,
  `subject` VARCHAR(45) NULL,
  `message` VARCHAR(45) NULL,
  PRIMARY KEY (`contact_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`category`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`category` (
  `category_id` INT NOT NULL,
  `category_name` VARCHAR(45) NULL,
  PRIMARY KEY (`category_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`question`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`question` (
  `question_id` INT NOT NULL,
  `category_id` INT NOT NULL,
  `quiz_description` VARCHAR(45) NULL,
  `is_active` TINYINT(1) NULL,
  PRIMARY KEY (`question_id`),
  INDEX `fk_question_category1_idx` (`category_id` ASC) VISIBLE,
  CONSTRAINT `fk_question_category1`
    FOREIGN KEY (`category_id`)
    REFERENCES `mydb`.`category` (`category_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`choice`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`choice` (
  `choice_id` INT NOT NULL,
  `question_id` INT NOT NULL,
  `choice_description` VARCHAR(45) NULL,
  `is_correct` TINYINT(1) NULL,
  PRIMARY KEY (`choice_id`),
  INDEX `fk_choice_question1_idx` (`question_id` ASC) VISIBLE,
  CONSTRAINT `fk_choice_question1`
    FOREIGN KEY (`question_id`)
    REFERENCES `mydb`.`question` (`question_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`user`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`user` (
  `user_id` INT NOT NULL,
  `user_name` VARCHAR(45) NULL,
  `user_password` VARCHAR(45) GENERATED ALWAYS AS () VIRTUAL,
  `firstname` VARCHAR(45) NULL,
  `lastname` VARCHAR(45) NULL,
  `email` VARCHAR(45) NULL,
  `phone` VARCHAR(45) NULL,
  `is_active` TINYINT(1) NULL,
  `is_admin` TINYINT(1) NULL,
  PRIMARY KEY (`user_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`quiz`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`quiz` (
  `quiz_id` INT NOT NULL,
  `user_id` INT NOT NULL,
  `category_id` INT NOT NULL,
  `quiz_name` VARCHAR(45) NULL,
  `quiz_time_start` TIMESTAMP NULL,
  `quiz_time_end` TIMESTAMP NULL,
  PRIMARY KEY (`quiz_id`),
  INDEX `fk_quiz_user_idx` (`user_id` ASC) VISIBLE,
  INDEX `fk_quiz_category1_idx` (`category_id` ASC) VISIBLE,
  CONSTRAINT `fk_quiz_user`
    FOREIGN KEY (`user_id`)
    REFERENCES `mydb`.`user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_quiz_category1`
    FOREIGN KEY (`category_id`)
    REFERENCES `mydb`.`category` (`category_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`quizquestion`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`quizquestion` (
  `quizquestion_id` INT NOT NULL,
  `quiz_id` INT NOT NULL,
  `question_id` INT NOT NULL,
  `quizquestioncol` VARCHAR(45) NULL,
  `hoice_id` INT NOT NULL,
  `order_num` INT NULL,
  `is_marked` TINYINT(1) NULL,
  PRIMARY KEY (`quizquestion_id`),
  INDEX `fk_quizquestion_quiz1_idx` (`quiz_id` ASC) VISIBLE,
  INDEX `fk_quizquestion_question1_idx` (`question_id` ASC) VISIBLE,
  INDEX `fk_quizquestion_choice1_idx` (`hoice_id` ASC) VISIBLE,
  CONSTRAINT `fk_quizquestion_quiz1`
    FOREIGN KEY (`quiz_id`)
    REFERENCES `mydb`.`quiz` (`quiz_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_quizquestion_question1`
    FOREIGN KEY (`question_id`)
    REFERENCES `mydb`.`question` (`question_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_quizquestion_choice1`
    FOREIGN KEY (`hoice_id`)
    REFERENCES `mydb`.`choice` (`choice_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
