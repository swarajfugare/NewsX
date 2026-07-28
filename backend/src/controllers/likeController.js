const ApiResponse = require('../utils/response');
const LikeRepository = require('../repositories/likeRepository');

class LikeController {
  static async addLike(req, res, next) {
    try {
      const { news_id } = req.body;
      if (!news_id) {
        return ApiResponse.error(res, 'news_id is required', 400);
      }
      const result = await LikeRepository.addLike(req.user.id, news_id);
      return ApiResponse.success(res, 'Article liked', result, 201);
    } catch (err) {
      next(err);
    }
  }

  static async removeLike(req, res, next) {
    try {
      const news_id = req.params.id;
      const result = await LikeRepository.removeLike(req.user.id, news_id);
      return ApiResponse.success(res, 'Like removed', result);
    } catch (err) {
      next(err);
    }
  }
}

module.exports = LikeController;
