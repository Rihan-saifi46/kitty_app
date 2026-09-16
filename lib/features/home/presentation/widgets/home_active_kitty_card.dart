import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../shared/widgets/badges/kitty_chit_token_pill.dart';
import '../../../../shared/widgets/buttons/kitty_primary_button.dart';
import '../../../../shared/widgets/progress/kitty_circular_progress_gauge.dart';
import '../../../dashboard/domain/entities/dashboard_summary_entity.dart';

/// Luxury emerald card showcasing the patron's active gold kitty savings scheme.
class HomeActiveKittyCard extends StatelessWidget {
  const HomeActiveKittyCard({
    super.key,
    required this.dashboard,
    required this.onPayTap,
    this.onDetailsTap,
  });

  final DashboardSummaryEntity dashboard;
  final VoidCallback onPayTap;
  final VoidCallback? onDetailsTap;

  @override
  Widget build(BuildContext context) {
    final int monthsPaid = dashboard.monthsPaid ?? 0;
    final int totalMonths = dashboard.totalMonths ?? 12;
    final int totalPaid = dashboard.totalPaidAmount ?? (monthsPaid * (dashboard.customMonthlyEmi ?? 5000));
    final int targetAmount = dashboard.targetAmount ?? (totalMonths * (dashboard.customMonthlyEmi ?? 5000));
    final int monthlyEmi = dashboard.customMonthlyEmi ?? 5000;
    final String nextDueStr = dashboard.nextInstallment != null
        ? DateFormatter.formatUtcToIst(dashboard.nextInstallment!.dueDate)
        : '15 Sep 2026';

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.space16,
        vertical: AppSpacing.space8,
      ),
      decoration: BoxDecoration(
        color: AppColors.emeraldCard,
        borderRadius: AppRadius.border20,
        border: Border.all(
          color: AppColors.goldBorder.withValues(alpha: 0.5),
          width: 1,
        ),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x38000000),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: <Widget>[
          // Ambient Radial Glow
          Positioned(
            top: -40,
            right: -40,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: <Color>[
                    AppColors.goldPrimary.withValues(alpha: 0.22),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(AppSpacing.space16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Top Bar: Kicker + Chit Token
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        const Icon(
                          Icons.stars_rounded,
                          color: AppColors.goldPrimary,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'ACTIVE JEWEL PLAN',
                          style: AppTypography.kickerCaps(
                            color: AppColors.goldPrimary,
                          ).copyWith(letterSpacing: 1.6),
                        ),
                      ],
                    ),
                    if (dashboard.chitToken != null)
                      KittyChitTokenPill(
                        token: dashboard.chitToken!,
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.space12),

                // Hero Row: Plan Name + Circular Gauge
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            dashboard.schemeName ?? 'Swastik Suvarna Varsha',
                            style: AppTypography.cardTitle(
                              color: AppColors.textPrimaryLight,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$monthsPaid of $totalMonths installments deposited',
                            style: AppTypography.bodySmall(
                              color: AppColors.textSecondaryLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.space12),
                    KittyCircularProgressGauge(
                      currentValue: monthsPaid,
                      totalValue: totalMonths,
                      size: 64,
                      strokeWidth: 5.5,
                      showPercentageInCenter: true,
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.space16),

                // Metrics Grid (2x2)
                Container(
                  padding: const EdgeInsets.all(AppSpacing.space12),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.22),
                    borderRadius: AppRadius.border12,
                    border: Border.all(
                      color: AppColors.goldBorder.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: <Widget>[
                      // Left Column: Total Deposited & Target
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'TOTAL DEPOSITED',
                              style: AppTypography.labelMeta(
                                color: AppColors.emeraldTextSubtle,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              CurrencyFormatter.formatRupees(totalPaid),
                              style: AppTypography.bodyBold(
                                color: AppColors.goldLight,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'MATURITY VALUE',
                              style: AppTypography.labelMeta(
                                color: AppColors.emeraldTextSubtle,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              CurrencyFormatter.formatRupees(targetAmount),
                              style: AppTypography.bodyRegular(
                                color: AppColors.textPrimaryLight,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        width: 1,
                        height: 64,
                        color: AppColors.goldBorder.withValues(alpha: 0.2),
                      ),
                      const SizedBox(width: AppSpacing.space12),

                      // Right Column: Monthly EMI & Next Due
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'MONTHLY EMI',
                              style: AppTypography.labelMeta(
                                color: AppColors.emeraldTextSubtle,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              CurrencyFormatter.formatRupees(monthlyEmi),
                              style: AppTypography.bodyBold(
                                color: AppColors.textPrimaryLight,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'NEXT DUE DATE',
                              style: AppTypography.labelMeta(
                                color: AppColors.emeraldTextSubtle,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              nextDueStr,
                              style: AppTypography.bodyRegular(
                                color: AppColors.goldLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.space16),

                // Pay Installment CTA
                KittyPrimaryButton(
                  label: 'PAY INSTALLMENT',
                  icon: const Icon(
                    Icons.lock_outline_rounded,
                    size: 16,
                    color: AppColors.deepEmeraldBase,
                  ),
                  onPressed: onPayTap,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
