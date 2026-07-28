import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/router/route_names.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/custom_cached_image.dart';
import '../../../core/widgets/custom_search_bar.dart';
import '../../../core/widgets/empty_state_widget.dart';
import '../../../core/widgets/section_header.dart';
import '../../../models/news_article.dart';
import '../../../providers/search_provider.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(searchQueryProvider);
    final results = ref.watch(searchResultsProvider);
    final recentSearches = ref.watch(recentSearchesProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final trendingTags = [
      'OpenAI GPT-5',
      'T20 World Cup',
      'NVIDIA Stock',
      'Quantum Computing',
      'GTA 6 Gameplay',
      'Starship Orbital',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: CustomSearchBar(
              controller: _controller,
              hintText: 'Search 40+ news stories...',
              onChanged: (text) {
                ref.read(searchQueryProvider.notifier).state = text;
              },
              onClear: () {
                ref.read(searchQueryProvider.notifier).state = '';
              },
            ),
          ),
          Expanded(
            child: query.isEmpty
                ? SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Recent Searches
                        if (recentSearches.isNotEmpty) ...[
                          Row(
                            mainAxisAlignment: MainAlignment.spaceBetween,
                            children: [
                              Text(
                                'Recent Searches',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isDark
                                      ? AppColors.darkTextPrimary
                                      : AppColors.lightTextPrimary,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  ref.read(recentSearchesProvider.notifier).state = [];
                                },
                                child: const Text('Clear All'),
                              ),
                            ],
                          ),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: recentSearches.map((tag) {
                              return Chip(
                                label: Text(tag),
                                deleteIcon: const Icon(Icons.close, size: 16),
                                onDeleted: () {
                                  final list = [...recentSearches]..remove(tag);
                                  ref.read(recentSearchesProvider.notifier).state = list;
                                },
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 24),
                        ],
                        // Trending Topics
                        Text(
                          'Trending Topics',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.lightTextPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: trendingTags.map((topic) {
                            return ActionChip(
                              avatar: const Icon(Icons.trending_up, size: 16, color: AppColors.primary),
                              label: Text(topic),
                              onPressed: () {
                                _controller.text = topic;
                                ref.read(searchQueryProvider.notifier).state = topic;
                              },
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  )
                : results.isEmpty
                    ? const EmptyStateWidget(
                        icon: Icons.search_off_rounded,
                        title: 'No Articles Found',
                        message: 'Try searching for another keyword like "AI", "Cricket", or "Tesla".',
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        itemCount: results.length,
                        itemBuilder: (context, index) {
                          final article = results[index];
                          return _SearchResultCard(article: article);
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

class _SearchResultCard extends StatelessWidget {
  final NewsArticle article;

  const _SearchResultCard({required this.article});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => context.go(RouteNames.home),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.lightCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
        child: Row(
          children: [
            CustomCachedImage(
              imageUrl: article.imageUrl,
              width: 90,
              height: 90,
              borderRadius: BorderRadius.circular(12),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      article.category,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    article.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        article.author,
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '• ${DateFormatter.timeAgo(article.publishedAt)}',
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
