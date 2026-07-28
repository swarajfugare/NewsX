import '../core/network/api_client.dart';
import '../core/network/api_endpoints.dart';

class BookmarkRepository {
  final ApiClient _apiClient = ApiClient();

  Future<List<String>> fetchBookmarks() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.bookmarks);
      if (response.data['success'] == true) {
        final List list = response.data['data'];
        return list.map((item) => item['news_id'] as String).toList();
      }
    } catch (_) {}
    return [];
  }

  Future<void> addBookmark(String newsId) async {
    try {
      await _apiClient.post(ApiEndpoints.bookmarks, data: {'news_id': newsId});
    } catch (_) {}
  }

  Future<void> removeBookmark(String newsId) async {
    try {
      await _apiClient.delete('${ApiEndpoints.bookmarks}/$newsId');
    } catch (_) {}
  }
}
