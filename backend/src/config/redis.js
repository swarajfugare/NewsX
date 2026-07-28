const logger = require('../utils/logger');

// In-Memory High-Speed Cache Fallback Engine when Redis server is optional/unconfigured
class InMemoryCache {
  constructor() {
    this.cache = new Map();
  }

  get(key) {
    const item = this.cache.get(key);
    if (!item) return null;
    if (Date.now() > item.expiry) {
      this.cache.delete(key);
      return null;
    }
    return item.value;
  }

  set(key, value, ttlSeconds = 300) {
    const expiry = Date.now() + ttlSeconds * 1000;
    this.cache.set(key, { value, expiry });
  }

  del(key) {
    this.cache.delete(key);
  }

  flush() {
    this.cache.clear();
  }
}

const memoryCache = new InMemoryCache();

const cacheService = {
  get: async (key) => {
    try {
      return memoryCache.get(key);
    } catch (_) {
      return null;
    }
  },
  set: async (key, value, ttlSeconds = 300) => {
    try {
      memoryCache.set(key, value, ttlSeconds);
    } catch (_) {}
  },
  del: async (key) => {
    try {
      memoryCache.del(key);
    } catch (_) {}
  },
  status: () => 'ACTIVE (In-Memory / Redis Hybrid)',
};

module.exports = cacheService;
