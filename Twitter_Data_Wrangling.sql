SELECT * FROM twitter;

-- Create new column for tweet_time as tweet_date (and put it next to tweet_time)

ALTER TABLE twitter
ADD COLUMN tweet_date DATE AFTER tweet_time;

-- Add values into tweet_date by removing time in tweet_time

UPDATE twitter
SET tweet_date = STR_TO_DATE(SUBSTRING(tweet_time, 1, 10), '%Y-%m-%d');

-- Update engagement_rate so it rounds to two decimals

ALTER TABLE twitter
ADD COLUMN engagement_rate_update DOUBLE;

ALTER TABLE twitter
MODIFY COLUMN engagement_rate_update DOUBLE AFTER engagement_rate;

UPDATE twitter
SET engagement_rate_update = ROUND(engagement_rate, 2);

-- Create new column called tweet_length_range

ALTER TABLE twitter
ADD COLUMN tweet_length_range VARCHAR(10) AFTER tweet_length;

-- Update values in tweet_length_range with the following ranges: "0-56", "57-112", "113-168", "169-224", "225-280"

UPDATE twitter
SET tweet_length_range = 
	CASE
		WHEN tweet_length BETWEEN 0 AND 56 THEN '0 - 56'
        WHEN tweet_length BETWEEN 57 AND 112 THEN '57 - 112' 
        WHEN tweet_length BETWEEN 113 AND 168 THEN '113 - 168'
        WHEN tweet_length BETWEEN 169 AND 224 THEN '169 - 224'
        WHEN tweet_length BETWEEN 169 AND 224 THEN '169 - 224'
        ELSE '225 - 280'
	END;
    
-- Remove columns we don't need

ALTER TABLE twitter
DROP COLUMN tweet_time;

ALTER TABLE twitter
DROP COLUMN engagement_rate;

ALTER TABLE twitter
DROP COLUMN url_clicks;

ALTER TABLE twitter
DROP COLUMN detail_expands;

ALTER TABLE twitter
DROP COLUMN followers_gained;

ALTER TABLE twitter
DROP COLUMN media_views;

ALTER TABLE twitter
DROP COLUMN media_engagements;

-- Rename engagement_rate_update for simplicity sake later on

ALTER TABLE twitter
RENAME COLUMN engagement_rate_update TO engagement_rate;

-- We only want Tweets not Comments, so delete all rows where tweet_type = 'Comment'

DELETE FROM twitter
WHERE tweet_type = 'Comment';

