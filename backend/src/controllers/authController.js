const ApiResponse = require('../utils/response');
const { generateToken, generateRefreshToken } = require('../utils/jwt');
const UserRepository = require('../repositories/userRepository');
const { verifyFirebaseToken } = require('../config/firebase');

class AuthController {
  static async register(req, res, next) {
    try {
      const { firebaseToken, name, email, photo } = req.body;
      const firebaseUser = await verifyFirebaseToken(firebaseToken);

      let user = await UserRepository.findByFirebaseUid(firebaseUser.uid);
      if (!user) {
        user = await UserRepository.createUser({
          firebaseUid: firebaseUser.uid,
          name: name || firebaseUser.name || 'Reader',
          email: email || firebaseUser.email,
          photo: photo || firebaseUser.picture,
        });
      }

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
      const { firebaseToken } = req.body;
      const firebaseUser = await verifyFirebaseToken(firebaseToken);

      let user = await UserRepository.findByFirebaseUid(firebaseUser.uid);
      if (!user) {
        user = await UserRepository.createUser({
          firebaseUid: firebaseUser.uid,
          name: firebaseUser.name || 'NewsX User',
          email: firebaseUser.email,
          photo: firebaseUser.picture,
        });
      }

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
