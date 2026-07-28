const { query } = require('../config/database');

class NewsRepository {
  static async searchArticles({ keyword, category, language, limit = 40, offset = 0 }) {
    let sql = `SELECT * FROM news_articles WHERE 1=1`;
    const params = [];

    if (keyword) {
      sql += ` AND (LOWER(title) LIKE ? OR LOWER(summary) LIKE ? OR LOWER(author) LIKE ?)`;
      const term = `%${keyword.toLowerCase()}%`;
      params.push(term, term, term);
    }

    if (category && category !== 'All') {
      sql += ` AND category = ?`;
      params.push(category);
    }

    if (language) {
      sql += ` AND language = ?`;
      params.push(language);
    }

    sql += ` ORDER BY published_at DESC LIMIT ? OFFSET ?`;
    params.push(parseInt(limit), parseInt(offset));

    return query(sql, params);
  }

  static async getCategories() {
    return query(`SELECT * FROM categories ORDER BY name ASC`);
  }
}

module.exports = NewsRepository;
