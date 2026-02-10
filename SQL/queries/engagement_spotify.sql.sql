
--active daily users
WITH daily_sessions AS (
  SELECT
    DATE(session_start) AS day,
    user_id,
    COUNT(*) AS sessions
  FROM sessions
  GROUP BY 1, 2
)
SELECT
  day,
  AVG(sessions) AS avg_sessions_per_active_user
FROM daily_sessions
GROUP BY 1
ORDER BY 1;

--dist. of sessions per user
SELECT
  sessions,
  COUNT(*) AS user_days
FROM (
  SELECT
    DATE(session_start) AS day,
    user_id,
    COUNT(*) AS sessions
  FROM sessions
  GROUP BY 1,2
) t
GROUP BY sessions
ORDER BY sessions;
