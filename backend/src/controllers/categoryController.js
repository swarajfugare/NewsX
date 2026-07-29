const ApiResponse = require('../utils/response');
const NewsRepository = require('../repositories/newsRepository');

class CategoryController {
  static async getCategories(req, res, next) {
    try {
      const categories = await NewsRepository.getCategories();
      if (categories && categories.length > 0) {
        return ApiResponse.success(res, 'Categories retrieved', categories);
      }
    } catch (_) {}

    // Graceful Fallback if DB is disconnected or empty
    const fallbackCategories = [
      { id: 1, name: 'All', slug: 'all' },
      { id: 2, name: 'AI', slug: 'ai' },
      { id: 3, name: 'Technology', slug: 'technology' },
      { id: 4, name: 'Business', slug: 'business' },
      { id: 5, name: 'Sports', slug: 'sports' },
      { id: 6, name: 'Cricket', slug: 'cricket' },
      { id: 7, name: 'Politics', slug: 'politics' },
      { id: 8, name: 'Science', slug: 'science' },
      { id: 9, name: 'Health', slug: 'health' },
      { id: 10, name: 'Entertainment', slug: 'entertainment' },
      { id: 11, name: 'World', slug: 'world' },
      { id: 12, name: 'India', slug: 'india' }
    ];

    return ApiResponse.success(res, 'Categories retrieved (Fallback Mode)', fallbackCategories);
  }
}

module.exports = CategoryController;
