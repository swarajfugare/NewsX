import '../core/network/api_client.dart';
import '../core/network/api_endpoints.dart';
import '../models/news_article.dart';

class NewsRepository {
  final ApiClient _apiClient = ApiClient();

  Future<List<NewsArticle>> fetchLatestNews() async {
    try {
      final response = await _apiClient.get('/news/latest');
      if (response.data['success'] == true) {
        final List list = response.data['data'];
        return list.map((json) => NewsArticle.fromJson(json)).toList();
      }
    } catch (_) {}
    return [];
  }

  Future<List<NewsArticle>> fetchTrendingNews() async {
    try {
      final response = await _apiClient.get('/news/trending');
      if (response.data['success'] == true) {
        final List list = response.data['data'];
        return list.map((json) => NewsArticle.fromJson(json)).toList();
      }
    } catch (_) {}
    return [];
  }

  Future<List<NewsArticle>> fetchCategoryNews(String categorySlug) async {
    try {
      final response = await _apiClient.get('/news/category/$categorySlug');
      if (response.data['success'] == true) {
        final List list = response.data['data'];
        return list.map((json) => NewsArticle.fromJson(json)).toList();
      }
    } catch (_) {}
    return [];
  }

  Future<List<NewsArticle>> searchNews({
    String? keyword,
    String? category,
    String? language,
  }) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.search,
        queryParameters: {
          if (keyword != null && keyword.isNotEmpty) 'keyword': keyword,
          if (category != null && category != 'All') 'category': category,
          if (language != null) 'language': language,
        },
      );
      if (response.data['success'] == true) {
        final List list = response.data['data'];
        return list.map((json) => NewsArticle.fromJson(json)).toList();
      }
    } catch (_) {}
    return [];
  }

  Future<void> logShare(String newsId) async {
    try {
      await _apiClient.post(ApiEndpoints.shares, data: {'news_id': newsId});
    } catch (_) {}
  }

  Future<void> logLike(String newsId) async {
    try {
      await _apiClient.post(ApiEndpoints.likes, data: {'news_id': newsId});
    } catch (_) {}
  }

  Future<void> removeLike(String newsId) async {
    try {
      await _apiClient.delete('${ApiEndpoints.likes}/$newsId');
    } catch (_) {}
  }

  Future<void> logReadingHistory(String newsId) async {
    try {
      await _apiClient.post(ApiEndpoints.history, data: {'news_id': newsId, 'reading_time': '1 min'});
    } catch (_) {}
  }
}
