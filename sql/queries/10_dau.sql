-- DAU (Daily Active Users)
SELECT
  DATE(played_at) AS day,
  COUNT(DISTINCT user_id) AS dau
FROM plays
GROUP BY 1
ORDER BY 1;
