import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/category_chip.dart';
import '../../../core/widgets/loading_skeleton.dart';
import '../../../providers/bookmarks_provider.dart';
import '../../../providers/likes_provider.dart';
import '../../../providers/news_provider.dart';
import '../../../providers/personalised_feed_provider.dart';
import '../../../repositories/personalisation_repository.dart';
import 'widgets/reels_news_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late PageController _pageController;
  final PersonalisationRepository _personalisationRepo = PersonalisationRepository();
  DateTime? _articleOpenTime;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _articleOpenTime = DateTime.now();
  }

  @override
  void dispose() {
    _logCurrentReadDuration();
    _pageController.dispose();
    super.dispose();
  }

  void _logCurrentReadDuration() {
    if (_articleOpenTime != null) {
      final duration = DateTime.now().difference(_articleOpenTime!).inSeconds;
      if (duration > 2) {
        final feedState = ref.read(personalisedFeedProvider);
        if (_currentIndex < feedState.articles.length) {
          final article = feedState.articles[_currentIndex];
          _personalisationRepo.trackReadingDuration(article.id, duration);
        }
      }
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

  @override
  Widget build(BuildContext context) {
    final feedState = ref.watch(personalisedFeedProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final likes = ref.watch(likesProvider);

    final categories = ['All', 'AI', 'Technology', 'Cricket', 'Science', 'Business', 'Sports', 'Startup', 'World', 'India'];

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Main Vertical News Reels PageView
          feedState.isLoading
              ? const Center(
                  child: LoadingSkeleton(width: double.infinity, height: double.infinity),
                )
              : PageView.builder(
                  controller: _pageController,
                  scrollDirection: Axis.vertical,
                  itemCount: feedState.articles.length,
                  onPageChanged: (index) {
                    _logCurrentReadDuration();
                    _articleOpenTime = DateTime.now();
                    _currentIndex = index;

                    // Smart Prefetching when user reaches 3 items before the end
                    if (index >= feedState.articles.length - 3) {
                      ref.read(personalisedFeedProvider.notifier).prefetchNextPage();
                    }
                  },
                  itemBuilder: (context, index) {
                    final article = feedState.articles[index];
                    final isBookmarked = ref.read(bookmarksProvider.notifier).isBookmarked(article.id);
                    final isLiked = ref.read(likesProvider.notifier).isLiked(article.id);
                    final likeOffset = likes[article.id] ?? 0;
                    final totalLikes = article.likes + likeOffset;

                    return ReelsNewsCard(
                      article: article,
                      isLiked: isLiked,
                      totalLikes: totalLikes,
                      onLikeTap: () => ref.read(likesProvider.notifier).toggleLike(article.id),
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
                    );
                  },
                ),
          // Top Floating Category Carousel
          Positioned(
            top: 50,
            left: 0,
            right: 0,
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
                      if (_pageController.hasClients) {
                        _pageController.jumpToPage(0);
                      }
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
