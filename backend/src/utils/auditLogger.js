const { query } = require('../config/database');
const logger = require('./logger');

class AuditLogger {
  static async logAction({ adminId = 1, action, target = null, details = null, ipAddress = '127.0.0.1' }) {
    try {
      await query(
        `INSERT INTO audit_logs (admin_id, action, target, details, ip_address) VALUES (?, ?, ?, ?, ?)`,
        [adminId, action, target, details, ipAddress]
      );
      logger.info(`[Audit Log] Admin #${adminId} executed: ${action} on ${target || 'N/A'}`);
    } catch (err) {
      logger.error(`Audit Logger Error: ${err.message}`);
    }
  }
}

module.exports = AuditLogger;
