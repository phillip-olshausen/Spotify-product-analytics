
--sessions that sorts plays per user time
--new session if >30min gap
TRUNCATE sessions;

WITH ordered AS (
  SELECT
    user_id,
    played_at,
    LAG(played_at) OVER (
      PARTITION BY user_id
      ORDER BY played_at
    ) AS prev_time
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
    SUM(new_session) OVER (
      PARTITION BY user_id
      ORDER BY played_at
    ) AS session_num
  FROM marks
)
INSERT INTO sessions (user_id, session_start, session_end, play_count)
SELECT
  user_id,
  MIN(played_at) AS session_start,
  MAX(played_at) AS session_end,
  COUNT(*)       AS play_count
FROM sessionized
GROUP BY user_id, session_num;

--sanity check to see if sessions are built
SELECT COUNT(*) FROM sessions;
SELECT * FROM sessions LIMIT 5;

--create proxy that recreates a "save" at more than 5 listens
TRUNCATE saves;

WITH counts AS (
  SELECT
    user_id,
    track_id,
    COUNT(*) AS n_listens,
    MIN(played_at) AS first_listen
  FROM plays
  WHERE track_id IS NOT NULL
  GROUP BY 1,2
)
INSERT INTO saves (user_id, track_id, saved_at)
SELECT
  user_id,
  track_id,
  first_listen
FROM counts
WHERE n_listens >= 5;

--sanity check for proxy to see if sessions are built
SELECT COUNT(*) FROM saves;
SELECT * FROM saves LIMIT 5;


