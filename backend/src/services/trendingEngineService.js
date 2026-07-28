const { query } = require('../config/database');
const logger = require('../utils/logger');

class TrendingEngineService {
  static async recalculateTrendingScores() {
    try {
      logger.info('Recalculating News Article Trending Scores...');
      const articles = await query(
        `SELECT id, likes_count, shares_count, comments_count, importance_score, published_at FROM news_articles WHERE status = 'processed'`
      );

      const now = new Date();
      for (const article of articles) {
        const publishedDate = new Date(article.published_at);
        const ageInHours = Math.max(0.5, (now - publishedDate) / (1000 * 60 * 60));
        
        const importance = article.importance_score || 5;
        // Formula incorporating engagement, importance score, and age decay
        const score = (article.likes_count * 2 + article.shares_count * 3 + article.comments_count + importance * 4) / Math.pow(ageInHours + 2, 1.5);

        await query(`UPDATE news_articles SET trending_score = ? WHERE id = ?`, [score, article.id]);
      }
      logger.info('Trending Scores Recalculated Successfully.');
    } catch (err) {
      logger.error(`Trending Engine Error: ${err.message}`);
    }
  }
}

module.exports = TrendingEngineService;
