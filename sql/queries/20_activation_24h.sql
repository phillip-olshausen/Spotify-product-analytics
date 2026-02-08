-- Activation rate: first play within 24h of start date
-- Start date proxy: signup_date if present, otherwise first-seen date (min played_at).

WITH user_start AS (
  SELECT
    u.user_id,
    COALESCE(u.signup_date, MIN(p.played_at)::date) AS start_date
  FROM users u
  JOIN plays p ON p.user_id = u.user_id
  GROUP BY 1, u.signup_date
),
first_play AS (
  SELECT user_id, MIN(played_at) AS first_play_time
  FROM plays
  GROUP BY 1
)
SELECT
  COUNT(*) FILTER (
    WHERE fp.first_play_time <= us.start_date + INTERVAL '1 day'
  )::float / COUNT(*) AS activation_rate_24h
FROM user_start us
JOIN first_play fp USING (user_id);
