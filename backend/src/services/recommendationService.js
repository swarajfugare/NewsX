const { query } = require('../config/database');
const logger = require('../utils/logger');

class RecommendationService {
  static async getPersonalisedFeed(userId, limit = 40, offset = 0) {
    try {
      // 1. Fetch User Preferences Categories
      const prefs = await query(`SELECT category FROM preferences WHERE user_id = ? AND enabled = 1`, [userId]);
      const preferredCategories = prefs.map(p => p.category);

      // 2. Fetch Categories from User Liked News
      const likes = await query(
        `SELECT DISTINCT n.category FROM likes l JOIN news_articles n ON l.news_id = n.id WHERE l.user_id = ?`,
        [userId]
      );
      const likedCategories = likes.map(l => l.category);

      // Combine user affinity topics
      const affinityTopics = [...new Set([...preferredCategories, ...likedCategories])];

      let sql = `SELECT n.* FROM news_articles n WHERE n.status = 'processed'`;
      const params = [];

      if (affinityTopics.length > 0) {
        // Boost score for articles matching user affinity topics
        const placeholders = affinityTopics.map(() => '?').join(',');
        sql = `
          SELECT n.*, 
            (CASE WHEN n.category IN (${placeholders}) OR n.category_ai IN (${placeholders}) THEN 50 ELSE 0 END + n.trending_score * 5) AS affinity_score
          FROM news_articles n
          WHERE n.status = 'processed'
          ORDER BY affinity_score DESC, n.published_at DESC
          LIMIT ? OFFSET ?
        `;
        params.push(...affinityTopics, ...affinityTopics, parseInt(limit), parseInt(offset));
      } else {
        sql += ` ORDER BY n.trending_score DESC, n.published_at DESC LIMIT ? OFFSET ?`;
        params.push(parseInt(limit), parseInt(offset));
      }

      return query(sql, params);
    } catch (err) {
      logger.error(`Recommendation Engine Error: ${err.message}`);
      return query(`SELECT * FROM news_articles WHERE status = 'processed' ORDER BY published_at DESC LIMIT ? OFFSET ?`, [parseInt(limit), parseInt(offset)]);
    }
  }

  static async getDailyDigest(userId) {
    // Curate 5 diverse top-importance stories for morning briefing
    return query(
      `SELECT * FROM news_articles WHERE status = 'processed' ORDER BY importance_score DESC, published_at DESC LIMIT 5`
    );
  }

  static async getTrendingTopics() {
    // Extract top active tags across recent articles
    const rows = await query(
      `SELECT tags FROM news_articles WHERE status = 'processed' ORDER BY published_at DESC LIMIT 30`
    );
    const tagCount = {};
    for (const row of rows) {
      try {
        const tagsArr = typeof row.tags === 'string' ? JSON.parse(row.tags) : row.tags;
        if (Array.isArray(tagsArr)) {
          for (const t of tagsArr) {
            tagCount[t] = (tagCount[t] || 0) + 1;
          }
        }
      } catch (_) {}
    }

    const sortedTags = Object.keys(tagCount).sort((a, b) => tagCount[b] - tagCount[a]);
    return sortedTags.slice(0, 10);
  }
}

module.exports = RecommendationService;
