import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_profile.dart';
import '../constants/app_constants.dart';

class ProfileNotifier extends StateNotifier<UserProfile> {
  ProfileNotifier()
      : super(const UserProfile(
          id: 'usr_99',
          name: 'Alex Morgan',
          email: 'alex.morgan@newsx.ai',
          avatarUrl: AppConstants.defaultUserAvatar,
          streakDays: 14,
          totalArticlesRead: 142,
          totalBookmarks: 18,
        ));

  void updateName(String newName) {
    state = state.copyWith(name: newName);
  }

  void incrementReadCount() {
    state = state.copyWith(totalArticlesRead: state.totalArticlesRead + 1);
  }
}

final profileProvider = StateNotifierProvider<ProfileNotifier, UserProfile>((ref) {
  return ProfileNotifier();
});
