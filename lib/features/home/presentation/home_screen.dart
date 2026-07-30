import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/router/route_names.dart';
import '../../../core/widgets/category_chip.dart';
import '../../../core/widgets/loading_skeleton.dart';
import '../../../models/news_article.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/bookmarks_provider.dart';
import '../../../providers/news_provider.dart';
import '../../../providers/personalised_feed_provider.dart';
import 'widgets/news_article_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index, int totalArticles) {
    if (index >= totalArticles - 3) {
      ref.read(personalisedFeedProvider.notifier).prefetchNextPage();
    }
  }

  Future<void> _shareArticle(NewsArticle article) async {
    final text = '${article.title}\n\n${article.summary}\n\nRead more at ${article.author}: ${article.sourceUrl}';
    await Share.share(text, subject: article.title);
  }

  Future<void> _openOriginalPublisher(NewsArticle article) async {
    final uri = Uri.parse(article.sourceUrl.isNotEmpty ? article.sourceUrl : 'https://news.google.com');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
      }
    } catch (e) {
      debugPrint('Error launching publisher URL: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final feedState = ref.watch(personalisedFeedProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final authState = ref.watch(authProvider);

    final categories = [
      'All',
      'AI',
      'Technology',
      'Business',
      'Sports',
      'Cricket',
      'Politics',
      'Science',
      'Health',
      'Entertainment',
      'World',
      'India'
    ];

    final articles = feedState.articles;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Endless Vertical NewsPulse Swipe Player (PageView.builder)
          feedState.isLoading && articles.isEmpty
              ? const Center(
                  child: LoadingSkeleton(width: double.infinity, height: double.infinity),
                )
              : RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: () async {
                    await ref.read(personalisedFeedProvider.notifier).loadFeed();
                  },
                  child: PageView.builder(
                    controller: _pageController,
                    scrollDirection: Axis.vertical,
                    itemCount: articles.length,
                    onPageChanged: (index) => _onPageChanged(index, articles.length),
                    itemBuilder: (context, index) {
                      final article = articles[index];
                      final isBookmarked = ref.read(bookmarksProvider.notifier).isBookmarked(article.id);

                      return NewsArticleCard(
                        article: article,
                        isBookmarked: isBookmarked,
                        onBookmarkTap: () {
                          if (authState.isGuest) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Guest users cannot save bookmarks. Please sign in.'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                            return;
                          }
                          ref.read(bookmarksProvider.notifier).toggleBookmark(article.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                isBookmarked ? 'Removed from Bookmarks' : 'Saved to Bookmarks',
                              ),
                              duration: const Duration(milliseconds: 1200),
                            ),
                          );
                        },
                        onShareTap: () => _shareArticle(article),
                        onTap: () => _openOriginalPublisher(article),
                      );
                    },
                  ),
                ),

          // 2. Top Floating NewsPulse Header Overlay (Brand Title + Search + Category Selector)
          SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.bolt_rounded, color: Colors.white, size: 20),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'NewsPulse',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.search_rounded, color: Colors.white),
                            onPressed: () => context.go(RouteNames.search),
                          ),
                          if (authState.isGuest)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white24,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'GUEST',
                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Category Selector Chips Horizontal Bar
                SizedBox(
                  height: 36,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final cat = categories[index];
                      return CategoryChip(
                        label: cat,
                        isSelected: selectedCategory == cat,
                        onTap: () {
                          ref.read(selectedCategoryProvider.notifier).state = cat;
                          ref.read(personalisedFeedProvider.notifier).loadFeed();
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
