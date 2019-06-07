-- MySQL Workbench Forward Engineering
-- User: Angela Teng

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema CRYPTODB
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema CRYPTODB
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `CRYPTODB` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `CRYPTODB` ;

-- -----------------------------------------------------
-- Table `CRYPTODB`.`coin`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CRYPTODB`.`coin` (
  `Coin_id` INT(10) NOT NULL AUTO_INCREMENT,
  `Coin_Name` VARCHAR(50) NULL DEFAULT NULL,
  PRIMARY KEY (`Coin_id`),
  INDEX `fk_coin_twitter` (`Coin_id` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `CRYPTODB`.`date`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CRYPTODB`.`date` (
  `Date_id` BIGINT(10) NOT NULL AUTO_INCREMENT,
  `Date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`Date_id`),
  INDEX `fk_coin_date` (`Date` ASC) VISIBLE,
  INDEX `fk_twitter_dateid` (`Date_id` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `CRYPTODB`.`gtrends`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CRYPTODB`.`gtrends` (
  `coin_id` INT(20) NOT NULL,
  `date` DATETIME NOT NULL,
  `trend` FLOAT NOT NULL,
  `date_id` BIGINT(10) NOT NULL,
  PRIMARY KEY (`coin_id`, `date`),
  INDEX `fk_gtrends_date` (`date` ASC) VISIBLE,
  INDEX `fk_gtrends_dateid` (`date_id` ASC) VISIBLE,
  CONSTRAINT `fk_coin_gtrends`
    FOREIGN KEY (`coin_id`)
    REFERENCES `CRYPTODB`.`coin` (`Coin_id`),
  CONSTRAINT `fk_gtrends_date`
    FOREIGN KEY (`date`)
    REFERENCES `CRYPTODB`.`date` (`Date`),
  CONSTRAINT `fk_gtrends_dateid`
    FOREIGN KEY (`date_id`)
    REFERENCES `CRYPTODB`.`date` (`Date_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `CRYPTODB`.`pricing`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CRYPTODB`.`pricing` (
  `coin_id` INT(10) NOT NULL AUTO_INCREMENT,
  `date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `close` FLOAT NULL DEFAULT NULL,
  `high` FLOAT NULL DEFAULT NULL,
  `low` FLOAT NULL DEFAULT NULL,
  `volumefrom` FLOAT NULL DEFAULT NULL,
  `volumeto` FLOAT NULL DEFAULT NULL,
  `date_id` BIGINT(10) NOT NULL,
  PRIMARY KEY (`coin_id`, `date`),
  INDEX `fk_pricing_date` (`date` ASC) VISIBLE,
  INDEX `fk_pricing_dateid` (`date_id` ASC) VISIBLE,
  CONSTRAINT `fk_pricing_coin`
    FOREIGN KEY (`coin_id`)
    REFERENCES `CRYPTODB`.`coin` (`Coin_id`),
  CONSTRAINT `fk_pricing_date`
    FOREIGN KEY (`date`)
    REFERENCES `CRYPTODB`.`date` (`Date`),
  CONSTRAINT `fk_pricing_dateid`
    FOREIGN KEY (`date_id`)
    REFERENCES `CRYPTODB`.`date` (`Date_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `CRYPTODB`.`reddit_coin`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CRYPTODB`.`reddit_coin` (
  `Post_id` INT(20) NOT NULL AUTO_INCREMENT,
  `Coin_Id` INT(10) NULL DEFAULT NULL,
  PRIMARY KEY (`Post_id`),
  INDEX `fk_post_reddit` (`Post_id` ASC) VISIBLE,
  INDEX `coin_id_idx` (`Coin_Id` ASC) VISIBLE,
  CONSTRAINT `coin_id`
    FOREIGN KEY (`Coin_Id`)
    REFERENCES `CRYPTODB`.`coin` (`Coin_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `CRYPTODB`.`reddit`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CRYPTODB`.`reddit` (
  `post_id` INT(20) NOT NULL,
  `date` DATETIME NOT NULL,
  `num_comments` BIGINT(20) NOT NULL,
  `score` BIGINT(20) NOT NULL,
  `subreddit` VARCHAR(50) NOT NULL,
  `title` VARCHAR(225) NOT NULL,
  `date_id` BIGINT(10) NOT NULL,
  PRIMARY KEY (`post_id`, `date`),
  INDEX `fk_reddit_date` (`date` ASC) VISIBLE,
  INDEX `fk_reddit_dateid` (`date_id` ASC) VISIBLE,
  CONSTRAINT `fk_post_reddit`
    FOREIGN KEY (`post_id`)
    REFERENCES `CRYPTODB`.`reddit_coin` (`Post_id`),
  CONSTRAINT `fk_reddit_date`
    FOREIGN KEY (`date`)
    REFERENCES `CRYPTODB`.`date` (`Date`),
  CONSTRAINT `fk_reddit_dateid`
    FOREIGN KEY (`date_id`)
    REFERENCES `CRYPTODB`.`date` (`Date_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `CRYPTODB`.`twitter`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CRYPTODB`.`twitter` (
  `coin_id` INT(10) NOT NULL,
  `date` DATETIME NOT NULL,
  `tweet_count` BIGINT(20) NOT NULL,
  `date_id` BIGINT(10) NOT NULL,
  PRIMARY KEY (`coin_id`, `date`),
  INDEX `fk_coin_date` (`date` ASC) VISIBLE,
  INDEX `fk_twitter_dateid` (`date_id` ASC) VISIBLE,
  CONSTRAINT `fk_coin_date`
    FOREIGN KEY (`date`)
    REFERENCES `CRYPTODB`.`date` (`Date`),
  CONSTRAINT `fk_coin_twitter`
    FOREIGN KEY (`coin_id`)
    REFERENCES `CRYPTODB`.`coin` (`Coin_id`),
  CONSTRAINT `fk_twitter_dateid`
    FOREIGN KEY (`date_id`)
    REFERENCES `CRYPTODB`.`date` (`Date_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
