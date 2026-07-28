import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/bookmark_repository.dart';

class BookmarksNotifier extends StateNotifier<Set<String>> {
  final BookmarkRepository _bookmarkRepository = BookmarkRepository();

  BookmarksNotifier() : super({'news_1', 'news_3', 'news_5'}) {
    _loadFromBackend();
  }

  Future<void> _loadFromBackend() async {
    final remoteBookmarks = await _bookmarkRepository.fetchBookmarks();
    if (remoteBookmarks.isNotEmpty) {
      state = {...state, ...remoteBookmarks};
    }
  }

  void toggleBookmark(String articleId) {
    if (state.contains(articleId)) {
      state = {...state}..remove(articleId);
      _bookmarkRepository.removeBookmark(articleId);
    } else {
      state = {...state, articleId};
      _bookmarkRepository.addBookmark(articleId);
    }
  }

  bool isBookmarked(String articleId) => state.contains(articleId);
}

final bookmarksProvider = StateNotifierProvider<BookmarksNotifier, Set<String>>((ref) {
  return BookmarksNotifier();
});
