import 'package:flutter/material.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../shared/widgets/feedback/kitty_shimmer.dart';
import '../../../../shared/widgets/feedback/kitty_skeleton.dart';

/// Shimmer skeleton loader mirroring the Home screen layout.
class HomeSkeletonLoader extends StatelessWidget {
  const HomeSkeletonLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return KittyShimmer(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // 1. Greeting Bar Skeleton
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.space16),
              child: Row(
                children: <Widget>[
                  KittySkeletonBox(
                    width: 46,
                    height: 46,
                    borderRadius: BorderRadius.all(Radius.circular(23)),
                    isDarkSurface: true,
                  ),
                  SizedBox(width: AppSpacing.space12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        KittySkeletonText(width: 80, height: 10, isDarkSurface: true),
                        SizedBox(height: 6),
                        KittySkeletonText(width: 140, height: 16, isDarkSurface: true),
                      ],
                    ),
                  ),
                  KittySkeletonBox(
                    width: 90,
                    height: 26,
                    borderRadius: BorderRadius.all(Radius.circular(13)),
                    isDarkSurface: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.space16),

            // 2. Active Kitty Card Skeleton
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space16),
              child: Container(
                height: 210,
                decoration: const BoxDecoration(
                  color: Color(0xFF092B22),
                  borderRadius: AppRadius.border20,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.space20),

            // 3. Category Horizontal Track Skeleton
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List<Widget>.generate(5, (int index) {
                  return const Column(
                    children: <Widget>[
                      KittySkeletonBox(
                        width: 56,
                        height: 56,
                        borderRadius: BorderRadius.all(Radius.circular(28)),
                        isDarkSurface: true,
                      ),
                      SizedBox(height: 6),
                      KittySkeletonText(width: 44, height: 10, isDarkSurface: true),
                    ],
                  );
                }),
              ),
            ),
            const SizedBox(height: AppSpacing.space24),

            // 4. Curated Product Grid Skeleton (2 Columns)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space16),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      height: 220,
                      decoration: const BoxDecoration(
                        color: Color(0xFF092B22),
                        borderRadius: AppRadius.border16,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.space12),
                  Expanded(
                    child: Container(
                      height: 220,
                      decoration: const BoxDecoration(
                        color: Color(0xFF092B22),
                        borderRadius: AppRadius.border16,
                      ),
                    ),
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
