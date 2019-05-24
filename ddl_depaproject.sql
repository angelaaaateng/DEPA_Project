CREATE SCHEMA crypto_db; 

USE crypto_db;


CREATE TABLE IF NOT EXISTS `cryptodb `.`date` (
  `Date_id` INT(10) NOT NULL AUTO_INCREMENT,
  `Date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`Date_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

CREATE TABLE IF NOT EXISTS `cryptodb `.`coin` (
  `Coin_id` INT(10) NOT NULL AUTO_INCREMENT,
  `Coin_Name`  VARCHAR(50) NULL DEFAULT NULL,
  PRIMARY KEY (`Coin_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


CREATE TABLE IF NOT EXISTS `cryptodb `.`reddit_coin` (
  `Post_id` INT(20) NOT NULL AUTO_INCREMENT,
  `Coin_Id`  INT(10) NULL DEFAULT NULL,
  PRIMARY KEY (`Post_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


CREATE TABLE IF NOT EXISTS `cryptodb`.`twitter` (
  `coin_id` INT(10) NOT NULL,
  `date` DATETIME NOT NULL,
  `tweet_count` BIGINT(20) NOT NULL,
  PRIMARY KEY (`coin_id`, `date`),
  CONSTRAINT `fk_coin_twitter`
    FOREIGN KEY (`coin_id`)
    REFERENCES `cryptodb`.`coin` (`coin_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_coin_date`
    FOREIGN KEY (`date`)
    REFERENCES `cryptodb`.`date` (`date`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

CREATE TABLE IF NOT EXISTS `cryptodb`.`reddit` (
  `post_id` INT(20) NOT NULL,
  `date` DATETIME NOT NULL,
  `num_comments` BIGINT(20) NOT NULL,
  `score` BIGINT(20) NOT NULL,
  `subreddit` VARCHAR(50) NOT NULL,
  `title` VARCHAR(225) NOT NULL,
  PRIMARY KEY (`post_id`, `date`),
  CONSTRAINT `fk_coin_reddit`
    FOREIGN KEY (`post_id`)
    REFERENCES `cryptodb`.`reddit_coin` (`post_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_reddit_date`
    FOREIGN KEY (`date`)
    REFERENCES `cryptodb`.`date` (`date`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


CREATE TABLE IF NOT EXISTS `cryptodb`.`gtrends` (
  `coin_id` INT(20) NOT NULL,
  `date` DATETIME NOT NULL,
  `trend` FLOAT() NOT NULL,
  PRIMARY KEY (`coin_id`, `date`),
  CONSTRAINT `fk_coin_gtrends`
    FOREIGN KEY (`coin_id`)
    REFERENCES `cryptodb`.`coin` (`coin_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `cryptodb`.`date`
    FOREIGN KEY (`date`)
    REFERENCES `cryptodb`.`date` (`date`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


CREATE TABLE IF NOT EXISTS `cryptodb `.`pricing` (
  `Coin_id` INT(10) NOT NULL AUTO_INCREMENT,
  `Date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Close` FLOAT() NULL DEFAULT NULL,
  `High ` FLOAT() NULL DEFAULT NULL,
  `Low ` FLOAT() NULL DEFAULT NULL,
  `Volume_from` FLOAT() NULL DEFAULT NULL,
 `Volume_To ` FLOAT() NULL DEFAULT NULL,
  PRIMARY KEY (`Coin_id `,`Date`)),
  CONSTRAINT `fk_pricing_coin`
    FOREIGN KEY (`coin_id`)
    REFERENCES `cryptodb`.`coin` (`coin_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `cryptodb`.`date`
    FOREIGN KEY (`date`)
    REFERENCES `cryptodb`.`date` (`date`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;



