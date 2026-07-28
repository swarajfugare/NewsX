const { query } = require('../../config/database');
const logger = require('../../utils/logger');

const runIndexMigration = async () => {
  try {
    logger.info('Optimizing Database Queries: Creating Composite Indexes...');

    const indexes = [
      `CREATE INDEX idx_news_status_pub ON news_articles (status, published_at DESC)`,
      `CREATE INDEX idx_news_cat_status ON news_articles (category, status, published_at DESC)`,
      `CREATE INDEX idx_news_trending ON news_articles (trending_score DESC, published_at DESC)`,
      `CREATE INDEX idx_bookmarks_user ON bookmarks (user_id, created_at DESC)`,
      `CREATE INDEX idx_likes_user ON likes (user_id, created_at DESC)`,
      `CREATE INDEX idx_history_user ON history (user_id, opened_at DESC)`,
    ];

    for (const idxSql of indexes) {
      try {
        await query(idxSql);
      } catch (_) {
        // Ignore index already exists error
      }
    }

    logger.info('Composite Index Optimization Completed Successfully.');
  } catch (err) {
    logger.error(`Index Migration Error: ${err.message}`);
  }
};

if (require.main === module) {
  runIndexMigration();
}

module.exports = runIndexMigration;
