-- 01_schema.sql
-- Create core tables + derived tables for Spotify-style product analytics

DROP TABLE IF EXISTS saves;
DROP TABLE IF EXISTS sessions;
DROP TABLE IF EXISTS plays;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
  user_id      TEXT PRIMARY KEY,
  signup_date  DATE NULL,
  country      TEXT NULL,
  plan         TEXT NULL,
  gender       TEXT NULL,
  age          INT NULL
);

CREATE TABLE plays (
  play_id     BIGSERIAL PRIMARY KEY,
  user_id     TEXT NOT NULL REFERENCES users(user_id),
  played_at   TIMESTAMPTZ NOT NULL,
  artist_id   TEXT NULL,
  artist_name TEXT NULL,
  track_id    TEXT NULL,
  track_name  TEXT NULL,
  split       TEXT NULL
);

-- Derived: sessions inferred from play gaps
CREATE TABLE sessions (
  session_id     BIGSERIAL PRIMARY KEY,
  user_id        TEXT NOT NULL REFERENCES users(user_id),
  session_start  TIMESTAMPTZ NOT NULL,
  session_end    TIMESTAMPTZ NOT NULL,
  play_count     INT NOT NULL
);

-- Derived: "save" proxy (tracks listened >= N times)
CREATE TABLE saves (
  user_id   TEXT NOT NULL REFERENCES users(user_id),
  track_id  TEXT NOT NULL,
  saved_at  TIMESTAMPTZ NOT NULL,
  PRIMARY KEY (user_id, track_id)
);

-- Helpful indexes
CREATE INDEX idx_plays_user_time ON plays(user_id, played_at);
CREATE INDEX idx_plays_time ON plays(played_at);
CREATE INDEX idx_plays_track ON plays(track_id);
