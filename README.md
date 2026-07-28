# NewsX - AI Powered Smart News Platform

![NewsX Platform Banner](https://images.unsplash.com/photo-1585829365295-ab7cd400c167?q=80&w=1200&auto=format&fit=crop)

> **Tagline:** *"AI Powered Smart News"*  
> **Ecosystem:** Mobile App (Flutter) + Backend API (Node.js & Express) + Autonomous AI Engine (Gemini) + Admin Dashboard (React & Vite)

---

## 🌟 Project Overview

**NewsX** is a commercial-grade, production-ready AI news application inspired by **Instagram Reels**, **Inshorts**, **Google Discover**, and **Apple News**.

It presents news in **~25-word short, objective summaries** with an immersive vertical swipe UI. The platform operates on a completely autonomous backend pipeline that fetches RSS feeds, filters duplicate stories, parses hero images via Cheerio OpenGraph extraction, synthesizes multi-lingual summaries (**English, Hindi, Marathi**) with **Google Gemini AI**, and delivers real-time recommendations.

---

## ✨ Features Highlight

### 📱 Mobile Application (Flutter & Material 3)
- ⚡ **Read in 25 Words**: Short, objective news summaries curated by Gemini AI.
- 📱 **Full-Screen Vertical Reels**: Smooth vertical scroll inspired by Instagram Reels & Inshorts.
- 🌐 **Multi-Lingual Toggle (EN | HI | MR)**: Switch instantly between English, Hindi (हिंदी), and Marathi (मराठी) summaries directly on the news card.
- 🧠 **"Why It Matters" AI Takeaways**: Interactive glassmorphism modal explaining key impact insights.
- 🔥 **AI Personalised Feed**: Dynamic weighted recommendation engine based on user selected topics and reading affinity.
- 🔍 **Bento Grid Explore & Live Search**: Category filters, trending hashtag pills, and instant query search across stories.
- 💾 **Smart Offline Caching & Prefetching**: Instant offline reading fallback and prefetching when swiping through reels.
- 🌙 **Material 3 Design System**: Custom Slate dark mode and crisp light theme with Google Fonts (`Outfit` & `Plus Jakarta Sans`).

### 🤖 AI Processing Engine & Backend (Node.js & MySQL)
- 📡 **Modular RSS Aggregator**: Configurable `rssSources.json` covering 13 news categories (AI, Tech, Business, Sports, Cricket, World, India, Maharashtra, etc.).
- 🔍 **Duplicate Detection**: Canonical URL hashing and Jaccard title similarity algorithms.
- 🖼️ **Cheerio Image Scraper**: OpenGraph (`og:image`) & Twitter Card meta tag extractor.
- 🤖 **Google Gemini 1.5 Synthesis**: Structured JSON output generating 25-word summaries, translations, sentiment scores, and tags.
- 📊 **Dynamic Trending Score Algorithm**: Time decay formula: `Score = (Likes*2 + Shares*3 + Importance*4) / (AgeInHours + 2)^1.5`.
- ⏱️ **Node-Cron Background Automation**: Runs RSS ingestion and AI processing jobs every 5–10 minutes.

### 📊 Admin Console (React, TypeScript & Material UI)
- 🔑 **JWT & Role-Based Access Control**: Super Admin, Editor, Moderator.
- 📈 **Telemetry & Analytics**: DAU/MAU user activity metrics, server health telemetry, and Gemini API token consumption.
- 📰 **News & RSS Management**: Create manual news reels, feature breaking stories, add new RSS feeds, and trigger instant manual sync.
- 🔔 **Broadcast Push Notifications**: Schedule category and breaking news alerts.

---

## 🏛️ System Architecture

```
                               ┌───────────────────────────────────┐
                               │     Flutter Mobile App (iOS/Android)│
                               └─────────────────┬─────────────────┘
                                                 │ HTTP REST (Dio Client)
                                                 ▼
┌──────────────────────────────────────────────────────────────────────────────────┐
│                             NGINX Reverse Proxy + SSL                            │
└────────────────────────────────────────┬─────────────────────────────────────────┘
                                         │
                   ┌─────────────────────┴─────────────────────┐
                   ▼                                           ▼
┌──────────────────────────────────────┐     ┌──────────────────────────────────┐
│  React + Vite Admin Console (Port 3000)│     │  Express Node.js Backend API     │
└──────────────────────────────────────┘     └─────────────────┬────────────────┘
                                                               │
                               ┌───────────────────────────────┼───────────────────────────────┐
                               ▼                               ▼                               ▼
                     ┌───────────────────┐           ┌───────────────────┐           ┌───────────────────┐
                     │ MySQL Hostinger DB│           │  Google Gemini AI │           │ Node-Cron Worker  │
                     └───────────────────┘           └───────────────────┘           └───────────────────┘
```

---

## 🛠️ Technology Stack

| Layer | Technologies Used |
| :--- | :--- |
| **Mobile App** | Flutter 3.x, Dart 3.x, Riverpod, GoRouter, Dio, Google Fonts, CachedNetworkImage, Flutter Animate |
| **Backend API** | Node.js (LTS), Express.js, MySQL 8.0, Helmet, Express Rate Limit, JWT, bcryptjs |
| **AI & Aggregator** | Google Gemini 1.5 Flash API, rss-parser, cheerio, axios, node-cron |
| **Admin Panel** | React 18, Vite, TypeScript, Material UI (MUI), TanStack Query, Lucide Icons |
| **DevOps & Infra** | Hostinger VPS, Ubuntu, NGINX, PM2, Docker, Docker Compose, GitHub Actions |

---

## 📂 Project Structure

```
News Pro/
├── lib/                           # Flutter Cross-Platform Mobile Code
│   ├── core/                      # Constants, theme, router, network client, widgets
│   ├── models/                    # Data models (NewsArticle, UserProfile)
│   ├── providers/                 # Riverpod state providers
│   ├── repositories/              # Repository layer for API & Offline cache
│   ├── features/                  # Screen presentations (Splash, Home, Explore, Search, Bookmarks, Profile, Settings)
│   ├── app.dart                   # Root MaterialApp config
│   └── main.dart                  # Application entry point
├── backend/                       # Express.js REST API Backend
│   ├── src/
│   │   ├── config/                # Database pool, env, RSS sources config, Redis cache
│   │   ├── controllers/           # Auth, User, News, Bookmarks, Likes, History, Admin
│   │   ├── routes/                # Express API router gateways
│   │   ├── middlewares/           # JWT Auth guard, Rate Limiter, Helmet, Error handler
│   │   ├── services/              # RSS, Deduplication, Cheerio Image Extractor, Gemini AI
│   │   ├── database/              # SQL DDL migrations and database seeders
│   │   ├── cron/                  # Node-Cron background workers
│   │   └── server.js              # Express server entry point
│   ├── deploy/                    # NGINX reverse proxy & PM2 ecosystem configs
│   ├── scripts/                   # Automated backup & restore bash scripts
│   └── package.json
├── admin/                         # React + Vite + TypeScript Admin Panel
│   ├── src/
│   │   ├── components/            # Sidebar, Header, Reusable layout widgets
│   │   ├── pages/                 # Dashboard, News, Categories, RSS, AI, Users, Notifications, Login
│   │   ├── services/              # Admin Axios API bindings
│   │   └── App.tsx
│   ├── package.json
│   └── vite.config.ts
├── android/                       # Android release build & ProGuard configs
├── docs/                          # Deployment, Play Store listing, Privacy Policy & User Manuals
├── docker-compose.yml             # Docker Multi-Container Configuration
├── .github/workflows/ci-cd.yml    # GitHub Actions CI/CD Pipeline
├── .env.example                   # Environment configuration template
└── README.md                      # Global Documentation
```

---

## 🚀 Setup & Execution Guide

### 1. Backend Server Setup
```bash
cd backend
npm install
cp .env.example .env

# Configure your MySQL credentials in .env and run database migrations & seeders:
npm run seed
npm run migrate:phase3

# Start development server on port 5000:
npm run dev
```

### 2. React Admin Panel Setup
```bash
cd admin
npm install

# Start Vite admin development server on port 3000:
npm run dev
```

### 3. Flutter Mobile App Setup
```bash
# In the root workspace directory:
flutter pub get
flutter run
```

---

## 📋 Environment Variables (`.env.example`)

Copy `.env.example` to `.env` in the `backend/` directory:

```env
PORT=5000
NODE_ENV=development
API_PREFIX=/api/v1

# MySQL Hostinger Database Configuration
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=
DB_NAME=newsx_db

# Security & JWT Tokens
JWT_SECRET=newsx_super_secret_jwt_key_2026_production
JWT_EXPIRES_IN=7d

# Google Gemini AI Key
GEMINI_API_KEY=YOUR_GEMINI_API_KEY_HERE
GEMINI_MODEL=gemini-1.5-flash

# Background Cron Schedules
CRON_RSS_SCHEDULE=*/10 * * * *
CRON_AI_SCHEDULE=*/5 * * * *
```

---

## 📄 License & Contribution

- **License**: MIT License  
- **Contributions**: Pull requests are welcome! Please ensure all Flutter analyze and backend test checks pass prior to submitting.
