import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/news_article.dart';

class LocalCacheService {
  static const String _cachedNewsKey = 'cached_news_reels';

  static Future<void> cacheArticles(List<NewsArticle> articles) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = articles.map((a) => a.toJson()).toList();
      await prefs.setString(_cachedNewsKey, jsonEncode(jsonList));
    } catch (_) {}
  }

  static Future<List<NewsArticle>> getCachedArticles() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_cachedNewsKey);
      if (jsonString != null && jsonString.isNotEmpty) {
        final List list = jsonDecode(jsonString);
        return list.map((json) => NewsArticle.fromJson(json)).toList();
      }
    } catch (_) {}
    return [];
  }
}
