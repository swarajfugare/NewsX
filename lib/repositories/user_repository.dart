import '../core/network/api_client.dart';
import '../core/network/api_endpoints.dart';
import '../models/user_profile.dart';

class UserRepository {
  final ApiClient _apiClient = ApiClient();

  Future<UserProfile?> fetchProfile() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.profile);
      if (response.data['success'] == true) {
        final userData = response.data['data'];
        return UserProfile(
          id: '${userData['id']}',
          name: userData['name'] ?? 'Alex Morgan',
          email: userData['email'] ?? 'alex.morgan@newsx.ai',
          avatarUrl: userData['photo'] ?? 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=200&auto=format&fit=crop',
          streakDays: 14,
          totalArticlesRead: 142,
          totalBookmarks: 18,
        );
      }
    } catch (_) {}
    return null;
  }

  Future<void> updatePreferences(List<String> categories) async {
    try {
      await _apiClient.put(ApiEndpoints.preferences, data: {'categories': categories});
    } catch (_) {}
  }
}
