const logger = require('./logger');
const { pool } = require('../config/database');

const setupGracefulShutdown = (server) => {
  const shutdown = async (signal) => {
    logger.info(`Received ${signal}. Initiating graceful shutdown...`);

    server.close(async () => {
      logger.info('HTTP Server closed.');
      try {
        await pool.end();
        logger.info('MySQL Database pool closed cleanly.');
      } catch (e) {
        logger.error('Error closing database pool:', e);
      }
      process.exit(0);
    });

    // Force shutdown if cleanup takes longer than 10 seconds
    setTimeout(() => {
      logger.error('Forced process shutdown due to timeout.');
      process.exit(1);
    }, 10000);
  };

  process.on('SIGTERM', () => shutdown('SIGTERM'));
  process.on('SIGINT', () => shutdown('SIGINT'));
};

module.exports = setupGracefulShutdown;
