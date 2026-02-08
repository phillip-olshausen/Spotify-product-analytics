-- Save-rate proxy: share of active users with at least one "saved" track
WITH active_users AS (SELECT DISTINCT user_id FROM plays),
savers AS (SELECT DISTINCT user_id FROM saves)
SELECT
  (SELECT COUNT(*) FROM savers)::float / (SELECT COUNT(*) FROM active_users) AS user_save_rate_proxy;
