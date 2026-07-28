const ApiResponse = require('../utils/response');
const NewsRepository = require('../repositories/newsRepository');

class CategoryController {
  static async getCategories(req, res, next) {
    try {
      const categories = await NewsRepository.getCategories();
      return ApiResponse.success(res, 'Categories retrieved', categories);
    } catch (err) {
      next(err);
    }
  }
}

module.exports = CategoryController;
