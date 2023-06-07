-- 1. Find the following averages per tweet: Impressions, replies, likes, profile clicks, engagement rate

SELECT ROUND(AVG(impressions), 0) AS `Average Number of Impressions`,
	ROUND(AVG(replies), 0) AS `Average Number of Replies`,
    ROUND(AVG(likes), 0) AS `Average Number of Likes`,
    ROUND(AVG(profile_clicks), 0) AS `Average Number of Profile Clicks`,
    ROUND(AVG(engagement_rate), 2) AS `Average Engagement Rate`
FROM twitter;

-- 2. Find how many tweets are in each tweet length range

SELECT tweet_length_range, COUNT(*) AS `Number of Tweets in Range`
FROM twitter
GROUP BY 1
ORDER BY 2 DESC;

-- 3. Find table showing average impressions, likes, replies, engagements, engagement rates, profile clicks per range

SELECT tweet_length_range,
	COUNT(*) AS `Number of Tweets in Range`,
	ROUND(AVG(impressions),0) AS Average_Impressions,
    ROUND(AVG(likes),0) AS Average_Likes,
    ROUND(AVG(replies),0) AS Average_Replies,
    ROUND(AVG(engagements),0) AS Average_Engagements,
	ROUND(AVG(engagement_rate),2) AS Average_Engagement_Rate,
	ROUND(AVG(retweets),0) AS Average_Retweets,
    ROUND(AVG(profile_clicks),0) AS Average_Profile_Clicks
FROM twitter
GROUP BY 1;

-- 4. Find whether the average impressions per range is bettr or worse than the overall average for impressions

WITH cte_1 AS (
	WITH cte_2 AS (
		SELECT ROUND(AVG(impressions),0) AS average_impressions
		FROM twitter)
	SELECT t.tweet_length_range,
		ROUND(AVG(t.impressions),0) AS Avg_For_Range,
		(SELECT average_impressions
		FROM cte_2) AS Overall_Average
	FROM twitter t
	GROUP BY 1
	ORDER BY 2 DESC)
SELECT *,
	(CASE
		WHEN Avg_For_Range > Overall_Average THEN 'Better'
        WHEN Avg_For_Range < Overall_Average THEN 'Worse'
        ELSE NULL
	END) AS Better_or_Worse_Than_Overall_Average
FROM cte_1;
    
-- 5. Select all from top 5 tweets in each tweet length range and order by impressions desc

SELECT *
FROM (
	SELECT *,
	ROW_NUMBER() OVER(PARTITION BY tweet_length_range ORDER BY impressions DESC) AS row_num
	FROM twitter
	) AS sub_query
WHERE row_num BETWEEN 1 AND 5
ORDER BY tweet_length_range, impressions DESC;

-- 6. Find average likes, replies, engagements, and profile clicks per 100 impressions for all tweet length ranges

SELECT tweet_length_range, ROUND(AVG(likes / impressions) * 100, 0) AS `Average Likes Per 100 Impressions`,
	ROUND(AVG(replies / impressions) * 100, 0) AS `Average Replies Per 100 Impressions`,
    ROUND(AVG(engagements / impressions) * 100, 0) AS `Average Engagements Per 100 Impressions`,
    ROUND(AVG(profile_clicks / impressions) * 100, 0) AS `Average Profile Clicks Per 100 Impressions`
FROM twitter
GROUP BY 1;

-- 7. Find the % of tweets per tweet length range where impressions, replies, likes, engagements, profile clicks are all above average
-- We're doing % here because the counts per range are not equal

WITH cte_1 AS (
	SELECT tweet_length_range, COUNT(*) AS num_tweets
	FROM (
		SELECT *
		FROM twitter
		WHERE impressions > (
				SELECT AVG(impressions)
				FROM twitter)
			AND replies > (
				SELECT AVG(replies)
				FROM twitter)
			AND likes > (
				SELECT AVG(likes)
				FROM twitter)
			AND engagement_rate > (
				SELECT AVG(engagement_rate)
                FROM twitter)
			AND profile_clicks > (
				SELECT AVG(profile_clicks)
                FROM twitter)
		) sub_query
	GROUP BY 1),
	cte_2 AS (
		SELECT tweet_length_range, COUNT(*) AS total
		FROM twitter
		GROUP BY 1)
SELECT c.tweet_length_range,
ROUND(c.num_tweets / d.total,2) AS percent_of_total
FROM cte_1 c
JOIN cte_2 d
	ON c.tweet_length_range = d.tweet_length_range
GROUP BY 1
ORDER BY 2 DESC;
