import '../core/network/api_client.dart';
import '../core/network/api_endpoints.dart';
import '../models/user_profile.dart';

class AuthRepository {
  final ApiClient _apiClient = ApiClient();

  Future<UserProfile?> loginWithFirebaseToken(String firebaseToken) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.login,
        data: {'firebaseToken': firebaseToken},
      );
      if (response.data['success'] == true) {
        final userData = response.data['data']['user'];
        final token = response.data['data']['token'];
        if (token != null) {
          _apiClient.setAuthToken(token);
        }
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
    } catch (_) {
      // Offline fallback
    }
    return null;
  }

  Future<void> logout() async {
    try {
      await _apiClient.post(ApiEndpoints.logout);
    } catch (_) {}
    _apiClient.clearAuthToken();
  }
}
