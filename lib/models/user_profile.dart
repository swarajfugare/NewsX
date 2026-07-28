class UserProfile {
  final String id;
  final String name;
  final String email;
  final String avatarUrl;
  final int streakDays;
  final int totalArticlesRead;
  final int totalBookmarks;

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.avatarUrl,
    required this.streakDays,
    required this.totalArticlesRead,
    required this.totalBookmarks,
  });

  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    String? avatarUrl,
    int? streakDays,
    int? totalArticlesRead,
    int? totalBookmarks,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      streakDays: streakDays ?? this.streakDays,
      totalArticlesRead: totalArticlesRead ?? this.totalArticlesRead,
      totalBookmarks: totalBookmarks ?? this.totalBookmarks,
    );
  }
}
