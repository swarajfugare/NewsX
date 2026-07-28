const cheerio = require('cheerio');

class ContentCleanerService {
  static cleanHtml(rawHtmlOrText) {
    if (!rawHtmlOrText) return '';

    // Load HTML into Cheerio parser
    const $ = cheerio.load(rawHtmlOrText);

    // Remove unwanted scripts, styles, iframe ads
    $('script, style, iframe, noscript, svg, nav, footer, header, .ad, .advertisement').remove();

    // Extract text content
    let cleanText = $.text() || rawHtmlOrText;

    // Remove HTML entity tags and tracking query strings
    cleanText = cleanText
      .replace(/<[^>]*>/g, '')
      .replace(/&nbsp;/g, ' ')
      .replace(/&amp;/g, '&')
      .replace(/&quot;/g, '"')
      .replace(/&#39;/g, "'")
      .replace(/\s+/g, ' ')
      .trim();

    return cleanText;
  }

  static cleanUrl(url) {
    if (!url) return '';
    try {
      const parsedUrl = new URL(url);
      // Strip utm_* tracking parameters
      const paramsToKeep = new URLSearchParams();
      parsedUrl.searchParams.forEach((val, key) => {
        if (!key.toLowerCase().startsWith('utm_') && key.toLowerCase() !== 'ref') {
          paramsToKeep.append(key, val);
        }
      });
      parsedUrl.search = paramsToKeep.toString();
      return parsedUrl.toString();
    } catch (_) {
      return url;
    }
  }
}

module.exports = ContentCleanerService;
