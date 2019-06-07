
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
CREATE SCHEMA IF NOT EXISTS `CRYPTODB` DEFAULT CHARACTER SET utf8 ;
USE `CRYPTODB` ;

-- -----------------------------------------------------
-- Table `CRYPTODB`.`coin`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CRYPTODB`.`coin` (
  `coin_id` INT(11) NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  `symbol` VARCHAR(45) NULL DEFAULT NULL,
  `slug` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`coin_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `CRYPTODB`.`gtrends`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CRYPTODB`.`gtrends` (
  `date` DATETIME NOT NULL,
  `coin_id` INT(11) NOT NULL,
  `trend` FLOAT NOT NULL,
  `trend_id` INT NOT NULL AUTO_INCREMENT,
  INDEX `fk_gtrends_coin1_idx` (`coin_id` ASC),
  PRIMARY KEY (`trend_id`),
  CONSTRAINT `fk_gtrends_coin1`
    FOREIGN KEY (`coin_id`)
    REFERENCES `CRYPTODB`.`coin` (`coin_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `CRYPTODB`.`pricing`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CRYPTODB`.`pricing` (
  `date` DATETIME NOT NULL,
  `coin_id` INT(11) NOT NULL,
  `close` FLOAT NOT NULL,
  `high` FLOAT NOT NULL,
  `low` FLOAT NOT NULL,
  `open` FLOAT NOT NULL,
  `volumefrom` FLOAT NOT NULL,
  `volumeto` FLOAT NOT NULL,
  `price_id` INT NOT NULL AUTO_INCREMENT,
  INDEX `fk_pricing_coin1_idx` (`coin_id` ASC),
  PRIMARY KEY (`price_id`),
  CONSTRAINT `fk_pricing_coin1`
    FOREIGN KEY (`coin_id`)
    REFERENCES `CRYPTODB`.`coin` (`coin_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `CRYPTODB`.`reddit`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CRYPTODB`.`reddit` (
  `post_id` INT(11) NOT NULL,
  `author` VARCHAR(45) NOT NULL,
  `date` DATETIME NOT NULL,
  `num_comments` BIGINT(10) NOT NULL,
  `score` BIGINT(10) NOT NULL,
  `subreddit` VARCHAR(45) NOT NULL,
  `title` VARCHAR(200) NOT NULL,
  PRIMARY KEY (`post_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `CRYPTODB`.`reddit_coin`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CRYPTODB`.`reddit_coin` (
  `post_id` INT(11) NOT NULL,
  `coin_id` INT(11) NOT NULL,
  INDEX `fk_reddit_coin_coin2_idx` (`coin_id` ASC),
  INDEX `fk_reddit_coin_reddit1` (`post_id` ASC) ,
  CONSTRAINT `fk_reddit_coin_coin2`
    FOREIGN KEY (`coin_id`)
    REFERENCES `CRYPTODB`.`coin` (`coin_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_reddit_coin_reddit1`
    FOREIGN KEY (`post_id`)
    REFERENCES `CRYPTODB`.`reddit` (`post_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `CRYPTODB`.`rsubscribers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CRYPTODB`.`rsubscribers` (
  `date` DATETIME NOT NULL,
  `coin_id` INT(11) NOT NULL,
  `total_subscribers` BIGINT(20) NOT NULL,
  `subreddit` VARCHAR(45) NOT NULL,
  `rsub_id` INT NOT NULL AUTO_INCREMENT,
  INDEX `fk_rsubscribers_coin1_idx` (`coin_id` ASC) ,
  PRIMARY KEY (`rsub_id`),
  CONSTRAINT `fk_rsubscribers_coin1`
    FOREIGN KEY (`coin_id`)
    REFERENCES `CRYPTODB`.`coin` (`coin_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `CRYPTODB`.`twitter`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CRYPTODB`.`twitter` (
  `date` DATETIME NOT NULL,
  `coin_id` INT(11) NOT NULL,
  `tweet_count` BIGINT(10) NOT NULL,
  `tweet_id` INT NOT NULL AUTO_INCREMENT,
  INDEX `fk_twitter_coin2_idx` (`coin_id` ASC) ,
  PRIMARY KEY (`tweet_id`),
  CONSTRAINT `fk_twitter_coin2`
    FOREIGN KEY (`coin_id`)
    REFERENCES `CRYPTODB`.`coin` (`coin_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
