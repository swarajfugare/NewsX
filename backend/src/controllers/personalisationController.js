const ApiResponse = require('../utils/response');
const RecommendationService = require('../services/recommendationService');
const { query } = require('../config/database');

class PersonalisationController {
  static async getPersonalisedFeed(req, res, next) {
    try {
      const limit = parseInt(req.query.limit) || 40;
      const offset = parseInt(req.query.offset) || 0;
      const userId = req.user.id;

      const articles = await RecommendationService.getPersonalisedFeed(userId, limit, offset);
      return ApiResponse.success(res, 'AI Personalised Feed retrieved', articles);
    } catch (err) {
      next(err);
    }
  }

  static async getDailyDigest(req, res, next) {
    try {
      const articles = await RecommendationService.getDailyDigest(req.user.id);
      return ApiResponse.success(res, 'Daily Digest package retrieved', articles);
    } catch (err) {
      next(err);
    }
  }

  static async getTrendingTopics(req, res, next) {
    try {
      const topics = await RecommendationService.getTrendingTopics();
      return ApiResponse.success(res, 'Trending topics retrieved', topics);
    } catch (err) {
      next(err);
    }
  }

  static async getContinueReading(req, res, next) {
    try {
      const history = await query(
        `SELECT h.opened_at, h.reading_time, n.* 
         FROM history h 
         JOIN news_articles n ON h.news_id = n.id 
         WHERE h.user_id = ? ORDER BY h.opened_at DESC LIMIT 5`,
        [req.user.id]
      );
      return ApiResponse.success(res, 'Continue reading list retrieved', history);
    } catch (err) {
      next(err);
    }
  }
}

module.exports = PersonalisationController;
