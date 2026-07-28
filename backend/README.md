# NewsX Backend - Node.js & Express API

Production-ready, highly secure REST API server designed for **NewsX - AI Powered Smart News App**.

---

## ⚡ Quick Start

```bash
cd backend
npm install
npm run seed  # Seed initial categories & news articles
npm run dev   # Start development server on port 5000
```

---

## 🔒 Security Summary

- **Helmet**: Protection against XSS, clickjacking, MIME sniffing.
- **Rate Limiting**: IP rate limits to mitigate brute-force and DDoS attacks.
- **MySQL Injection Immunity**: Parameterized SQL queries via `mysql2/promise`.
- **JWT Protection**: Signed authentication tokens with refresh strategy.

---

## 🗄️ Hostinger MySQL Database Deployment Guide

1. Log into your Hostinger cPanel / hPanel dashboard.
2. Go to **MySQL Databases** and create a database named `newsx_db`.
3. Open **phpMyAdmin**, select `newsx_db`, and import `src/database/migrations/schema.sql`.
4. Update `.env` with your Hostinger database host, user, password, and port.
5. Execute `npm run seed` to populate initial data.
