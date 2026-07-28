const ApiResponse = require('../utils/response');
const HistoryRepository = require('../repositories/historyRepository');

class HistoryController {
  static async getHistory(req, res, next) {
    try {
      const history = await HistoryRepository.getHistoryByUserId(req.user.id);
      return ApiResponse.success(res, 'Reading history fetched', history);
    } catch (err) {
      next(err);
    }
  }

  static async addHistory(req, res, next) {
    try {
      const { news_id, reading_time } = req.body;
      if (!news_id) {
        return ApiResponse.error(res, 'news_id is required', 400);
      }
      const result = await HistoryRepository.logReadingHistory(req.user.id, news_id, reading_time);
      return ApiResponse.success(res, 'History logged', result, 201);
    } catch (err) {
      next(err);
    }
  }
}

module.exports = HistoryController;
