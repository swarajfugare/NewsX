# Production Maintenance Playbook

Guide for routine server maintenance, database log rotations, and monitoring.

---

## 🔍 System Health Check
Check health telemetry API:
```bash
curl -X GET http://localhost:5000/api/v1/health/detailed
```

---

## 🧹 Database Maintenance
Run monthly database table optimization:
```sql
OPTIMIZE TABLE news_articles, users, bookmarks, likes, history, preferences;
```

---

## 📋 PM2 Process Monitoring
```bash
pm2 status
pm2 logs newsx-backend --lines 100
pm2 monit
```
