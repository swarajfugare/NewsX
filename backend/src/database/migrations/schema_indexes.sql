-- Enterprise Database Composite Indexes Optimization for NewsX MySQL
USE newsx_db;

CREATE INDEX IF NOT EXISTS idx_news_status_pub ON news_articles (status, published_at DESC);
CREATE INDEX IF NOT EXISTS idx_news_cat_status ON news_articles (category, status, published_at DESC);
CREATE INDEX IF NOT EXISTS idx_news_trending ON news_articles (trending_score DESC, published_at DESC);
CREATE INDEX IF NOT EXISTS idx_bookmarks_user ON bookmarks (user_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_likes_user ON likes (user_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_history_user ON history (user_id, opened_at DESC);
CREATE INDEX IF NOT EXISTS idx_users_firebase ON users (firebase_uid);
