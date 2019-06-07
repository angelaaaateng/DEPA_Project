CREATE SCHEMA CRYPTODB; 

USE CRYPTODB;


CREATE TABLE IF NOT EXISTS `CRYPTODB`.`date` (
  `Date_id` BIGINT(10) NOT NULL AUTO_INCREMENT,
  `Date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`Date_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

CREATE TABLE IF NOT EXISTS `CRYPTODB`.`coin` (
  `Coin_id` INT(10) NOT NULL AUTO_INCREMENT,
  `Coin_Name`  VARCHAR(50) NULL DEFAULT NULL,
  PRIMARY KEY (`Coin_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


CREATE TABLE IF NOT EXISTS `CRYPTODB`.`reddit_coin` (
  `Post_id` INT(20) NOT NULL AUTO_INCREMENT,
  `Coin_Id`  INT(10) NULL DEFAULT NULL,
  PRIMARY KEY (`Post_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

CREATE INDEX `fk_coin_twitter` ON `CRYPTODB`.`coin` (`coin_id` ASC);
CREATE INDEX `fk_coin_date` ON `CRYPTODB`.`date` (`date` ASC);


CREATE TABLE IF NOT EXISTS `CRYPTODB`.`twitter` (
  `coin_id` INT(10) NOT NULL,
  `date` DATETIME NOT NULL,
  `tweet_count` BIGINT(20) NOT NULL,
  `date_id` BIGINT(10) NOT NULL, 
  PRIMARY KEY (`coin_id`, `date`),
  CONSTRAINT `fk_coin_twitter`
    FOREIGN KEY (`coin_id`)
    REFERENCES `CRYPTODB`.`coin` (`coin_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
CONSTRAINT `fk_twitter_dateid`
    FOREIGN KEY (`date_id`)
    REFERENCES `cryptodb`.`date` (`date_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

#CREATE INDEX `fk_twitter_dateid`  ON `CRYPTODB`.`date` (`date_id` ASC);

#CREATE INDEX `fk_post_reddit` ON `CRYPTODB`.`reddit_coin` (`post_id` ASC);

CREATE TABLE IF NOT EXISTS `cryptodb`.`reddit` (
  `post_id` INT(20) NOT NULL,
  `date` DATETIME NOT NULL,
  `num_comments` BIGINT(20) NOT NULL,
  `score` BIGINT(20) NOT NULL,
  `subreddit` VARCHAR(50) NOT NULL,
  `title` VARCHAR(225) NOT NULL,
  `date_id` BIGINT(10) NOT NULL, 
  PRIMARY KEY (`post_id`, `date`),
  CONSTRAINT `fk_post_reddit`
    FOREIGN KEY (`post_id`)
    REFERENCES `cryptodb`.`reddit_coin` (`post_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
CONSTRAINT `fk_reddit_dateid`
    FOREIGN KEY (`date_id`)
    REFERENCES `cryptodb`.`date` (`date_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


#CREATE INDEX `fk_reddit_date` ON `CRYPTODB`.`date`  (`date` ASC);


#CREATE INDEX `fk_coin_gtrends` ON `CRYPTODB`.`coin` (`coin_id` ASC);

#CREATE INDEX `fk_gtrends_date` ON `CRYPTODB`.`date` (`date` ASC);


CREATE TABLE IF NOT EXISTS `CRYPTODB`.`gtrends` (
  `coin_id` INT(20) NOT NULL,
  `date` DATETIME NOT NULL,
  `trend` FLOAT(10) NOT NULL,
  `date_id` BIGINT(10) NOT NULL, 
  PRIMARY KEY (`coin_id`, `date`),
  CONSTRAINT `fk_coin_gtrends`
    FOREIGN KEY (`coin_id`)
    REFERENCES `cryptodb`.`coin` (`coin_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
CONSTRAINT `fk_gtrends_dateid`
    FOREIGN KEY (`date_id`)
    REFERENCES `cryptodb`.`date` (`date_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


CREATE TABLE IF NOT EXISTS `CRYPTODB`.`pricing` (
  `coin_id` INT(10) NOT NULL AUTO_INCREMENT,
  `date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `close` FLOAT(10) NULL DEFAULT NULL,
  `high` FLOAT(10) NULL DEFAULT NULL,
  `low` FLOAT(10) NULL DEFAULT NULL,
  `volumefrom` FLOAT(10) NULL DEFAULT NULL,
  `volumeto` FLOAT(10) NULL DEFAULT NULL,
  `date_id` BIGINT(10) NOT NULL, 
  PRIMARY KEY (`coin_id`,`date_id`),
  CONSTRAINT `fk_pricing_coin`
    FOREIGN KEY (`coin_id`)
    REFERENCES `cryptodb`.`coin` (`coin_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
CONSTRAINT `fk_pricing_dateid`
    FOREIGN KEY (`date_id`)
    REFERENCES `cryptodb`.`date` (`date_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

CREATE TABLE IF NOT EXISTS `CRYPTODB`.`rsubscribers` (
  `Coin_id` INT(10) NOT NULL AUTO_INCREMENT,
  `subreddit` VARCHAR(50) NOT NULL,
  `total_subscribers` INT(10) NOT NULL,
  `date_id` BIGINT(10) NOT NULL, 
  PRIMARY KEY (`coin_id`,`date_id`),
  CONSTRAINT `fk_rsub_coin`
    FOREIGN KEY (`coin_id`)
    REFERENCES `cryptodb`.`coin` (`coin_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_rsub_dateid`
    FOREIGN KEY (`date_id`)
    REFERENCES `cryptodb`.`date` (`date_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;



