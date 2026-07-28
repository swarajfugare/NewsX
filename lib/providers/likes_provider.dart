import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/news_repository.dart';

class LikesNotifier extends StateNotifier<Map<String, int>> {
  final NewsRepository _newsRepository = NewsRepository();

  // Key: ArticleId, Value: Additional likes offset
  LikesNotifier() : super({'news_1': 1, 'news_4': 1});

  void toggleLike(String articleId) {
    final currentOffset = state[articleId] ?? 0;
    if (currentOffset > 0) {
      state = {...state, articleId: 0};
      _newsRepository.removeLike(articleId);
    } else {
      state = {...state, articleId: 1};
      _newsRepository.logLike(articleId);
    }
  }

  bool isLiked(String articleId) => (state[articleId] ?? 0) > 0;
}

final likesProvider = StateNotifierProvider<LikesNotifier, Map<String, int>>((ref) {
  return LikesNotifier();
});
