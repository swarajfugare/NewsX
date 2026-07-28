const { query } = require('../config/database');

class DeduplicationService {
  // Title similarity calculator (Jaccard Index)
  static calculateTitleSimilarity(str1, str2) {
    const set1 = new Set(str1.toLowerCase().split(/\s+/));
    const set2 = new Set(str2.toLowerCase().split(/\s+/));
    const intersection = new Set([...set1].filter(x => set2.has(x)));
    const union = new Set([...set1, ...set2]);
    return intersection.size / union.size;
  }

  static async isDuplicate(canonicalUrl, title) {
    if (!title || title.length < 10) return true;

    // 1. Check Exact Canonical URL match in database
    if (canonicalUrl) {
      const urlMatch = await query(
        `SELECT id FROM news_articles WHERE canonical_url = ? LIMIT 1`,
        [canonicalUrl]
      );
      if (urlMatch && urlMatch.length > 0) return true;
    }

    // 2. Fetch Recent Titles (last 48 hours) to compare similarity
    const recentArticles = await query(
      `SELECT title FROM news_articles WHERE published_at >= NOW() - INTERVAL 48 HOUR`
    );

    for (const article of recentArticles) {
      const similarity = this.calculateTitleSimilarity(title, article.title);
      if (similarity >= 0.70) { // 70% threshold overlap considers it a duplicate story
        return true;
      }
    }

    return false;
  }
}

module.exports = DeduplicationService;
