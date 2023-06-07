-- Creating the database to store our tables

CREATE DATABASE Twitter;

-- Telling MySQL which database to use
USE Twitter;

-- Making the table that will store the data I import

CREATE TABLE twitter (
	tweet_num INT,
    tweet_id BIGINT,
    tweet_text TEXT,
    tweet_type TEXT,
    tweet_time TEXT,
    impressions INT,
    engagements INT,
    engagement_rate INT,
    retweets INT,
    replies INT,
    likes INT,
    profile_clicks INT,
	url_clicks INT,
    detail_expands INT,
    followers_gained INT,
    media_views INT,
    media_engagements INT
    );

-- Changing the data type for engagement_rate column

ALTER TABLE twitter
MODIFY COLUMN engagement_rate DOUBLE;

-- Changing tweet_text to tweet_length

ALTER TABLE twitter
RENAME COLUMN tweet_text TO tweet_length;

-- Change the data type for new column tweet_length

ALTER TABLE twitter
MODIFY COLUMN tweet_length INT;