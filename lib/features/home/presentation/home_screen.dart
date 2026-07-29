import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/router/route_names.dart';
import '../../../core/widgets/category_chip.dart';
import '../../../core/widgets/loading_skeleton.dart';
import '../../../models/news_article.dart';
import '../../../providers/bookmarks_provider.dart';
import '../../../providers/news_provider.dart';
import '../../../providers/personalised_feed_provider.dart';
import 'widgets/breaking_news_ticker.dart';
import 'widgets/hero_featured_carousel.dart';
import 'widgets/news_article_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 400) {
      ref.read(personalisedFeedProvider.notifier).prefetchNextPage();
    }
  }

  void _shareArticle(String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing: "$title"'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _openArticleDetail(NewsArticle article) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening: ${article.title}'),
        duration: const Duration(milliseconds: 1000),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final feedState = ref.watch(personalisedFeedProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);

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
    final featuredArticles = articles.take(3).toList();
    final feedArticles = articles.skip(3).toList();
    final breakingHeadline = articles.isNotEmpty ? articles.first.title : 'AI Engine Ingesting Latest Global News...';

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.flash_on_rounded, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            const Text(
              'NewsX',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () => context.go(RouteNames.search),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('No new breaking news notifications.'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(personalisedFeedProvider.notifier).loadFeed();
        },
        child: feedState.isLoading && articles.isEmpty
            ? ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: 4,
                itemBuilder: (context, index) => const Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: LoadingSkeleton(width: double.infinity, height: 260),
                ),
              )
            : CustomScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                slivers: [
                  // Breaking News Banner Ticker
                  SliverToBoxAdapter(
                    child: BreakingNewsTicker(
                      text: breakingHeadline,
                      onTap: () {
                        if (articles.isNotEmpty) _openArticleDetail(articles.first);
                      },
                    ),
                  ),

                  // Hero Featured Story Carousel
                  if (featuredArticles.isNotEmpty) ...[
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(left: 16, top: 8, bottom: 8),
                        child: Text(
                          'Top Headlines',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: HeroFeaturedCarousel(
                        articles: featuredArticles,
                        onArticleTap: _openArticleDetail,
                      ),
                    ),
                  ],

                  // Category Selector Sticky Bar
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: SizedBox(
                        height: 38,
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
                    ),
                  ),

                  // Section Title
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(left: 16, bottom: 12),
                      child: Text(
                        'Latest News Feed',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  // Main Scrollable News Article List Feed
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          if (index < feedArticles.length) {
                            final article = feedArticles[index];
                            final isBookmarked = ref.read(bookmarksProvider.notifier).isBookmarked(article.id);

                            return NewsArticleCard(
                              article: article,
                              isBookmarked: isBookmarked,
                              onBookmarkTap: () {
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
                              onShareTap: () => _shareArticle(article.title),
                              onTap: () => _openArticleDetail(article),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                        childCount: feedArticles.length,
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(
                    child: SizedBox(height: 32),
                  ),
                ],
              ),
      ),
    );
  }
}
