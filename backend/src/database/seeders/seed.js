const { query } = require('../../config/database');
const logger = require('../../utils/logger');

const seedDatabase = async () => {
  try {
    logger.info('Seeding Database with Initial Categories & News Articles...');

    // Seed Categories
    const categories = [
      ['AI', 'ai', 'psychology_rounded'],
      ['Technology', 'technology', 'laptop_mac'],
      ['Business', 'business', 'business_center'],
      ['Finance', 'finance', 'attach_money'],
      ['Startup', 'startup', 'rocket_launch'],
      ['Cricket', 'cricket', 'sports_cricket'],
      ['Football', 'football', 'sports_soccer'],
      ['Gaming', 'gaming', 'sports_esports'],
      ['Movies', 'movies', 'movie'],
      ['Health', 'health', 'health_and_safety'],
      ['Science', 'science', 'science'],
      ['World', 'world', 'public'],
      ['India', 'india', 'flag'],
      ['Education', 'education', 'school'],
    ];

    for (const [name, slug, icon] of categories) {
      await query(
        `INSERT INTO categories (name, slug, icon) VALUES (?, ?, ?) ON DUPLICATE KEY UPDATE name=VALUES(name)`,
        [name, slug, icon]
      );
    }

    // Seed Default Guest User
    await query(
      `INSERT INTO users (id, firebase_uid, name, email, username, role) 
       VALUES (1, 'guest_user_uid', 'Alex Morgan', 'alex.morgan@newsx.ai', 'alexmorgan', 'user') 
       ON DUPLICATE KEY UPDATE name=VALUES(name)`
    );

    // Seed News Articles
    const now = new Date();
    const articles = [
      [
        'news_1',
        'OpenAI Unveils GPT-5 Engine with Multimodal Reasoning Capability',
        'OpenAI officially announces GPT-5 featuring native reasoning, real-time audio synthesis, and autonomous coding tools designed to assist complex software engineering workflows.',
        'https://images.unsplash.com/photo-1677442136019-21780efad99a?q=80&w=1000&auto=format&fit=crop',
        'AI',
        'TechCrunch',
        'https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=200&auto=format&fit=crop',
        now,
        '1 min',
        'English',
        1420,
        380,
        154,
      ],
      [
        'news_2',
        'Apple Announces M4 Ultra Mac Studio for Heavy AI Workloads',
        'Apple introduces the M4 Ultra Mac Studio with 32 CPU cores and 80 GPU cores, setting new standards in local LLM fine-tuning performance.',
        'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?q=80&w=1000&auto=format&fit=crop',
        'Technology',
        'The Verge',
        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=200&auto=format&fit=crop',
        now,
        '1 min',
        'English',
        980,
        210,
        89,
      ],
      [
        'news_3',
        'Global Semiconductor Sales Surge 24% Driven by AI Data Center Boom',
        'Global chip demand surges to unprecedented records as enterprise data centers upgrade infrastructure for generative AI inference and neural network training hardware.',
        'https://images.unsplash.com/photo-1518770660439-4636190af475?q=80&w=1000&auto=format&fit=crop',
        'Business',
        'Bloomberg',
        'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?q=80&w=200&auto=format&fit=crop',
        now,
        '1 min',
        'English',
        2150,
        640,
        312,
      ],
    ];

    for (const art of articles) {
      await query(
        `INSERT INTO news_articles (id, title, summary, image_url, category, author, author_avatar, published_at, read_time, language, likes_count, shares_count, comments_count)
         VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
         ON DUPLICATE KEY UPDATE title=VALUES(title)`,
        art
      );
    }

    logger.info('Database Seeding Completed Successfully.');
  } catch (err) {
    logger.error(`Database Seeding Error: ${err.message}`);
  }
};

if (require.main === module) {
  seedDatabase();
}

module.exports = seedDatabase;
