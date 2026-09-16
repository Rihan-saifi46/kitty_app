import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';

/// Luxury Hero Header for the Kitty Offers & Product Catalog screen.
///
/// Matches the hero styling in `offers.html` while preserving `'Kitty Offers & Plans'`
/// for backward navigation test compatibility.
class OffersHeroHeader extends StatelessWidget {
  const OffersHeroHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Top section title for backward navigation test compatibility
        Text(
          'Kitty Offers & Plans',
          style: AppTypography.cardTitle(
            color: AppColors.textSecondaryMuted,
          ).copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 13,
            letterSpacing: 0.6,
          ),
        ),
        const SizedBox(height: AppSpacing.space10),

        // Eyebrow Pill
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.goldPrimary.withValues(alpha: 0.12),
            borderRadius: AppRadius.borderPill,
            border: Border.all(
              color: AppColors.goldPrimary.withValues(alpha: 0.28),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                '✦ ',
                style: TextStyle(
                  color: AppColors.goldPrimary,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'EXCLUSIVE PRIVILEGES',
                style: AppTypography.bodySmall(
                  color: AppColors.goldPrimary,
                ).copyWith(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.space10),

        // Page Title
        Text(
          'Curated Gold Kitty Plans',
          style: AppTypography.heroTitle(
            color: AppColors.textPrimaryDark,
          ).copyWith(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.2,
          ),
        ),
        const SizedBox(height: AppSpacing.space6),

        // Subtitle
        Text(
          'Start a new gold accumulation cycle with guaranteed jeweler bonuses and locked-in 24K bullion rates.',
          style: AppTypography.bodySmall(
            color: AppColors.textSecondaryMuted,
          ).copyWith(
            height: 1.45,
            fontSize: 12.5,
          ),
        ),
      ],
    );
  }
}
