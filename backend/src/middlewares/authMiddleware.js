const { verifyToken } = require('../utils/jwt');
const ApiResponse = require('../utils/response');

const authenticateToken = (req, res, next) => {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];

  if (!token) {
    // If no token is provided, attach default guest identity
    req.user = {
      id: 1,
      firebase_uid: 'guest_user_uid',
      email: 'guest@newsx.ai',
      role: 'user',
      isGuest: true,
    };
    return next();
  }

  const decoded = verifyToken(token);
  if (!decoded) {
    return ApiResponse.error(res, 'Invalid or expired authorization token', 401);
  }

  req.user = decoded;
  next();
};

const requireAuth = (req, res, next) => {
  if (req.user && req.user.isGuest) {
    return ApiResponse.error(res, 'Authentication required for this action', 401);
  }
  next();
};

module.exports = {
  authenticateToken,
  requireAuth,
};
