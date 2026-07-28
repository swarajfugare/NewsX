const ApiResponse = require('../utils/response');
const BookmarkRepository = require('../repositories/bookmarkRepository');

class BookmarkController {
  static async getBookmarks(req, res, next) {
    try {
      const bookmarks = await BookmarkRepository.getByUserId(req.user.id);
      return ApiResponse.success(res, 'Bookmarks fetched successfully', bookmarks);
    } catch (err) {
      next(err);
    }
  }

  static async addBookmark(req, res, next) {
    try {
      const { news_id } = req.body;
      if (!news_id) {
        return ApiResponse.error(res, 'news_id is required', 400);
      }
      const result = await BookmarkRepository.addBookmark(req.user.id, news_id);
      return ApiResponse.success(res, 'Bookmark added', result, 201);
    } catch (err) {
      next(err);
    }
  }

  static async removeBookmark(req, res, next) {
    try {
      const news_id = req.params.id;
      const result = await BookmarkRepository.removeBookmark(req.user.id, news_id);
      return ApiResponse.success(res, 'Bookmark removed', result);
    } catch (err) {
      next(err);
    }
  }
}

module.exports = BookmarkController;
