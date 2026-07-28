const ApiResponse = require('../utils/response');
const { query } = require('../config/database');

class NewsEngineController {
  static async getLatest(req, res, next) {
    try {
      const limit = parseInt(req.query.limit) || 40;
      const offset = parseInt(req.query.offset) || 0;
      const articles = await query(
        `SELECT * FROM news_articles WHERE status = 'processed' ORDER BY published_at DESC LIMIT ? OFFSET ?`,
        [limit, offset]
      );
      return ApiResponse.success(res, 'Latest news retrieved', articles);
    } catch (err) {
      next(err);
    }
  }

  static async getTrending(req, res, next) {
    try {
      const limit = parseInt(req.query.limit) || 20;
      const articles = await query(
        `SELECT * FROM news_articles WHERE status = 'processed' ORDER BY trending_score DESC, published_at DESC LIMIT ?`,
        [limit]
      );
      return ApiResponse.success(res, 'Trending news retrieved', articles);
    } catch (err) {
      next(err);
    }
  }

  static async getByCategory(req, res, next) {
    try {
      const { slug } = req.params;
      const articles = await query(
        `SELECT * FROM news_articles WHERE LOWER(category) = LOWER(?) OR LOWER(category_ai) = LOWER(?) ORDER BY published_at DESC LIMIT 40`,
        [slug, slug]
      );
      return ApiResponse.success(res, `News for category ${slug} retrieved`, articles);
    } catch (err) {
      next(err);
    }
  }

  static async getById(req, res, next) {
    try {
      const { id } = req.params;
      const articles = await query(`SELECT * FROM news_articles WHERE id = ?`, [id]);
      if (!articles || articles.length === 0) {
        return ApiResponse.error(res, 'Article not found', 404);
      }
      return ApiResponse.success(res, 'Article details retrieved', articles[0]);
    } catch (err) {
      next(err);
    }
  }

  static async getRelated(req, res, next) {
    try {
      const { id } = req.params;
      const target = await query(`SELECT category FROM news_articles WHERE id = ?`, [id]);
      const category = target[0] ? target[0].category : 'Technology';

      const related = await query(
        `SELECT * FROM news_articles WHERE category = ? AND id != ? ORDER BY published_at DESC LIMIT 6`,
        [category, id]
      );
      return ApiResponse.success(res, 'Related news retrieved', related);
    } catch (err) {
      next(err);
    }
  }

  static async search(req, res, next) {
    try {
      const { keyword, category, language } = req.query;
      let sql = `SELECT * FROM news_articles WHERE 1=1`;
      const params = [];

      if (keyword) {
        sql += ` AND (LOWER(title) LIKE ? OR LOWER(summary) LIKE ? OR LOWER(author) LIKE ?)`;
        const term = `%${keyword.toLowerCase()}%`;
        params.push(term, term, term);
      }

      if (category && category !== 'All') {
        sql += ` AND (category = ? OR category_ai = ?)`;
        params.push(category, category);
      }

      if (language) {
        sql += ` AND language = ?`;
        params.push(language);
      }

      sql += ` ORDER BY published_at DESC LIMIT 40`;
      const articles = await query(sql, params);
      return ApiResponse.success(res, 'Search query results', articles);
    } catch (err) {
      next(err);
    }
  }
}

module.exports = NewsEngineController;
