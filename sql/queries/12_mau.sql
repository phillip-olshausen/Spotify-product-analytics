-- MAU (Monthly Active Users)
SELECT
  DATE_TRUNC('month', played_at)::date AS month,
  COUNT(DISTINCT user_id) AS mau
FROM plays
GROUP BY 1
ORDER BY 1;
