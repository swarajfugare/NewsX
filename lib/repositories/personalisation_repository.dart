import '../core/network/api_client.dart';
import '../core/storage/local_cache_service.dart';
import '../models/news_article.dart';

class PersonalisationRepository {
  final ApiClient _apiClient = ApiClient();

  Future<List<NewsArticle>> fetchPersonalisedFeed({int limit = 40, int offset = 0}) async {
    try {
      final response = await _apiClient.get(
        '/news/personalised',
        queryParameters: {'limit': limit, 'offset': offset},
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
      // Offline Reading Fallback
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
    return ['OpenAI GPT-5', 'Cricket World Cup', 'NVIDIA Stock', 'Quantum Computing'];
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
