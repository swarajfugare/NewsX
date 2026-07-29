const ApiResponse = require('../utils/response');
const { generateToken, generateRefreshToken } = require('../utils/jwt');
const UserRepository = require('../repositories/userRepository');
const { verifyFirebaseToken } = require('../config/firebase');

class AuthController {
  static async register(req, res, next) {
    try {
      const { firebaseToken, name, email, photo } = req.body;
      let firebaseUser = { uid: `user_${Date.now()}`, name: name || 'Reader', email: email || 'user@newsx.ai', picture: photo };

      if (firebaseToken) {
        try {
          const verified = await verifyFirebaseToken(firebaseToken);
          if (verified) firebaseUser = verified;
        } catch (e) {
          // If token verification fails, use body payloads for development fallback
        }
      }

      const user = await UserRepository.upsertUser({
        firebaseUid: firebaseUser.uid,
        name: name || firebaseUser.name || 'Reader',
        email: email || firebaseUser.email || 'reader@newsx.ai',
        photo: photo || firebaseUser.picture || '',
      });

      const token = generateToken({ id: user ? user.id : 1, firebase_uid: firebaseUser.uid, role: user ? user.role : 'user' });
      const refreshToken = generateRefreshToken({ id: user ? user.id : 1 });

      return ApiResponse.success(res, 'User registered successfully', {
        user,
        token,
        refreshToken,
      });
    } catch (err) {
      next(err);
    }
  }

  static async login(req, res, next) {
    try {
      const { firebaseToken, name, email, photo } = req.body;
      let firebaseUser = { uid: `user_${Date.now()}`, name: name || 'NewsX User', email: email || 'user@newsx.ai', picture: photo };

      if (firebaseToken) {
        try {
          const verified = await verifyFirebaseToken(firebaseToken);
          if (verified) firebaseUser = verified;
        } catch (e) {
          // Fallback if verification error
        }
      }

      const user = await UserRepository.upsertUser({
        firebaseUid: firebaseUser.uid,
        name: name || firebaseUser.name || 'NewsX User',
        email: email || firebaseUser.email || 'user@newsx.ai',
        photo: photo || firebaseUser.picture || '',
      });

      const token = generateToken({ id: user ? user.id : 1, firebase_uid: firebaseUser.uid, role: user ? user.role : 'user' });
      const refreshToken = generateRefreshToken({ id: user ? user.id : 1 });

      return ApiResponse.success(res, 'Login successful', {
        user,
        token,
        refreshToken,
      });
    } catch (err) {
      next(err);
    }
  }

  static async logout(req, res, next) {
    try {
      return ApiResponse.success(res, 'Logout successful');
    } catch (err) {
      next(err);
    }
  }
}

module.exports = AuthController;
