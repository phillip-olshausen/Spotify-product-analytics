
(https://github.com/user-attachments/files/25210566/README.7.md)
# Spotify-Style Product Analytics (SQL + Tableau)

This project demonstrates a **SQL-first product analytics workflow** inspired by how music-streaming products (e.g. Spotify) measure engagement, activation, retention, and depth of usage.

Raw listening events are transformed into **interpretable product metrics** using PostgreSQL.  
Final metrics are then visualized in **Tableau Public** to communicate insights clearly.

---

## Project overview

**Goal:**  
Analyze user engagement and retention for a music-streaming platform using realistic product analytics metrics.

**Key questions answered:**
- Are users active over time? (DAU / WAU / MAU)
- Do new users reach value quickly? (24h activation)
- Do users come back? (D1 / D7 / D30 retention)
- How deeply do users engage when active? (sessions per user)

---

## Tech stack

- **PostgreSQL** — core metric computation (SQL-first)
- **Python** — lightweight preprocessing & CSV export
- **Tableau Public** — stakeholder-facing visualization
- **DBeaver** — database exploration & CSV export

---

## Repository structure

```
.
├── python/
│   └── data_preprocessing.py
│
├── sql/
│   ├── schema_and_derived_tables.sql
│   └── queries/
│       ├── active_users.sql
│       ├── activation_24h.sql
│       ├── retention.sql
│       └── engagement_depth.sql
│
├── tableau_graphics/
│   └── dau_wau_mau.png
│
└── README.md
```

---

## Data & preprocessing (`python/`)

Python is used **only** for:
- loading the raw dataset
- basic cleaning
- exporting CSVs for ingestion into PostgreSQL

All business logic and metrics are computed in SQL.  
This mirrors real analytics pipelines where Python handles ingestion and SQL handles analysis.

---

## SQL analytics layer (`sql/`)

All core product logic lives in PostgreSQL.

### Schema & derived tables
The file `schema_and_derived_tables.sql` defines:
- base tables (`users`, `plays`)
- derived tables:
  - `sessions` — inferred using a 30-minute inactivity rule
  - `saves` — proxy signal based on repeated listens

### Metric queries (`sql/queries/`)

Each query produces a **final, visualization-ready metric table**:

- **Active users**
  - DAU / WAU / MAU
- **Activation**
  - % of users with first play within 24 hours
- **Retention**
  - D1 / D7 / D30 cohort-based retention
- **Engagement depth**
  - Average sessions per active user per day

These queries are intentionally simple, explicit, and reproducible.

---

## Tableau visualization layer (`tableau_graphics/`)

Metrics computed in SQL are exported as CSVs and visualized in **Tableau Public**.

> Tableau Public does not support direct PostgreSQL connections, so final metric tables are exported and used as data sources.  
> This keeps all business logic in SQL and Tableau focused purely on communication.

### Example: User engagement over time

![DAU / WAU / MAU](tableau_graphics/dau_wau_mau.png)

This chart shows daily, weekly, and monthly active users to illustrate:
- usage rhythm
- relative engagement scale
- overall active user base

Additional dashboards (activation, retention, engagement depth) follow the same pattern.

---

## Key assumptions & proxies

To reflect real-world constraints, the following assumptions are used:

- **Activation**: a user is considered activated if they play a track within 24h of signup (or first-seen date if signup is missing)
- **Retention**: cohort-based, measured at D1 / D7 / D30
- **Sessions**: inferred using a 30-minute inactivity threshold
- **Saves**: proxied via repeated listens due to missing explicit “like” events

All assumptions are documented and intentionally conservative.

---

## Why this project

This project is designed to mirror **real product analytics work**, not academic exercises:
- SQL-first metric definitions
- Clear separation between computation and visualization
- Focus on interpretable, decision-relevant KPIs
- No over-engineering or black-box modeling

It reflects how analytics teams communicate product health to stakeholders.

---

## Potential extensions

- Retention segmented by geography or activity level
- Funnel analysis (signup → first play → repeat play)
- Cohort heatmaps in Tableau
- Playlist- or artist-level engagement analysis

---

## Author

Phillip Olshausen  
Master’s student — Quantitative Finance & Data Science  
Focus: data science, product analytics, and music-related applications
