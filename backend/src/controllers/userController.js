const ApiResponse = require('../utils/response');
const UserRepository = require('../repositories/userRepository');

class UserController {
  static async getProfile(req, res, next) {
    try {
      const user = await UserRepository.findById(req.user.id);
      if (!user) {
        return ApiResponse.error(res, 'User not found', 404);
      }
      return ApiResponse.success(res, 'Profile retrieved', user);
    } catch (err) {
      next(err);
    }
  }

  static async updateProfile(req, res, next) {
    try {
      const { name, bio, language, theme, photo } = req.body;
      const updatedUser = await UserRepository.updateProfile(req.user.id, {
        name,
        bio,
        language,
        theme,
        photo,
      });
      return ApiResponse.success(res, 'Profile updated successfully', updatedUser);
    } catch (err) {
      next(err);
    }
  }

  static async getPreferences(req, res, next) {
    try {
      const preferences = await UserRepository.getPreferences(req.user.id);
      return ApiResponse.success(res, 'User preferences retrieved', preferences);
    } catch (err) {
      next(err);
    }
  }

  static async updatePreferences(req, res, next) {
    try {
      const { categories } = req.body;
      if (!Array.isArray(categories)) {
        return ApiResponse.error(res, 'Categories must be an array of strings', 400);
      }
      const updated = await UserRepository.updatePreferences(req.user.id, categories);
      return ApiResponse.success(res, 'Preferences updated successfully', updated);
    } catch (err) {
      next(err);
    }
  }
}

module.exports = UserController;
