class AppConstants {
  AppConstants._();

  static const String appName = 'NewsX';
  static const String appTagline = 'AI Powered Smart News';
  static const String appVersion = '1.0.0';
  static const String buildNumber = '1';

  // Animation Durations
  static const Duration splashDelay = Duration(milliseconds: 2400);
  static const Duration fastAnimation = Duration(milliseconds: 200);
  static const Duration defaultAnimation = Duration(milliseconds: 350);
  static const Duration slowAnimation = Duration(milliseconds: 500);

  // Interest Categories
  static const List<String> categories = [
    'AI',
    'Technology',
    'Business',
    'Finance',
    'Startup',
    'Politics',
    'Sports',
    'Cricket',
    'Football',
    'Gaming',
    'Movies',
    'Health',
    'Science',
    'World',
    'India',
    'Education',
  ];

  // Minimal Interest Selection Requirement
  static const int minInterestsRequired = 3;

  // Placeholder URLs
  static const String defaultUserAvatar =
      'https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=500&auto=format&fit=crop';
  static const String placeholderNewsImage =
      'https://images.unsplash.com/photo-1585829365295-ab7cd400c167?q=80&w=1000&auto=format&fit=crop';
}
