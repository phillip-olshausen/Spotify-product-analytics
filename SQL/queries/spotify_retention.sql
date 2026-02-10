-- D1/D7/D30 retention 
WITH cohort AS (
  SELECT
    u.user_id,
    COALESCE(u.signup_date, MIN(p.played_at)::date) AS cohort_date
  FROM users u
  JOIN plays p ON p.user_id = u.user_id
  GROUP BY 1, u.signup_date
),
activity AS (
  SELECT DISTINCT
    c.user_id,
    (DATE(p.played_at) - c.cohort_date) AS days_since
  FROM cohort c
  JOIN plays p ON p.user_id = c.user_id
)
SELECT
  days_since,
  COUNT(DISTINCT user_id) AS retained_users
FROM activity
WHERE days_since IN (1, 7, 30)
GROUP BY 1
ORDER BY 1;

-- retention rates
WITH cohort AS (
  SELECT
    u.user_id,
    COALESCE(u.signup_date, MIN(p.played_at)::date) AS cohort_date
  FROM users u
  JOIN plays p ON p.user_id = u.user_id
  GROUP BY 1, u.signup_date
),
cohort_size AS (
  SELECT
    cohort_date,
    COUNT(DISTINCT user_id) AS users
  FROM cohort
  GROUP BY 1
),
activity AS (
  SELECT DISTINCT
    c.user_id,
    c.cohort_date,
    (DATE(p.played_at) - c.cohort_date) AS days_since
  FROM cohort c
  JOIN plays p ON p.user_id = c.user_id
)
SELECT
  a.days_since,
  COUNT(DISTINCT a.user_id)::float / SUM(cs.users) AS retention_rate
FROM activity a
JOIN cohort_size cs USING (cohort_date)
WHERE a.days_since IN (1, 7, 30)
GROUP BY a.days_since
ORDER BY a.days_since;
