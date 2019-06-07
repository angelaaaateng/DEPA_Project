/***********************************************
**                MSc ANALYTICS 
**     DATA ENGINEERING PLATFORMS (MSCA 31012)
** File:   CRYPTODB_star DDL
** Desc:   Creating the CRYPTODB Star Dimensional model
** Date:   06/01/2019
** ALL RIGHTS RESERVED | DO NOT DISTRIBUTE
************************************************/

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';


-- -----------------------------------------------------
-- Schema CRYPTODB_star
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `CRYPTODB_star` DEFAULT CHARACTER SET utf8 ;
USE `CRYPTODB_star` ;

-- -----------------------------------------------------
-- Table `CRYPTODB_star`.`dim_coin`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CRYPTODB_star`.`dim_coin` (
  `coin_id` INT NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  `symbol` VARCHAR(45) NOT NULL,
  `slug` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`coin_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CRYPTODB_star`.`dim_date`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CRYPTODB_star`.`dim_date` (
  `date_id` INT NOT NULL,
  `date` DATE NULL,
  `weekend` CHAR(10) NOT NULL DEFAULT 'Weekday',
  `day_of_week` VARCHAR(45) NULL DEFAULT NULL,
  `month` VARCHAR(45) NULL DEFAULT NULL,
  `month_day` VARCHAR(45) NULL DEFAULT NULL,
  `year` VARCHAR(45) NULL DEFAULT NULL,
  `week_starting_monday` CHAR(2) NULL DEFAULT NULL,
  PRIMARY KEY (`date_Id`),
  UNIQUE INDEX `date` (`date` ASC),
  INDEX `year_week` (`year` ASC, `week_starting_monday` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

-- -----------------------------------------------------
-- Table `CRYPTODB_star`.`fact_table`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CRYPTODB_star`.`fact_table` (
  `price_id` INT NOT NULL,
  `coin_id` INT NOT NULL,
  `date_id` INT NOT NULL,
  `close` FLOAT NOT NULL,
  `high` FLOAT NOT NULL,
  `low` FLOAT NOT NULL,
  `open` FLOAT NOT NULL,
  `volumefrom` FLOAT NOT NULL,
  `volumeto` FLOAT NOT NULL,
  `tweet_count` BIGINT(20) NULL,
  `trend` FLOAT NULL,
  `total_subscribers` BIGINT(20) NULL,
  `reddit_score` BIGINT(20) NULL,
  `reddit_comments` BIGINT(20) NULL,
  `reddit_posts` BIGINT(20) NULL,
  PRIMARY KEY (`price_id`),
  INDEX `fk_fact_table_dim_coin_idx` (`coin_id` ASC) ,
  INDEX `fk_fact_table_dim_date_idx` (`date_id` ASC) ,
  CONSTRAINT `fk_fact_table_dim_coin`
    FOREIGN KEY (`coin_id`)
    REFERENCES `CRYPTODB_star`.`dim_coin` (`coin_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_fact_table_dim_date`
    FOREIGN KEY (`date_id`)
    REFERENCES `CRYPTODB_star`.`dim_date` (`date_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `CRYPTODB_star`.`numbers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CRYPTODB_star`.`numbers` (
  `number` BIGINT(20) NULL DEFAULT NULL)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

-- -----------------------------------------------------
-- Table `CRYPTODB_star`.`numbers_small`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CRYPTODB_star`.`numbers_small` (
  `number` INT(11) NULL DEFAULT NULL)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
