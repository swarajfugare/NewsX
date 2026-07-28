const rateLimit = require('express-rate-limit');

const apiLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes window
  max: 300, // Limit each IP to 300 requests per 15 mins
  standardHeaders: true,
  legacyHeaders: false,
  message: {
    status: 'error',
    success: false,
    message: 'Too many requests from this IP, please try again after 15 minutes',
  },
});

const authLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 30, // Limit auth attempts to 30 per 15 mins
  message: {
    status: 'error',
    success: false,
    message: 'Too many authentication attempts, please try again later',
  },
});

module.exports = {
  apiLimiter,
  authLimiter,
};
