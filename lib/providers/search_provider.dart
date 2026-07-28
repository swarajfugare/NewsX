import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/news_article.dart';
import 'news_provider.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

final recentSearchesProvider = StateProvider<List<String>>((ref) => [
  'Artificial Intelligence',
  'Cricket World Cup',
  'Quantum Computing',
  'Stock Market Today',
  'SpaceX Starship',
]);

final searchResultsProvider = Provider<List<NewsArticle>>((ref) {
  final query = ref.watch(searchQueryProvider).trim().toLowerCase();
  final articles = ref.watch(rawNewsArticlesProvider);

  if (query.isEmpty) return [];

  return articles.where((article) {
    return article.title.toLowerCase().contains(query) ||
        article.summary.toLowerCase().contains(query) ||
        article.category.toLowerCase().contains(query) ||
        article.author.toLowerCase().contains(query);
  }).toList();
});
