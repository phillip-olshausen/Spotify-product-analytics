-- 02_build_sessions.sql
-- Sessionize plays using a 30-minute inactivity gap rule.

TRUNCATE sessions;

WITH ordered AS (
  SELECT
    user_id,
    played_at,
    LAG(played_at) OVER (PARTITION BY user_id ORDER BY played_at) AS prev_time
  FROM plays
),
marks AS (
  SELECT
    user_id,
    played_at,
    CASE
      WHEN prev_time IS NULL THEN 1
      WHEN played_at - prev_time > INTERVAL '30 minutes' THEN 1
      ELSE 0
    END AS new_session
  FROM ordered
),
sessionized AS (
  SELECT
    user_id,
    played_at,
    SUM(new_session) OVER (PARTITION BY user_id ORDER BY played_at) AS session_num
  FROM marks
)
INSERT INTO sessions(user_id, session_start, session_end, play_count)
SELECT
  user_id,
  MIN(played_at) AS session_start,
  MAX(played_at) AS session_end,
  COUNT(*)       AS play_count
FROM sessionized
GROUP BY user_id, session_num;
