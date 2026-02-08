-- Engagement depth proxy: sessions per active user (daily)
WITH daily_sessions AS (
  SELECT DATE(session_start) AS day, user_id, COUNT(*) AS sessions
  FROM sessions
  GROUP BY 1,2
)
SELECT
  day,
  AVG(sessions) AS avg_sessions_per_active_user
FROM daily_sessions
GROUP BY 1
ORDER BY 1;
