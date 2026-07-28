const ApiResponse = require('../utils/response');
const NewsCronManager = require('../cron/newsCron');

class AdminController {
  static async refreshRss(req, res, next) {
    try {
      NewsCronManager.fetchAndIngestRss().then(() => {
        NewsCronManager.processPendingAiArticles();
      });
      return ApiResponse.success(res, 'RSS Ingestion and AI Processing pipeline triggered successfully');
    } catch (err) {
      next(err);
    }
  }

  static async getJobStatus(req, res, next) {
    try {
      return ApiResponse.success(res, 'Cron Worker Status', NewsCronManager.jobStatus);
    } catch (err) {
      next(err);
    }
  }
}

module.exports = AdminController;
