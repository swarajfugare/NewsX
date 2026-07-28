const { query } = require('../../config/database');
const logger = require('../../utils/logger');

const runPhase3Migration = async () => {
  try {
    logger.info('Running Phase 3 Database Schema Migrations...');

    const columns = [
      `ADD COLUMN summary_mr TEXT DEFAULT NULL`,
      `ADD COLUMN summary_hi TEXT DEFAULT NULL`,
      `ADD COLUMN category_ai VARCHAR(50) DEFAULT NULL`,
      `ADD COLUMN tags JSON DEFAULT NULL`,
      `ADD COLUMN keywords JSON DEFAULT NULL`,
      `ADD COLUMN sentiment VARCHAR(20) DEFAULT 'Neutral'`,
      `ADD COLUMN importance_score INT DEFAULT 5`,
      `ADD COLUMN why_it_matters TEXT DEFAULT NULL`,
      `ADD COLUMN related_topics JSON DEFAULT NULL`,
      `ADD COLUMN source_name VARCHAR(100) DEFAULT NULL`,
      `ADD COLUMN canonical_url TEXT DEFAULT NULL`,
      `ADD COLUMN status ENUM('pending', 'processed', 'failed') DEFAULT 'pending'`,
      `ADD COLUMN processed_at TIMESTAMP NULL DEFAULT NULL`,
      `ADD COLUMN trending_score FLOAT DEFAULT 0.0`,
    ];

    for (const col of columns) {
      try {
        await query(`ALTER TABLE news_articles ${col}`);
      } catch (e) {
        // Ignore column already exists errors
      }
    }

    logger.info('Phase 3 Migrations Completed Successfully.');
  } catch (err) {
    logger.error(`Migration error: ${err.message}`);
  }
};

if (require.main === module) {
  runPhase3Migration();
}

module.exports = runPhase3Migration;
