# NewsX Admin Panel User Manual

The **NewsX Admin Panel** provides a complete console to monitor telemetry, manage news reels, configure RSS sources, and inspect AI token consumption.

---

## 🔑 Accessing the Admin Console
- **URL**: `https://admin.newsx.ai` (or `http://localhost:3000` locally)
- **Default Credentials**: `admin@newsx.ai` / `admin123`

---

## 📊 Modules & Usage

### 1. Dashboard
- View DAU/MAU user activity stats.
- System Telemetry indicators for MySQL pool, PM2 Node processes, and Gemini API.

### 2. News Manager
- Edit titles, summaries, or feature breaking news.
- Create manual news reels with custom image URLs.

### 3. RSS Feeds Manager
- Add or disable RSS source URLs dynamically.
- Click **Sync All RSS Now** to force immediate article ingestion.

### 4. AI Engine Telemetry
- Monitor total daily Gemini API requests and latency metrics.
- Track estimated daily API costs.

### 5. Push Notifications
- Compose and broadcast global breaking news push alerts to mobile subscribers.
