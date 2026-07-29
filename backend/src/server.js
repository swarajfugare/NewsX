const express = require('express');
const helmet = require('helmet');
const cors = require('cors');
const env = require('./config/env');
const logger = require('./utils/logger');
const apiRoutes = require('./routes');
const errorHandler = require('./middlewares/errorHandler');
const { apiLimiter } = require('./middlewares/rateLimiter');
const setupGracefulShutdown = require('./utils/gracefulShutdown');

const app = express();

// Security Middlewares
app.use(helmet());
app.use(cors({ origin: env.allowedOrigins }));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Global Rate Limiter
app.use(env.apiPrefix, apiLimiter);

// Simple Health Check Endpoint
app.get('/health', (req, res) => {
  res.status(200).json({ status: 'UP', timestamp: new Date().toISOString() });
});

// API Routes Mounting
app.use(env.apiPrefix, apiRoutes);

// 404 Handler
app.use((req, res) => {
  res.status(404).json({ status: 'error', message: 'API Endpoint Not Found' });
});

// Global Error Interceptor
app.use(errorHandler);

// Port Fallback Listener Strategy
const startServer = (targetPort) => {
  const server = app.listen(targetPort, () => {
    logger.info(`🚀 NewsX Backend Server Running on Port ${targetPort} [${env.nodeEnv}]`);
    logger.info(`Base API URL: http://localhost:${targetPort}${env.apiPrefix}`);
  });

  server.on('error', (err) => {
    if (err.code === 'EADDRINUSE') {
      logger.warn(`⚠️ Port ${targetPort} is occupied by another process (e.g., macOS ControlCenter/AirPlay). Trying Port ${targetPort + 1}...`);
      startServer(targetPort + 1);
    } else {
      logger.error('❌ Server failed to start:', err);
      process.exit(1);
    }
  });

  setupGracefulShutdown(server);
  return server;
};

const initialPort = env.port || 5000;
startServer(initialPort);

module.exports = app;
