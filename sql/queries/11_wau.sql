-- WAU (Weekly Active Users)
SELECT
  DATE_TRUNC('week', played_at)::date AS week,
  COUNT(DISTINCT user_id) AS wau
FROM plays
GROUP BY 1
ORDER BY 1;
