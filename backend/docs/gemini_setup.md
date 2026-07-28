# Google Gemini AI Setup Guide

NewsX utilizes **Google Gemini 1.5 Flash** for synthesizing ~25-word English summaries, Marathi/Hindi translations, sentiment analysis, and key takeaways.

---

## 🔑 Obtaining Gemini API Key

1. Go to [Google AI Studio](https://aistudio.google.com/).
2. Sign in with your Google account.
3. Click **Get API Key** and generate a new key.
4. Open `backend/.env` and update the key:
   ```env
   GEMINI_API_KEY=AIzaSyYourActualGeminiKeyHere...
   GEMINI_MODEL=gemini-1.5-flash
   ```

---

## 🔄 Automatic Fallback Handling

If `GEMINI_API_KEY` is omitted or encounters rate limits (429), the NewsX engine automatically activates a high-speed fallback synthesis generator to ensure zero service disruption.
