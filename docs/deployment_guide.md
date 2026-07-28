# Production Hostinger VPS Deployment Guide

Step-by-step guide to deploying the NewsX backend server and React Admin Panel on Ubuntu / Hostinger VPS.

---

## 1. Prerequisites
- Hostinger Ubuntu 22.04 / 24.04 VPS server.
- Domain names pointed to your VPS IP:
  - `api.newsx.ai` -> Backend API
  - `admin.newsx.ai` -> Admin Panel

---

## 2. Server Setup & Dependencies
```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y nodejs npm mysql-server nginx certbot python3-certbot-nginx
sudo npm install -g pm2
```

---

## 3. Database Migration
```bash
mysql -u root -p < backend/src/database/migrations/schema.sql
mysql -u root -p < backend/src/database/migrations/schema_phase3.sql
mysql -u root -p < backend/src/database/migrations/schema_phase6.sql
```

---

## 4. Backend Deployment via PM2
```bash
cd backend
npm install --production
pm2 start deploy/ecosystem.config.js --env production
pm2 save
pm2 startup
```

---

## 5. React Admin Panel Deployment
```bash
cd admin
npm install
npm run build
sudo mkdir -p /var/www/newsx/admin
sudo cp -r dist/* /var/www/newsx/admin/
```

---

## 6. NGINX Reverse Proxy & SSL Setup
```bash
sudo cp backend/deploy/nginx.conf /etc/nginx/sites-available/newsx.conf
sudo ln -s /etc/nginx/sites-available/newsx.conf /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx

# Install Free Let's Encrypt SSL
sudo certbot --nginx -d api.newsx.ai -d admin.newsx.ai
```
