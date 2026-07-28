import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/router/route_names.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/interest_chip.dart';
import '../../../providers/interests_provider.dart';

class InterestSelectionScreen extends ConsumerWidget {
  const InterestSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedInterests = ref.watch(interestsProvider);
    final interestsNotifier = ref.read(interestsProvider.notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final selectedCount = selectedInterests.length;
    final isValid = selectedCount >= AppConstants.minInterestsRequired;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Interests'),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: isValid
                      ? AppColors.accentEmerald.withOpacity(0.2)
                      : AppColors.accentAmber.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$selectedCount / ${AppConstants.minInterestsRequired} selected',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isValid ? AppColors.accentEmerald : AppColors.accentAmber,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Text(
                'Select at least ${AppConstants.minInterestsRequired} topics to customize your personal AI news stream.',
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2.5,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: AppConstants.categories.length,
                itemBuilder: (context, index) {
                  final category = AppConstants.categories[index];
                  final isSelected = interestsNotifier.isSelected(category);
                  return InterestChip(
                    title: category,
                    isSelected: isSelected,
                    onTap: () => interestsNotifier.toggleInterest(category),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: CustomButton(
                label: 'Continue to News Feed',
                onPressed: isValid ? () => context.go(RouteNames.home) : null,
                icon: Icons.arrow_forward_rounded,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
