const fs = require('fs');
const path = require('path');
const RSSParser = require('rss-parser');
const logger = require('../utils/logger');

const parser = new RSSParser({
  customFields: {
    item: [
      ['media:content', 'mediaContent'],
      ['media:thumbnail', 'mediaThumbnail'],
      ['enclosure', 'enclosure'],
    ],
  },
});

class RssService {
  static getSourcesConfig() {
    const configPath = path.join(__dirname, '../config/rssSources.json');
    if (fs.existsSync(configPath)) {
      const data = fs.readFileSync(configPath, 'utf8');
      return JSON.parse(data);
    }
    return [];
  }

  static async fetchAllFeeds() {
    const sources = this.getSourcesConfig();
    const rawArticles = [];

    for (const source of sources) {
      try {
        logger.info(`Fetching RSS feed from: ${source.name} [${source.category}]`);
        const parsed = await parser.parseURL(source.url);

        for (const item of parsed.items || []) {
          rawArticles.push({
            title: item.title,
            link: item.link || item.guid,
            content: item.contentSnippet || item.content || item.summary || '',
            category: source.category,
            sourceName: source.name,
            author: item.creator || source.name,
            publishedAt: item.pubDate ? new Date(item.pubDate) : new Date(),
            mediaContent: item.mediaContent || item.mediaThumbnail || item.enclosure,
          });
        }
      } catch (err) {
        logger.warn(`Failed to fetch RSS from ${source.name}: ${err.message}`);
      }
    }

    return rawArticles;
  }
}

module.exports = RssService;
