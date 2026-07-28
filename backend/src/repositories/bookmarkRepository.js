const { query } = require('../config/database');

class BookmarkRepository {
  static async getByUserId(userId) {
    return query(
      `SELECT b.id, b.news_id, b.created_at, n.title, n.summary, n.image_url, n.category, n.author, n.published_at 
       FROM bookmarks b 
       JOIN news_articles n ON b.news_id = n.id 
       WHERE b.user_id = ? ORDER BY b.created_at DESC`,
      [userId]
    );
  }

  static async addBookmark(userId, newsId) {
    await query(
      `INSERT IGNORE INTO bookmarks (user_id, news_id) VALUES (?, ?)`,
      [userId, newsId]
    );
    return { userId, newsId, isBookmarked: true };
  }

  static async removeBookmark(userId, newsId) {
    await query(`DELETE FROM bookmarks WHERE user_id = ? AND news_id = ?`, [userId, newsId]);
    return { userId, newsId, isBookmarked: false };
  }
}

module.exports = BookmarkRepository;
