import 'package:shared_preferences/shared_preferences.dart';
import '../core/network/api_client.dart';
import '../core/storage/local_cache_service.dart';
import '../models/news_article.dart';

class PersonalisationRepository {
  final ApiClient _apiClient = ApiClient();

  Future<List<NewsArticle>> fetchPersonalisedFeed({int limit = 40, int offset = 0, String? language}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lang = language ?? prefs.getString('newsx_preferred_language') ?? 'English';

      final response = await _apiClient.get(
        '/news/personalised',
        queryParameters: {'limit': limit, 'offset': offset, 'language': lang},
      );
      if (response.data['success'] == true) {
        final List list = response.data['data'];
        final articles = list.map((json) => NewsArticle.fromJson(json)).toList();
        if (offset == 0 && articles.isNotEmpty) {
          LocalCacheService.cacheArticles(articles);
        }
        return articles;
      }
    } catch (_) {
      if (offset == 0) {
        return LocalCacheService.getCachedArticles();
      }
    }
    return [];
  }

  Future<List<NewsArticle>> fetchDailyDigest() async {
    try {
      final response = await _apiClient.get('/news/daily-digest');
      if (response.data['success'] == true) {
        final List list = response.data['data'];
        return list.map((json) => NewsArticle.fromJson(json)).toList();
      }
    } catch (_) {}
    return [];
  }

  Future<List<String>> fetchTrendingTopics() async {
    try {
      final response = await _apiClient.get('/news/trending-topics');
      if (response.data['success'] == true) {
        final List list = response.data['data'];
        return list.map((e) => e.toString()).toList();
      }
    } catch (_) {}
    return ['Cricket World Cup', 'Indian Economy', 'AI Revolution', 'Technology', 'ISRO Space Mission'];
  }

  Future<void> trackReadingDuration(String newsId, int durationSeconds) async {
    try {
      await _apiClient.post(
        '/history',
        data: {'news_id': newsId, 'reading_time': '${durationSeconds}s'},
      );
    } catch (_) {}
  }
}
