# RSS Feed Configuration Guide

NewsX features a modular RSS source manager stored in `backend/src/config/rssSources.json`.

---

## ➕ Adding a New RSS Feed

To add a new RSS source without modifying any code, add a new JSON object to `backend/src/config/rssSources.json`:

```json
{
  "category": "Maharashtra",
  "name": "Lokmat News",
  "url": "https://www.lokmat.com/rss/maharashtra.xml"
}
```

### Supported Categories:
- Politics
- Business
- Technology
- Sports
- Entertainment
- Health
- Science
- World
- Education
- India
- Maharashtra
- Startup
- AI
