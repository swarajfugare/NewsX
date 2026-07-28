import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/app_colors.dart';

class ReelsActionBar extends StatelessWidget {
  final int likesCount;
  final bool isLiked;
  final VoidCallback onLikeTap;
  final bool isBookmarked;
  final VoidCallback onBookmarkTap;
  final VoidCallback onShareTap;
  final int commentsCount;
  final VoidCallback onCommentsTap;

  const ReelsActionBar({
    super.key,
    required this.likesCount,
    required this.isLiked,
    required this.onLikeTap,
    required this.isBookmarked,
    required this.onBookmarkTap,
    required this.onShareTap,
    required this.commentsCount,
    required this.onCommentsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Like Button
        _ActionButton(
          icon: isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          iconColor: isLiked ? AppColors.accentRose : Colors.white,
          label: '$likesCount',
          onTap: onLikeTap,
          animate: isLiked,
        ),
        const SizedBox(height: 18),
        // Comment Button
        _ActionButton(
          icon: Icons.chat_bubble_outline_rounded,
          iconColor: Colors.white,
          label: '$commentsCount',
          onTap: onCommentsTap,
        ),
        const SizedBox(height: 18),
        // Bookmark Button
        _ActionButton(
          icon: isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
          iconColor: isBookmarked ? AppColors.accentAmber : Colors.white,
          label: isBookmarked ? 'Saved' : 'Save',
          onTap: onBookmarkTap,
          animate: isBookmarked,
        ),
        const SizedBox(height: 18),
        // Share Button
        _ActionButton(
          icon: Icons.share_rounded,
          iconColor: Colors.white,
          label: 'Share',
          onTap: onShareTap,
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final VoidCallback onTap;
  final bool animate;

  const _ActionButton({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.onTap,
    this.animate = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget iconWidget = Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black.withValues(alpha: 0.4),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Icon(icon, color: iconColor, size: 24),
    );

    if (animate) {
      iconWidget = iconWidget.animate().scale(
            duration: 300.ms,
            curve: Curves.elasticOut,
          );
    }

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          iconWidget,
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              shadows: [
                Shadow(blurRadius: 4, color: Colors.black45, offset: Offset(0, 1)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
