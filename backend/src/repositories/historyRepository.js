const { query } = require('../config/database');

class HistoryRepository {
  static async logReadingHistory(userId, newsId, readingTime = '1 min') {
    await query(
      `INSERT INTO history (user_id, news_id, reading_time) VALUES (?, ?, ?)`,
      [userId, newsId, readingTime]
    );
    return { userId, newsId, readingTime };
  }

  static async getHistoryByUserId(userId) {
    return query(
      `SELECT h.id, h.news_id, h.reading_time, h.opened_at, n.title, n.category, n.image_url 
       FROM history h 
       JOIN news_articles n ON h.news_id = n.id 
       WHERE h.user_id = ? ORDER BY h.opened_at DESC LIMIT 20`,
      [userId]
    );
  }
}

module.exports = HistoryRepository;
