import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';

/// Contextual statutory KYC compliance reminder banner shown when KYC is pending or incomplete.
class HomeKycReminderBanner extends StatelessWidget {
  const HomeKycReminderBanner({
    super.key,
    required this.onVerifyTap,
    this.isRejected = false,
  });

  final VoidCallback onVerifyTap;
  final bool isRejected;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.space16,
        vertical: AppSpacing.space6,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.space14,
        vertical: AppSpacing.space10,
      ),
      decoration: BoxDecoration(
        color: isRejected
            ? AppColors.statusErrorBg
            : AppColors.goldSubtle,
        borderRadius: AppRadius.border12,
        border: Border.all(
          color: isRejected
              ? AppColors.statusErrorBorder
              : AppColors.goldBorder.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Row(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: isRejected
                  ? AppColors.statusErrorBorder
                  : AppColors.goldPrimary.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isRejected
                  ? Icons.error_outline_rounded
                  : Icons.shield_outlined,
              color: isRejected ? AppColors.statusErrorText : AppColors.goldPrimary,
              size: 18,
            ),
          ),
          const SizedBox(width: AppSpacing.space10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  isRejected ? 'KYC Verification Needed' : 'Statutory KYC Pending',
                  style: AppTypography.bodySmall(
                    color: AppColors.textPrimaryLight,
                  ).copyWith(fontWeight: FontWeight.w700),
                ),
                Text(
                  isRejected
                      ? 'Please re-upload your document to enable payouts.'
                      : 'Complete your 1-min KYC to activate full scheme maturity.',
                  style: AppTypography.labelMeta(
                    color: AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.space8),
          InkWell(
            onTap: onVerifyTap,
            borderRadius: AppRadius.border10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: isRejected ? AppColors.statusErrorText : AppColors.goldPrimary,
                borderRadius: AppRadius.border10,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'VERIFY',
                    style: AppTypography.labelMeta(
                      color: isRejected ? Colors.white : AppColors.deepEmeraldBase,
                    ).copyWith(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(width: 2),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 10,
                    color: isRejected ? Colors.white : AppColors.deepEmeraldBase,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
