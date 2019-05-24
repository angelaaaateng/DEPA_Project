CREATE TABLE IF NOT EXISTS `cryptodb`.`twitter` (
  `coin_id` INT(10) NOT NULL,
  `date` DATETIME NOT NULL,
  `tweet_count` BIGINT(20) NOT NULL,
  PRIMARY KEY (`coin_id`, `date`),
  CONSTRAINT `cryptodb`.`coin`
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

CREATE TABLE IF NOT EXISTS `cryptodb`.`reddit` (
  `post_id` INT(20) NOT NULL,
  `date` DATETIME NOT NULL,
  `num_comments` BIGINT(20) NOT NULL,
  `score` BIGINT(20) NOT NULL,
  `subreddit` VARCHAR(50) NOT NULL,
  `title` VARCHAR(225) NOT NULL,
  PRIMARY KEY (`post_id`, `date`),
  CONSTRAINT `cryptodb`.`reddit_coin`
    FOREIGN KEY (`post_id`)
    REFERENCES `cryptodb`.`reddit_coin` (`post_id`)
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


CREATE TABLE IF NOT EXISTS `cryptodb`.`gtrends` (
  `coin_id` INT(20) NOT NULL,
  `date` DATETIME NOT NULL,
  `trend` FLOAT() NOT NULL,
  PRIMARY KEY (`coin_id`, `date`),
  CONSTRAINT `cryptodb`.`coin`
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
  CONSTRAINT `cryptodb`.`coin`
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


CREATE TABLE IF NOT EXISTS `cryptodb `.`pricing` (
  `Date_id` INT(10) NOT NULL AUTO_INCREMENT,
  `Date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`Date_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

Coin_table:
CREATE TABLE IF NOT EXISTS `cryptodb `.`pricing` (
  `Coin_id` INT(10) NOT NULL AUTO_INCREMENT,
  `Coin_Name`  VARCHAR(50) NULL DEFAULT NULL,
  PRIMARY KEY (`Coin_id`)),
CONSTRAINT `cryptodb`.`pricing`
    FOREIGN KEY (`Coin_id`)
    REFERENCES `cryptodb`.`pricing` (`Coin_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
CONSTRAINT `cryptodb`.`twitter`
    FOREIGN KEY (`Coin_id`)
    REFERENCES `cryptodb`.`twitter`(`Coin_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
CONSTRAINT `cryptodb`.`gtrends`
    FOREIGN KEY (`Coin_id`)
    REFERENCES `cryptodb`.`gtrends` (`Coin_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


CREATE TABLE IF NOT EXISTS `cryptodb `.`pricing` (
  `Post_id` INT(20) NOT NULL AUTO_INCREMENT,
  `Coin_Id`  INT(10) NULL DEFAULT NULL,
  PRIMARY KEY (`Post_id`)),
CONSTRAINT `cryptodb`.`Reddit`
    FOREIGN KEY (`Post_id`)
    REFERENCES `cryptodb`.`Reddit` (`Post_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;



