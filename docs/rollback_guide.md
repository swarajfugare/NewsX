# Production Rollback & Emergency Recovery Guide

In the event of a critical server or database incident, follow these emergency rollback procedures.

---

## 1. Rolling Back Backend Code Deployment (PM2)
```bash
# Revert to previous PM2 process save
pm2 reload deploy/ecosystem.config.js --env production --update-env

# Or revert git commit on VPS:
git checkout HEAD~1
npm install --production
pm2 restart newsx-backend
```

---

## 2. Emergency Database Restore
```bash
# Restore latest automated backup:
./backend/scripts/restore.sh /var/backups/newsx/newsx_db_YYYYMMDD_HHMMSS.sql.gz
```

---

## 3. Flutter Mobile App Fallback Mode
If backend API becomes unresponsive, the Flutter application automatically activates its **Local Storage Cache Mode** to serve cached news reels with zero app crashes.
