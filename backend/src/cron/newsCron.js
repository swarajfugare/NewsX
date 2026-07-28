const cron = require('node-cron');
const RssService = require('../services/rssService');
const DeduplicationService = require('../services/deduplicationService');
const ImageExtractorService = require('../services/imageExtractorService');
const ContentCleanerService = require('../services/contentCleanerService');
const GeminiAiService = require('../services/geminiAiService');
const TrendingEngineService = require('../services/trendingEngineService');
const { query } = require('../config/database');
const logger = require('../utils/logger');

class NewsCronManager {
  static jobStatus = {
    rssFetch: { status: 'idle', lastRun: null, itemsIngested: 0 },
    aiProcessing: { status: 'idle', lastRun: null, itemsProcessed: 0 },
    trendingRecalc: { status: 'idle', lastRun: null },
  };

  static async fetchAndIngestRss() {
    try {
      this.jobStatus.rssFetch.status = 'running';
      logger.info('=== [Cron Worker] Running RSS Ingestion Job ===');

      const rawArticles = await RssService.fetchAllFeeds();
      let ingestedCount = 0;

      for (const article of rawArticles) {
        const canonicalUrl = ContentCleanerService.cleanUrl(article.link);
        const cleanTitle = ContentCleanerService.cleanHtml(article.title);

        const isDup = await DeduplicationService.isDuplicate(canonicalUrl, cleanTitle);
        if (!isDup) {
          const articleId = `news_${Date.now()}_${Math.floor(Math.random() * 10000)}`;
          const cleanContent = ContentCleanerService.cleanHtml(article.content);
          const imageUrl = await ImageExtractorService.extractBestImage(article);

          await query(
            `INSERT INTO news_articles 
             (id, title, summary, image_url, category, author, author_avatar, published_at, read_time, source_name, canonical_url, status)
             VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'pending')`,
            [
              articleId,
              cleanTitle,
              cleanContent.substring(0, 150),
              imageUrl,
              article.category,
              article.author || article.sourceName,
              'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?q=80&w=200&auto=format&fit=crop',
              article.publishedAt,
              '1 min',
              article.sourceName,
              canonicalUrl,
            ]
          );
          ingestedCount++;
        }
      }

      this.jobStatus.rssFetch.status = 'idle';
      this.jobStatus.rssFetch.lastRun = new Date().toISOString();
      this.jobStatus.rssFetch.itemsIngested = ingestedCount;
      logger.info(`=== [Cron Worker] RSS Ingestion Completed: ${ingestedCount} new stories added ===`);
    } catch (err) {
      this.jobStatus.rssFetch.status = 'failed';
      logger.error(`[Cron Worker] RSS Ingestion Error: ${err.message}`);
    }
  }

  static async processPendingAiArticles() {
    try {
      this.jobStatus.aiProcessing.status = 'running';
      logger.info('=== [Cron Worker] Running Gemini AI Processing Job ===');

      const pendingArticles = await query(
        `SELECT id, title, summary, category FROM news_articles WHERE status = 'pending' LIMIT 10`
      );

      let processedCount = 0;
      for (const article of pendingArticles) {
        const aiResult = await GeminiAiService.processArticle(
          article.title,
          article.summary,
          article.category
        );

        await query(
          `UPDATE news_articles SET 
           summary = ?,
           summary_hi = ?,
           summary_mr = ?,
           category_ai = ?,
           why_it_matters = ?,
           sentiment = ?,
           importance_score = ?,
           keywords = ?,
           tags = ?,
           related_topics = ?,
           status = 'processed',
           processed_at = NOW()
           WHERE id = ?`,
          [
            aiResult.summary,
            aiResult.summary_hi,
            aiResult.summary_mr,
            aiResult.category_ai,
            aiResult.why_it_matters,
            aiResult.sentiment,
            aiResult.importance_score,
            JSON.stringify(aiResult.keywords),
            JSON.stringify(aiResult.tags),
            JSON.stringify(aiResult.related_topics),
            article.id,
          ]
        );
        processedCount++;
      }

      this.jobStatus.aiProcessing.status = 'idle';
      this.jobStatus.aiProcessing.lastRun = new Date().toISOString();
      this.jobStatus.aiProcessing.itemsProcessed = processedCount;
      logger.info(`=== [Cron Worker] AI Processing Completed: ${processedCount} stories synthesized ===`);
    } catch (err) {
      this.jobStatus.aiProcessing.status = 'failed';
      logger.error(`[Cron Worker] AI Processing Error: ${err.message}`);
    }
  }

  static initSchedules() {
    const rssSchedule = process.env.CRON_RSS_SCHEDULE || '*/10 * * * *';
    const aiSchedule = process.env.CRON_AI_SCHEDULE || '*/5 * * * *';
    const trendingSchedule = process.env.CRON_TRENDING_SCHEDULE || '0 * * * *';

    cron.schedule(rssSchedule, () => this.fetchAndIngestRss());
    cron.schedule(aiSchedule, () => this.processPendingAiArticles());
    cron.schedule(trendingSchedule, () => TrendingEngineService.recalculateTrendingScores());

    logger.info(`Background Cron Jobs Scheduled: RSS [${rssSchedule}], AI [${aiSchedule}], Trending [${trendingSchedule}]`);
  }
}

if (require.main === module) {
  NewsCronManager.fetchAndIngestRss().then(() => {
    NewsCronManager.processPendingAiArticles();
  });
} else {
  NewsCronManager.initSchedules();
}

module.exports = NewsCronManager;
