-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema CRYPTODB
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema CRYPTODB
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `CRYPTODB`;
USE `CRYPTODB` ;

-- -----------------------------------------------------
-- Table `CRYPTODB`.`coin`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CRYPTODB`.`coin` (
  `coin_id` INT(10) NOT NULL,
  `name` VARCHAR(50) NOT NULL,
  `symbol` VARCHAR(10) NOT NULL,
  `slug` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`coin_id`),
  INDEX `fk_coin_twitter` (`coin_id` ASC) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `CRYPTODB`.`date`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CRYPTODB`.`date` (
  `date_id` BIGINT(10) NOT NULL,
  `date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`date_id`),
  INDEX `fk_coin_date` (`date` ASC) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `CRYPTODB`.`gtrends`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CRYPTODB`.`gtrends` (
  `date_id` BIGINT(10) NOT NULL,
  `coin_id` INT(10) NOT NULL,
  `trend` FLOAT NOT NULL,
  PRIMARY KEY (`coin_id`),
  INDEX `fk_gtrends_dateid` (`date_id` ASC) ,
  CONSTRAINT `fk_coin_gtrends`
    FOREIGN KEY (`coin_id`)
    REFERENCES `CRYPTODB`.`coin` (`coin_id`),
  CONSTRAINT `fk_gtrends_dateid`
    FOREIGN KEY (`date_id`)
    REFERENCES `CRYPTODB`.`date` (`date_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `CRYPTODB`.`pricing`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CRYPTODB`.`pricing` (
  `date_id` BIGINT(10) NOT NULL,
  `coin_id` INT(10) NOT NULL,
  `close` FLOAT NOT NULL,
  `high` FLOAT NOT NULL,
  `low` FLOAT NOT NULL,
  `open` FLOAT NOT NULL,
  `volumefrom` FLOAT NOT NULL,
  `volumeto` FLOAT NOT NULL,
  PRIMARY KEY (`coin_id`),
  INDEX `fk_pricing_dateid` (`date_id` ASC) ,
  CONSTRAINT `fk_pricing_coin`
    FOREIGN KEY (`coin_id`)
    REFERENCES `CRYPTODB`.`coin` (`coin_id`),
  CONSTRAINT `fk_pricing_dateid`
    FOREIGN KEY (`date_id`)
    REFERENCES `CRYPTODB`.`date` (`date_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `CRYPTODB`.`reddit_coin`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CRYPTODB`.`reddit_coin` (
  `post_id` INT(20) NOT NULL,
  `coin_id` INT(10) NOT NULL,
  PRIMARY KEY (`post_id`, `coin_id`),
  INDEX `coin_id_idx` (`coin_id` ASC) ,
  CONSTRAINT `coin_id`
    FOREIGN KEY (`coin_id`)
    REFERENCES `CRYPTODB`.`coin` (`coin_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `CRYPTODB`.`reddit`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CRYPTODB`.`reddit` (
  `post_id` INT(20) NOT NULL,
  `author` VARCHAR(45) NOT NULL,
  `num_comments` BIGINT(20) NOT NULL,
  `score` BIGINT(20) NOT NULL,
  `subreddit` VARCHAR(50) NOT NULL,
  `title` VARCHAR(225) NOT NULL,
  `date_id` BIGINT(10) NOT NULL,
  PRIMARY KEY (`post_id`),
  INDEX `fk_reddit_dateid` (`date_id` ASC) ,
  CONSTRAINT `fk_post_reddit`
    FOREIGN KEY (`post_id`)
    REFERENCES `CRYPTODB`.`reddit_coin` (`post_id`),
  CONSTRAINT `fk_reddit_dateid`
    FOREIGN KEY (`date_id`)
    REFERENCES `CRYPTODB`.`date` (`date_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `CRYPTODB`.`rsubscribers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CRYPTODB`.`rsubscribers` (
  `date_id` BIGINT(10) NOT NULL,
  `coin_id` INT(10) NOT NULL,
  `total_subscribers` INT(10) NOT NULL,
  `subreddit` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`coin_id`),
  INDEX `fk_rsub_dateid` (`date_id` ASC) ,
  CONSTRAINT `fk_rsub_coin`
    FOREIGN KEY (`coin_id`)
    REFERENCES `CRYPTODB`.`coin` (`coin_id`),
  CONSTRAINT `fk_rsub_dateid`
    FOREIGN KEY (`date_id`)
    REFERENCES `CRYPTODB`.`date` (`date_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `CRYPTODB`.`twitter`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CRYPTODB`.`twitter` (
  `date_id` BIGINT(10) NOT NULL,
  `coin_id` INT(10) NOT NULL,
  `tweet_count` BIGINT(20) NOT NULL,
  PRIMARY KEY (`coin_id`),
  INDEX `fk_twitter_dateid` (`date_id` ASC) ,
  CONSTRAINT `fk_coin_twitter`
    FOREIGN KEY (`coin_id`)
    REFERENCES `CRYPTODB`.`coin` (`coin_id`),
  CONSTRAINT `fk_twitter_dateid`
    FOREIGN KEY (`date_id`)
    REFERENCES `CRYPTODB`.`date` (`date_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
