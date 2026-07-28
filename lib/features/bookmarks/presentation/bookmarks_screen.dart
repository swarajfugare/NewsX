import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/router/route_names.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/custom_cached_image.dart';
import '../../../core/widgets/empty_state_widget.dart';
import '../../../models/news_article.dart';
import '../../../providers/bookmarks_provider.dart';
import '../../../providers/news_provider.dart';

class BookmarksScreen extends ConsumerWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarkedIds = ref.watch(bookmarksProvider);
    final allArticles = ref.watch(rawNewsArticlesProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final savedArticles =
        allArticles.where((a) => bookmarkedIds.contains(a.id)).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Bookmarks'),
        actions: [
          if (savedArticles.isNotEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Text(
                  '${savedArticles.length} Saved',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: savedArticles.isEmpty
          ? EmptyStateWidget(
              icon: Icons.bookmark_border_rounded,
              title: 'No Bookmarks Yet',
              message:
                  'Articles you bookmark while swiping will appear here for easy offline reading.',
              actionLabel: 'Explore News',
              onAction: () => context.go(RouteNames.home),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: savedArticles.length,
              itemBuilder: (context, index) {
                final article = savedArticles[index];
                return _BookmarkTile(article: article);
              },
            ),
    );
  }
}

class _BookmarkTile extends ConsumerWidget {
  final NewsArticle article;

  const _BookmarkTile({required this.article});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: CustomCachedImage(
          imageUrl: article.imageUrl,
          width: 70,
          height: 70,
          borderRadius: BorderRadius.circular(12),
        ),
        title: Text(
          article.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Row(
            children: [
              Text(
                article.category,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
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
        ),
        trailing: IconButton(
          icon: const Icon(Icons.bookmark_remove_rounded, color: AppColors.accentRose),
          onPressed: () {
            ref.read(bookmarksProvider.notifier).toggleBookmark(article.id);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Removed from bookmarks'),
                duration: Duration(seconds: 1),
              ),
            );
          },
        ),
        onTap: () => context.go(RouteNames.home),
      ),
    );
  }
}
