import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../models/news_article.dart';

class NewsArticleCard extends StatefulWidget {
  final NewsArticle article;
  final bool isBookmarked;
  final VoidCallback onBookmarkTap;
  final VoidCallback onShareTap;
  final VoidCallback onTap;

  const NewsArticleCard({
    super.key,
    required this.article,
    required this.isBookmarked,
    required this.onBookmarkTap,
    required this.onShareTap,
    required this.onTap,
  });

  @override
  State<NewsArticleCard> createState() => _NewsArticleCardState();
}

class _NewsArticleCardState extends State<NewsArticleCard> {
  bool _isLiked = false;
  int _likeCount = 124;

  @override
  void initState() {
    super.initState();
    _likeCount = widget.article.likes;
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
      _likeCount += _isLiked ? 1 : -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // 1. Large Featured Background Image
        CachedNetworkImage(
          imageUrl: widget.article.imageUrl,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: const Color(0xFF1E1E2E),
            child: const Center(
              child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            color: const Color(0xFF1E1E2E),
            child: const Icon(Icons.newspaper_rounded, size: 64, color: Colors.white38),
          ),
        ),

        // 2. High Contrast Gradient Overlay for Perfect Legibility
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black87,
                Colors.transparent,
                Colors.black54,
                Colors.black,
              ],
              stops: [0.0, 0.25, 0.60, 1.0],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),

        // 3. Right Interactive Floating Action Column
        Positioned(
          right: 16,
          bottom: 120,
          child: Column(
            children: [
              // Like Button
              _ActionButton(
                icon: _isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                color: _isLiked ? AppColors.accentRose : Colors.white,
                label: '$_likeCount',
                onTap: _toggleLike,
              ),
              const SizedBox(height: 18),

              // Bookmark Button
              _ActionButton(
                icon: widget.isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_outline_rounded,
                color: widget.isBookmarked ? AppColors.accentAmber : Colors.white,
                label: 'Save',
                onTap: widget.onBookmarkTap,
              ),
              const SizedBox(height: 18),

              // Share Button
              _ActionButton(
                icon: Icons.share_rounded,
                color: Colors.white,
                label: 'Share',
                onTap: widget.onShareTap,
              ),
            ],
          ).animate().fadeIn(duration: 400.ms).slideX(begin: 0.3, end: 0),
        ),

        // 4. Main Article Content (Headline, 25-Word Summary, Metadata)
        Positioned(
          left: 20,
          right: 76,
          bottom: 40,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Category Chip & Source
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.4),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Text(
                      widget.article.category.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      '•  ${widget.article.author}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ],
              ).animate().fadeIn().slideY(begin: 0.2, end: 0),

              const SizedBox(height: 12),

              // Headline
              Text(
                widget.article.title,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  height: 1.25,
                  letterSpacing: -0.3,
                ),
              ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.2, end: 0),

              const SizedBox(height: 10),

              // 25-Word AI Summary
              Text(
                widget.article.summary,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0),

              const SizedBox(height: 16),

              // Read Full Story Action Banner
              GestureDetector(
                onTap: widget.onTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Read Full Article',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 6),
                      Icon(Icons.arrow_forward_rounded, size: 16, color: Colors.white),
                    ],
                  ),
                ),
              ).animate().fadeIn(delay: 300.ms),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.color,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black45,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white24),
            ),
            child: Icon(icon, size: 26, color: color),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
