#!/bin/bash
# Automated MySQL & Asset Backup Script for NewsX
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_DIR="/var/backups/newsx"
DB_NAME="newsx_db"
DB_USER="root"
DB_PASS=""

mkdir -p $BACKUP_DIR

echo "[$(date)] Starting Automated MySQL Backup..."
mysqldump -u $DB_USER -p$DB_PASS $DB_NAME | gzip > "$BACKUP_DIR/newsx_db_$TIMESTAMP.sql.gz"

echo "[$(date)] Removing backups older than 14 days..."
find $BACKUP_DIR -type f -name "*.sql.gz" -mtime +14 -exec rm {} \;

echo "[$(date)] Backup Completed: $BACKUP_DIR/newsx_db_$TIMESTAMP.sql.gz"
