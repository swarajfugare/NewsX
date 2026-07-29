const cheerio = require('cheerio');
const axios = require('axios');
const logger = require('../utils/logger');

class ImageExtractorService {
  static async extractBestImage(article) {
    // 1. Check RSS Media Content tags
    if (article.mediaContent && article.mediaContent.$ && article.mediaContent.$.url) {
      return article.mediaContent.$.url;
    }
    if (article.mediaContent && article.mediaContent.url) {
      return article.mediaContent.url;
    }
    if (article.enclosure && article.enclosure.url) {
      return article.enclosure.url;
    }

    // 2. Parse img src from RSS description HTML snippet
    if (article.content && article.content.includes('<img')) {
      try {
        const $desc = cheerio.load(article.content);
        const imgSrc = $desc('img').attr('src');
        if (imgSrc && imgSrc.startsWith('http')) {
          return imgSrc;
        }
      } catch (e) {
        // Ignore html parse errors
      }
    }

    // 3. Fetch Article Webpage HTML to parse og:image / twitter:image / link image_src
    if (article.link) {
      try {
        const response = await axios.get(article.link, {
          timeout: 4000,
          headers: { 'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36' },
        });
        const $ = cheerio.load(response.data);

        const ogImage = $('meta[property="og:image"]').attr('content') ||
                       $('meta[name="twitter:image"]').attr('content') ||
                       $('meta[property="twitter:image"]').attr('content') ||
                       $('link[rel="image_src"]').attr('href') ||
                       $('article img').attr('src') ||
                       $('.main-image img').attr('src');

        if (ogImage && ogImage.startsWith('http')) {
          return ogImage;
        }
      } catch (e) {
        logger.warn(`Could not scrape OpenGraph image for URL: ${article.link}`);
      }
    }

    // 4. Fallback High-Res Category News Images
    const placeholders = {
      AI: 'https://images.unsplash.com/photo-1677442136019-21780efad99a?q=80&w=1000&auto=format&fit=crop',
      Technology: 'https://images.unsplash.com/photo-1518770660439-4636190af475?q=80&w=1000&auto=format&fit=crop',
      Business: 'https://images.unsplash.com/photo-1559526324-4b87b5e36e44?q=80&w=1000&auto=format&fit=crop',
      Finance: 'https://images.unsplash.com/photo-1611974789855-9c2a0a7236a3?q=80&w=1000&auto=format&fit=crop',
      Sports: 'https://images.unsplash.com/photo-1540747913346-19e32dc3e97e?q=80&w=1000&auto=format&fit=crop',
      Cricket: 'https://images.unsplash.com/photo-1540747913346-19e32dc3e97e?q=80&w=1000&auto=format&fit=crop',
      World: 'https://images.unsplash.com/photo-1466611653911-95081537e5b7?q=80&w=1000&auto=format&fit=crop',
      India: 'https://images.unsplash.com/photo-1532105956626-9569c03602f6?q=80&w=1000&auto=format&fit=crop',
      Science: 'https://images.unsplash.com/photo-1517976487492-5750f3195933?q=80&w=1000&auto=format&fit=crop',
      Health: 'https://images.unsplash.com/photo-1576091160399-112ba8d25d1d?q=80&w=1000&auto=format&fit=crop',
      Politics: 'https://images.unsplash.com/photo-1540910419892-4a36d2c3266c?q=80&w=1000&auto=format&fit=crop',
      Entertainment: 'https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?q=80&w=1000&auto=format&fit=crop',
    };

    return placeholders[article.category] || placeholders.Technology;
  }
}

module.exports = ImageExtractorService;
