

USE CRYPTODB_star;

-- -----------------------------------------------------
-- Populate Time dimension
-- -----------------------------------------------------

INSERT INTO numbers_small VALUES (0),(1),(2),(3),(4),(5),(6),(7),(8),(9);

INSERT INTO numbers
SELECT 
    thousands.number * 1000 + hundreds.number * 100 + tens.number * 10 + ones.number
FROM
    numbers_small thousands,
    numbers_small hundreds,
    numbers_small tens,
    numbers_small ones
LIMIT 1000000;

INSERT INTO dim_date (date_Id, date)
SELECT 
    number,
    DATE_ADD('2000-01-01',
        INTERVAL number DAY)
FROM
    numbers
WHERE
    DATE_ADD('2000-01-01',
        INTERVAL number DAY) BETWEEN '2000-01-01' AND '2019-06-06'
ORDER BY number;

SET SQL_SAFE_UPDATES = 0;

UPDATE dim_date 
SET 
    day_of_week = DATE_FORMAT(date, '%W'),
    weekend = IF(DATE_FORMAT(date, '%W') IN ('Saturday' , 'Sunday'),
        'Weekend',
        'Weekday'),
    month = DATE_FORMAT(date, '%M'),
    year = DATE_FORMAT(date, '%Y'),
    month_day = DATE_FORMAT(date, '%d');

UPDATE dim_date 
SET 
    week_starting_monday = DATE_FORMAT(date, '%v');

-- -----------------------------------------------------
-- Copy Data from CRYPTODB database 
-- -----------------------------------------------------


-- -----------------------------------------------------
-- Table `CRYPTODB_star`.`dim_coin`
-- -----------------------------------------------------

INSERT INTO CRYPTODB_star.dim_coin 
(coin_id,
name, symbol, slug)  
(SELECT * FROM CRYPTODB.coin);

-- -----------------------------------------------------
-- Write Fact table fact_rental DML script here
-- -----------------------------------------------------

# insert data into the fact_table from  models table 
INSERT INTO CRYPTODB_star.fact_table 
(price_id,
  coin_id,
  date_id,
  close,
  high,
  low,
  open,
  volumefrom,
  volumeto,
  tweet_count,
  trend,
  total_subscribers,
  reddit_score,
  reddit_comments,
  reddit_posts) 
(SELECT
	p.price_id,
	p.coin_id,
    d.date_id,
    p.close,
    p.high,
    p.low,
    p.open,
    p.volumefrom,
    p.volumeto,
    t.tweet_count,
    g.trend,
    rs.total_subscribers,
    a.reddit_score,
    a.reddit_comments,
	a.reddit_posts
FROM
    CRYPTODB.pricing as p
    LEFT JOIN CRYPTODB.twitter AS t ON p.coin_id = t.coin_id AND date(p.date) = date(t.date)
    LEFT JOIN CRYPTODB.gtrends AS g ON p.coin_id = g.coin_id AND date(p.date) = date(g.date)
    LEFT JOIN (SELECT coin_id, date(date) as date, sum(total_subscribers) AS total_subscribers  
			   FROM CRYPTODB.rsubscribers GROUP BY coin_id, date) 
		AS rs ON p.coin_id = rs.coin_id AND date(p.date) = rs.date
    LEFT JOIN (SELECT rc.coin_id, date(r.date) as date, count(r.post_id) AS reddit_posts, sum(num_comments) AS reddit_comments, sum(score) AS reddit_score
			   FROM CRYPTODB.reddit AS r INNER JOIN CRYPTODB.reddit_coin AS rc ON r.post_id = rc.post_id GROUP BY date(r.date), rc.coin_id) AS a
    ON p.coin_id = a.coin_id AND date(p.date) = a.date
    LEFT JOIN dim_date AS d ON date(p.date) = d.date);
    
    
    
