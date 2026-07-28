#!/bin/bash
# Disaster Recovery Restore Script for NewsX
if [ -z "$1" ]; then
  echo "Usage: ./restore.sh /path/to/backup.sql.gz"
  exit 1
fi

BACKUP_FILE=$1
DB_NAME="newsx_db"
DB_USER="root"
DB_PASS=""

echo "[$(date)] Restoring Database from $BACKUP_FILE..."
gunzip -c $BACKUP_FILE | mysql -u $DB_USER -p$DB_PASS $DB_NAME

echo "[$(date)] Restore Completed Successfully."
