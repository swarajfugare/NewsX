const os = require('os');
const ApiResponse = require('../utils/response');
const { query } = require('../config/database');
const cacheService = require('../config/redis');
const NewsCronManager = require('../cron/newsCron');

class HealthController {
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

      const telemetry = {
        server: {
          status: 'UP',
          uptimeSeconds: Math.round(process.uptime()),
          nodeVersion: process.version,
          platform: process.platform,
          timestamp: new Date().toISOString(),
        },
        systemResources: {
          cpuCount: os.cpus().length,
          cpuModel: os.cpus()[0].model,
          memory: {
            processHeapUsedMb: Math.round(memoryUsage.heapUsed / (1024 * 1024)),
            systemFreeMemoryMb: freeMemoryMb,
            systemTotalMemoryMb: totalMemoryMb,
          },
        },
        databasePool: {
          status: dbStatus,
          engine: 'MySQL 8.0',
        },
        cacheEngine: {
          status: cacheService.status(),
        },
        cronWorkers: NewsCronManager.jobStatus,
      };

      return ApiResponse.success(res, 'Enterprise System Health Telemetry', telemetry);
    } catch (err) {
      next(err);
    }
  }
}

module.exports = HealthController;
