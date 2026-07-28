# Background Cron Workers & Jobs Guide

NewsX uses `node-cron` to execute automated background tasks.

---

## ⚙️ Cron Schedules (`.env`)

```env
CRON_RSS_SCHEDULE=*/10 * * * *      # Runs RSS Ingestion every 10 mins
CRON_AI_SCHEDULE=*/5 * * * *        # Synthesizes pending AI articles every 5 mins
CRON_TRENDING_SCHEDULE=0 * * * *    # Recalculates trending scores every hour
```

---

## 🛠️ Manual Ingestion & Status Trigger APIs

- **Manual Trigger**: `POST /api/v1/admin/rss/refresh`
- **Job Status**: `GET /api/v1/admin/jobs/status`
