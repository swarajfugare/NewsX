const ApiResponse = require('../utils/response');
const LikeRepository = require('../repositories/likeRepository');

class ShareController {
  static async addShare(req, res, next) {
    try {
      const { news_id } = req.body;
      if (!news_id) {
        return ApiResponse.error(res, 'news_id is required', 400);
      }
      const result = await LikeRepository.addShare(req.user.id, news_id);
      return ApiResponse.success(res, 'Share tracked successfully', result, 201);
    } catch (err) {
      next(err);
    }
  }
}

module.exports = ShareController;
