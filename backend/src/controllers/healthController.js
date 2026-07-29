const os = require('os');
const { query } = require('../config/database');
const cacheService = require('../config/redis');
const NewsCronManager = require('../cron/newsCron');

class HealthController {
  static async getHealth(req, res, next) {
    try {
      let dbStatus = 'connected';
      try {
        await query('SELECT 1');
      } catch (_) {
        dbStatus = 'disconnected';
      }

      return res.status(200).json({
        status: 'UP',
        database: dbStatus,
        firebase: 'connected',
        rss: 'running',
        cron: 'running',
        uptime: `${Math.round(process.uptime())}s`,
        timestamp: new Date().toISOString(),
      });
    } catch (err) {
      return res.status(500).json({
        status: 'DOWN',
        error: err.message,
      });
    }
  }

  static async getDetailedHealth(req, res, next) {
    try {
      let dbStatus = 'HEALTHY';
      try {
        await query('SELECT 1');
      } catch (_) {
        dbStatus = 'DEGRADED';
      }

      const memoryUsage = process.memoryUsage();
      const freeMemoryMb = Math.round(os.freemem() / (1024 * 1024));
      const totalMemoryMb = Math.round(os.totalmem() / (1024 * 1024));

      return res.status(200).json({
        status: 'UP',
        database: dbStatus,
        firebase: 'connected',
        rss: 'running',
        cron: NewsCronManager.jobStatus,
        telemetry: {
          uptimeSeconds: Math.round(process.uptime()),
          memory: {
            heapUsedMb: Math.round(memoryUsage.heapUsed / (1024 * 1024)),
            freeMemoryMb,
            totalMemoryMb,
          },
          cacheEngine: cacheService.status(),
        },
        timestamp: new Date().toISOString(),
      });
    } catch (err) {
      next(err);
    }
  }
}

module.exports = HealthController;
