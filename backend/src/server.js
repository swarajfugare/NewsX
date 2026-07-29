const express = require('express');
const helmet = require('helmet');
const cors = require('cors');
const env = require('./config/env');
const logger = require('./utils/logger');
const apiRoutes = require('./routes');
const HealthController = require('./controllers/healthController');
const errorHandler = require('./middlewares/errorHandler');
const { apiLimiter } = require('./middlewares/rateLimiter');
const setupGracefulShutdown = require('./utils/gracefulShutdown');

const app = express();

// Security & Parser Middlewares
app.use(helmet());
app.use(cors({ origin: env.allowedOrigins }));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Global Rate Limiter for API endpoints
app.use('/api', apiLimiter);

// -------------------------------------------------------------
// 1. ROOT DISCOVERY ENDPOINT (GET /)
// -------------------------------------------------------------
app.get('/', (req, res) => {
  res.status(200).json({
    name: 'NewsX Backend API',
    version: '3.0.0',
    status: 'Active',
    health: '/health',
    api: '/api',
    v1: '/api/v1',
  });
});

// -------------------------------------------------------------
// 2. GLOBAL HEALTH ENDPOINTS (GET /health, GET /api/health)
// -------------------------------------------------------------
app.get('/health', HealthController.getHealth);
app.get('/api/health', HealthController.getHealth);

// -------------------------------------------------------------
// 3. API ROOT DISCOVERY ENDPOINT (GET /api)
// -------------------------------------------------------------
app.get('/api', (req, res) => {
  res.status(200).json({
    name: 'NewsX Backend',
    version: '3.0.0',
    status: 'Running',
    documentation: '/api/docs',
  });
});

// -------------------------------------------------------------
// 4. API V1 & API ROUTER MOUNTING
// -------------------------------------------------------------
app.use('/api/v1', apiRoutes);
app.use('/api', apiRoutes);

// -------------------------------------------------------------
// 5. 404 HANDLER (MUST BE PLACED LAST BEFORE ERROR HANDLER)
// -------------------------------------------------------------
app.use((req, res) => {
  res.status(404).json({
    status: 'error',
    message: 'API Endpoint Not Found',
    requestedUrl: req.originalUrl,
  });
});

// -------------------------------------------------------------
// 6. GLOBAL ERROR INTERCEPTOR
// -------------------------------------------------------------
app.use(errorHandler);

// Port Fallback Listener Strategy
const startServer = (targetPort) => {
  const server = app.listen(targetPort, () => {
    logger.info(`🚀 NewsX Backend Server Running on Port ${targetPort} [${env.nodeEnv}]`);
    logger.info(`Base API URL: http://localhost:${targetPort}/api/v1`);
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
