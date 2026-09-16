import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../domain/entities/gold_rate_entity.dart';

/// Compact gold rate benchmark and BIS hallmarking trust strip.
class HomeGoldRateStrip extends StatelessWidget {
  const HomeGoldRateStrip({
    super.key,
    this.goldRate,
  });

  final LiveGoldRateEntity? goldRate;

  @override
  Widget build(BuildContext context) {
    final double rate24k = goldRate?.ratePerGram ?? 7120.500;
    final double rate22k = rate24k * (22 / 24);

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.space16,
        vertical: AppSpacing.space8,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.space14,
        vertical: AppSpacing.space12,
      ),
      decoration: BoxDecoration(
        color: AppColors.emeraldCard,
        borderRadius: AppRadius.border16,
        border: Border.all(
          color: AppColors.goldBorder.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: <Widget>[
          // Gold Coin Icon Badge
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.goldSubtle,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.goldBorder.withValues(alpha: 0.5),
                width: 1,
              ),
            ),
            child: const Icon(
              Icons.monetization_on_outlined,
              color: AppColors.goldPrimary,
              size: 20,
            ),
          ),
          const SizedBox(width: AppSpacing.space12),

          // Rates
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  "TODAY'S GOLD RATE (PER G)",
                  style: AppTypography.kickerCaps(
                    color: AppColors.goldPrimary,
                  ).copyWith(letterSpacing: 1.2),
                ),
                const SizedBox(height: 2),
                Row(
                  children: <Widget>[
                    Text(
                      '22K: ${CurrencyFormatter.formatRupees(rate22k.round())}',
                      style: AppTypography.bodySmall(
                        color: AppColors.textPrimaryLight,
                      ).copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '•',
                      style: TextStyle(
                        color: AppColors.goldBorder.withValues(alpha: 0.6),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '24K: ${CurrencyFormatter.formatRupees(rate24k.round())}',
                      style: AppTypography.bodySmall(
                        color: AppColors.goldLight,
                      ).copyWith(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // BIS Hallmark Guarantee
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Icon(
                    Icons.check_circle_rounded,
                    color: AppColors.statusSuccessText,
                    size: 13,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    '100% BIS',
                    style: AppTypography.labelMeta(
                      color: AppColors.statusSuccessText,
                    ).copyWith(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                'Hallmarked',
                style: AppTypography.labelMeta(
                  color: AppColors.textSecondaryLight,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
