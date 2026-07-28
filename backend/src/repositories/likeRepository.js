const { query } = require('../config/database');

class LikeRepository {
  static async addLike(userId, newsId) {
    await query(`INSERT IGNORE INTO likes (user_id, news_id) VALUES (?, ?)`, [userId, newsId]);
    await query(`UPDATE news_articles SET likes_count = likes_count + 1 WHERE id = ?`, [newsId]);
    return { userId, newsId, liked: true };
  }

  static async removeLike(userId, newsId) {
    const res = await query(`DELETE FROM likes WHERE user_id = ? AND news_id = ?`, [userId, newsId]);
    if (res.affectedRows > 0) {
      await query(`UPDATE news_articles SET likes_count = GREATEST(0, likes_count - 1) WHERE id = ?`, [newsId]);
    }
    return { userId, newsId, liked: false };
  }

  static async addShare(userId, newsId) {
    await query(`INSERT INTO shares (user_id, news_id) VALUES (?, ?)`, [userId, newsId]);
    await query(`UPDATE news_articles SET shares_count = shares_count + 1 WHERE id = ?`, [newsId]);
    return { userId, newsId, shared: true };
  }
}

module.exports = LikeRepository;
