-- 03_build_saves_proxy.sql
-- Build a "save" proxy: user-track pairs listened >= N times.
-- Default threshold: 5
-- Change the value in the WHERE clause if desired.

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
INSERT INTO saves(user_id, track_id, saved_at)
SELECT user_id, track_id, first_listen
FROM counts
WHERE n_listens >= 5;
