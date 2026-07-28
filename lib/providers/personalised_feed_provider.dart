import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/news_article.dart';
import '../repositories/news_repository.dart';
import '../repositories/personalisation_repository.dart';
import 'news_provider.dart';

class PersonalisedFeedState {
  final List<NewsArticle> articles;
  final bool isLoading;
  final bool isPrefetching;
  final String? errorMessage;
  final int pageOffset;

  const PersonalisedFeedState({
    required this.articles,
    this.isLoading = false,
    this.isPrefetching = false,
    this.errorMessage,
    this.pageOffset = 0,
  });

  PersonalisedFeedState copyWith({
    List<NewsArticle>? articles,
    bool? isLoading,
    bool? isPrefetching,
    String? errorMessage,
    int? pageOffset,
  }) {
    return PersonalisedFeedState(
      articles: articles ?? this.articles,
      isLoading: isLoading ?? this.isLoading,
      isPrefetching: isPrefetching ?? this.isPrefetching,
      errorMessage: errorMessage,
      pageOffset: pageOffset ?? this.pageOffset,
    );
  }
}

class PersonalisedFeedNotifier extends StateNotifier<PersonalisedFeedState> {
  final PersonalisationRepository _repo = PersonalisationRepository();
  final NewsRepository _newsRepo = NewsRepository();
  final Ref _ref;

  PersonalisedFeedNotifier(this._ref)
      : super(const PersonalisedFeedState(articles: [], isLoading: true)) {
    loadFeed();
  }

  Future<void> loadFeed() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final selectedCategory = _ref.read(selectedCategoryProvider);

    List<NewsArticle> fetched = [];
    if (selectedCategory == 'All') {
      fetched = await _repo.fetchPersonalisedFeed(limit: 20, offset: 0);
    } else {
      fetched = await _newsRepo.fetchCategoryNews(selectedCategory);
    }

    // Fallback to sample dataset if backend is offline or empty
    if (fetched.isEmpty) {
      fetched = _ref.read(rawNewsArticlesProvider);
    }

    state = state.copyWith(
      articles: fetched,
      isLoading: false,
      pageOffset: fetched.length,
    );
  }

  Future<void> prefetchNextPage() async {
    if (state.isPrefetching) return;
    state = state.copyWith(isPrefetching: true);

    final selectedCategory = _ref.read(selectedCategoryProvider);
    List<NewsArticle> newArticles = [];

    if (selectedCategory == 'All') {
      newArticles = await _repo.fetchPersonalisedFeed(limit: 20, offset: state.pageOffset);
    }

    if (newArticles.isNotEmpty) {
      state = state.copyWith(
        articles: [...state.articles, ...newArticles],
        pageOffset: state.pageOffset + newArticles.length,
        isPrefetching: false,
      );
    } else {
      state = state.copyWith(isPrefetching: false);
    }
  }
}

final personalisedFeedProvider =
    StateNotifierProvider<PersonalisedFeedNotifier, PersonalisedFeedState>((ref) {
  return PersonalisedFeedNotifier(ref);
});
