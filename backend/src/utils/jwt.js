const jwt = require('jsonwebtoken');
const env = require('../config/env');

const generateToken = (userPayload) => {
  return jwt.sign(userPayload, env.jwt.secret, {
    expiresIn: env.jwt.expiresIn,
  });
};

const generateRefreshToken = (userPayload) => {
  return jwt.sign(userPayload, env.jwt.secret, {
    expiresIn: env.jwt.refreshExpiresIn,
  });
};

const verifyToken = (token) => {
  try {
    return jwt.verify(token, env.jwt.secret);
  } catch (err) {
    return null;
  }
};

module.exports = {
  generateToken,
  generateRefreshToken,
  verifyToken,
};
