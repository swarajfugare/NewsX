const ApiResponse = require('../utils/response');
const NewsRepository = require('../repositories/newsRepository');

class NewsController {
  static async search(req, res, next) {
    try {
      const { keyword, category, language, limit, offset } = req.query;
      const articles = await NewsRepository.searchArticles({
        keyword,
        category,
        language,
        limit,
        offset,
      });
      return ApiResponse.success(res, 'Search completed', articles);
    } catch (err) {
      next(err);
    }
  }
}

module.exports = NewsController;
