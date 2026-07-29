import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/app_constants.dart';
import '../models/user_profile.dart';
import 'auth_provider.dart';

class ProfileNotifier extends StateNotifier<UserProfile> {
  ProfileNotifier()
      : super(const UserProfile(
          id: 'usr_guest',
          name: 'News Reader',
          email: 'reader@newsx.ai',
          avatarUrl: AppConstants.defaultUserAvatar,
          streakDays: 1,
          totalArticlesRead: 0,
          totalBookmarks: 0,
        ));

  void setUserProfile({
    required String id,
    required String name,
    required String email,
    required String avatarUrl,
  }) {
    state = state.copyWith(
      id: id,
      name: name,
      email: email,
      avatarUrl: avatarUrl.isNotEmpty ? avatarUrl : AppConstants.defaultUserAvatar,
    );
  }

  void updateName(String newName) {
    state = state.copyWith(name: newName);
  }

  void incrementReadCount() {
    state = state.copyWith(totalArticlesRead: state.totalArticlesRead + 1);
  }
}

final profileProvider = StateNotifierProvider<ProfileNotifier, UserProfile>((ref) {
  final notifier = ProfileNotifier();
  ref.listen<AuthState>(authProvider, (previous, next) {
    final firebaseUser = next.firebaseUser;
    final backendProfile = next.userProfile;

    if (firebaseUser != null) {
      notifier.setUserProfile(
        id: firebaseUser.uid,
        name: firebaseUser.displayName ?? (firebaseUser.email?.split('@')[0] ?? 'News Reader'),
        email: firebaseUser.email ?? 'user@newsx.ai',
        avatarUrl: firebaseUser.photoURL ?? AppConstants.defaultUserAvatar,
      );
    } else if (backendProfile != null) {
      notifier.setUserProfile(
        id: (backendProfile['id'] ?? backendProfile['firebase_uid'] ?? 'usr_guest').toString(),
        name: (backendProfile['name'] ?? 'News Reader').toString(),
        email: (backendProfile['email'] ?? 'reader@newsx.ai').toString(),
        avatarUrl: (backendProfile['photo'] ?? AppConstants.defaultUserAvatar).toString(),
      );
    }
  });
  return notifier;
});
