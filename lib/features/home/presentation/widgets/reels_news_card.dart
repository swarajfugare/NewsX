import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/custom_cached_image.dart';
import '../../../../models/news_article.dart';
import 'reels_action_bar.dart';

class ReelsNewsCard extends StatefulWidget {
  final NewsArticle article;
  final bool isLiked;
  final int totalLikes;
  final VoidCallback onLikeTap;
  final bool isBookmarked;
  final VoidCallback onBookmarkTap;
  final VoidCallback onShareTap;

  const ReelsNewsCard({
    super.key,
    required this.article,
    required this.isLiked,
    required this.totalLikes,
    required this.onLikeTap,
    required this.isBookmarked,
    required this.onBookmarkTap,
    required this.onShareTap,
  });

  @override
  State<ReelsNewsCard> createState() => _ReelsNewsCardState();
}

class _ReelsNewsCardState extends State<ReelsNewsCard> {
  String _selectedLang = 'English'; // English, Hindi, Marathi

  void _showWhyItMattersSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.darkSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.psychology_rounded, color: AppColors.primary, size: 24),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Why It Matters (Gemini AI)',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.12)),
                ),
                child: Text(
                  widget.article.whyItMatters ?? 'Key technological shift driving next-generation AI workflows.',
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.45,
                    color: Colors.white90,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                children: widget.article.tags.map((tag) {
                  return Chip(
                    backgroundColor: AppColors.primary.withOpacity(0.15),
                    label: Text('#$tag', style: const TextStyle(color: AppColors.secondary, fontSize: 12)),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final displaySummary = widget.article.getDisplaySummary(_selectedLang);

    return GestureDetector(
      onDoubleTap: widget.onLikeTap,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background High-Res Image
          CustomCachedImage(
            imageUrl: widget.article.imageUrl,
            width: size.width,
            height: size.height,
            fit: BoxFit.cover,
          ),
          // Dark Gradient Overlay for Readability
          Container(
            decoration: const BoxDecoration(
              gradient: AppColors.reelsOverlayGradient,
            ),
          ),
          // Top Bar Badges
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAlignment.spaceBetween,
              children: [
                // Category Chip
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.4),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Text(
                    widget.article.category.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                // Language Selector Pills (EN | HI | MR)
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: Row(
                    children: ['EN', 'HI', 'MR'].map((langCode) {
                      final langName = langCode == 'EN' ? 'English' : (langCode == 'HI' ? 'Hindi' : 'Marathi');
                      final isSelected = _selectedLang == langName;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedLang = langName),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.secondary : Colors.transparent,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            langCode,
                            style: TextStyle(
                              color: isSelected ? Colors.black : Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          // Bottom Content & Right Action Bar
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Text Content Area
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Source & Time
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 12,
                            backgroundImage: NetworkImage(widget.article.authorAvatar),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            widget.article.author,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 4,
                            height: 4,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white54,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            DateFormatter.timeAgo(widget.article.publishedAt),
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ).animate().fadeIn().slideY(begin: 0.2, end: 0),
                      const SizedBox(height: 12),
                      // Bold Headline
                      Text(
                        widget.article.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          height: 1.25,
                        ),
                      ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.2, end: 0),
                      const SizedBox(height: 10),
                      // Interactive Why It Matters Pill
                      GestureDetector(
                        onTap: () => _showWhyItMattersSheet(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppColors.primary, AppColors.secondary],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.auto_awesome_rounded, size: 12, color: Colors.white),
                              SizedBox(width: 6),
                              Text(
                                'WHY IT MATTERS',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              Icon(Icons.chevron_right, size: 14, color: Colors.white),
                            ],
                          ),
                        ),
                      ).animate().fadeIn(delay: 150.ms),
                      const SizedBox(height: 10),
                      // 25-Word Summary Card (Multi-lingual EN/HI/MR)
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.45),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white.withOpacity(0.15)),
                        ),
                        child: Text(
                          displaySummary,
                          style: const TextStyle(
                            color: Colors.white90,
                            fontSize: 14,
                            height: 1.45,
                            letterSpacing: 0.1,
                          ),
                        ),
                      ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                // Action Bar
                ReelsActionBar(
                  likesCount: widget.totalLikes,
                  isLiked: widget.isLiked,
                  onLikeTap: widget.onLikeTap,
                  isBookmarked: widget.isBookmarked,
                  onBookmarkTap: widget.onBookmarkTap,
                  onShareTap: widget.onShareTap,
                  commentsCount: widget.article.commentsCount,
                  onCommentsTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Comments section'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
