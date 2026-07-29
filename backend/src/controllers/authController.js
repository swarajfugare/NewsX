const ApiResponse = require('../utils/response');
const { generateToken, generateRefreshToken } = require('../utils/jwt');
const UserRepository = require('../repositories/userRepository');
const { verifyFirebaseToken } = require('../config/firebase');
const logger = require('../utils/logger');

class AuthController {
  static async register(req, res, next) {
    try {
      const { firebaseToken, name, email, photo } = req.body;
      const firebaseUser = await verifyFirebaseToken(firebaseToken);

      const realName = name || firebaseUser.name || (email ? email.split('@')[0] : 'Reader');
      const realEmail = email || firebaseUser.email;
      const realPhoto = photo || firebaseUser.picture || '';

      logger.info(`🔐 Processing Firebase Registration for UID: ${firebaseUser.uid} (${realEmail})`);

      const user = await UserRepository.upsertUser({
        firebaseUid: firebaseUser.uid,
        name: realName,
        email: realEmail,
        photo: realPhoto,
      });

      const token = generateToken({ id: user.id, firebase_uid: user.firebase_uid, role: user.role });
      const refreshToken = generateRefreshToken({ id: user.id });

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
      const firebaseUser = await verifyFirebaseToken(firebaseToken);

      const realName = name || firebaseUser.name || (email ? email.split('@')[0] : 'Reader');
      const realEmail = email || firebaseUser.email;
      const realPhoto = photo || firebaseUser.picture || '';

      logger.info(`🔐 Processing Firebase Login for UID: ${firebaseUser.uid} (${realEmail})`);

      const user = await UserRepository.upsertUser({
        firebaseUid: firebaseUser.uid,
        name: realName,
        email: realEmail,
        photo: realPhoto,
      });

      const token = generateToken({ id: user.id, firebase_uid: user.firebase_uid, role: user.role });
      const refreshToken = generateRefreshToken({ id: user.id });

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
