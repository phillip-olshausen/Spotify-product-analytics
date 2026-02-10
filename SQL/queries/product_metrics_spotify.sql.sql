
--daily avg users
SELECT
  DATE(played_at) AS day,
  COUNT(DISTINCT user_id) AS dau
FROM plays
GROUP BY 1
ORDER BY 1;


--weekly avg users
SELECT
  DATE_TRUNC('week', played_at)::date AS week,
  COUNT(DISTINCT user_id) AS wau
FROM plays
GROUP BY 1
ORDER BY 1;

--monthly avg users
SELECT
  DATE_TRUNC('month', played_at)::date AS month,
  COUNT(DISTINCT user_id) AS mau
FROM plays
GROUP BY 1
ORDER BY 1;

--DAU/MAU
WITH dau AS (
  SELECT DATE(played_at) AS day, COUNT(DISTINCT user_id) AS dau
  FROM plays
  GROUP BY 1
),
mau AS (
  SELECT DATE_TRUNC('month', played_at)::date AS month, COUNT(DISTINCT user_id) AS mau
  FROM plays
  GROUP BY 1
)
SELECT
  d.day,
  d.dau,
  m.mau,
  d.dau::float / m.mau AS dau_mau_ratio
FROM dau d
JOIN mau m
  ON DATE_TRUNC('month', d.day) = m.month
ORDER BY d.day;

