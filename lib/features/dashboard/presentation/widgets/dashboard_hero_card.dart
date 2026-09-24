import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/enums/app_enums.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../shared/widgets/badges/kitty_chit_token_pill.dart';
import '../../../../shared/widgets/progress/kitty_circular_progress_gauge.dart';
import '../../domain/entities/dashboard_summary_entity.dart';

/// Luxury emerald hero card showcasing the patron's active gold kitty scheme,
/// circular progress gauge, and bonus month privilege.
class DashboardHeroCard extends StatelessWidget {
  const DashboardHeroCard({
    super.key,
    required this.dashboard,
  });

  final DashboardSummaryEntity dashboard;

  @override
  Widget build(BuildContext context) {
    final int monthsPaid = dashboard.monthsPaid ?? 0;
    final int totalMonths = dashboard.totalMonths ?? 12;
    final int monthlyEmi = dashboard.customMonthlyEmi ?? 5000;
    final int remainingPayable = dashboard.remainingMonthsPayable;
    final String schemeName = dashboard.schemeName ?? 'Swastik Suvarna Varsha';
    final String chitToken = dashboard.chitToken ?? '#SW-042';

    final String statusLabel = switch (dashboard.status) {
      MembershipStatusEnum.preJoin => 'PRE-JOIN ENROLLED',
      MembershipStatusEnum.completed => 'SCHEME COMPLETED',
      MembershipStatusEnum.winner => 'CHIT WINNER',
      _ => 'ACTIVE SCHEME',
    };

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.space16,
        vertical: AppSpacing.space8,
      ),
      decoration: BoxDecoration(
        color: AppColors.creamIvoryCard,
        borderRadius: AppRadius.border20,
        border: Border.all(
          color: AppColors.warmLinenInset,
          width: 1.5,
        ),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x0A2B2521),
            blurRadius: 20,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: <Widget>[
          // Ambient Radial Glow
          Positioned(
            top: -40,
            right: -30,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: <Color>[
                    AppColors.honeyGoldAccent.withValues(alpha: 0.12),
                    Colors.transparent,
                  ],
                  stops: const <double>[0.0, 0.8],
                ),
              ),
            ),
          ),

          // Main Card Content
          Padding(
            padding: const EdgeInsets.all(AppSpacing.space20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // 1. Status Badges Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.champagneFoil,
                        borderRadius: AppRadius.border20,
                        border: Border.all(
                          color: AppColors.honeyGoldAccent.withValues(alpha: 0.35),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.honeyGoldAccent,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            statusLabel,
                            style: AppTypography.labelMeta(
                              color: AppColors.espressoCharcoal,
                            ).copyWith(
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ],
                      ),
                    ),
                    KittyChitTokenPill(
                      token: chitToken,
                      isDarkSurface: false,
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.space16),

                // 2. Scheme Title & Jewelry Visual
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            schemeName,
                            style: AppTypography.cardTitle(
                              color: AppColors.espressoCharcoal,
                            ).copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.4,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$totalMonths-Month Gold Kitty Privileges',
                            style: AppTypography.bodySmall(
                              color: AppColors.warmTaupeBrown,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.warmLinenInset,
                              borderRadius: AppRadius.border6,
                              border: Border.all(
                                color: AppColors.warmLinenInset,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  'Monthly Installment: ',
                                  style: AppTypography.labelMeta(
                                    color: AppColors.warmTaupeBrown,
                                  ),
                                ),
                                Text(
                                  CurrencyFormatter.formatRupees(monthlyEmi),
                                  style: AppTypography.labelMeta(
                                    color: AppColors.espressoCharcoal,
                                  ).copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: AppSpacing.space12),

                    // Gold Ring Graphic Placeholder
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: AppColors.warmLinenInset,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.warmLinenInset,
                          width: 1,
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.diamond_outlined,
                          color: AppColors.honeyGoldAccent,
                          size: 34,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.space20),

                // 3. Warm Progress Panel
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.space16,
                    vertical: AppSpacing.space14,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.warmLinenInset,
                    borderRadius: AppRadius.border20,
                    border: Border.all(
                      color: AppColors.warmLinenInset,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: <Widget>[
                      // Circular Gauge
                      KittyCircularProgressGauge(
                        currentValue: monthsPaid,
                        totalValue: totalMonths,
                        size: 92,
                        strokeWidth: 7.5,
                        subtitle: 'EMIS PAID',
                        isDarkSurface: false,
                      ),

                      // Vertical Divider
                      Container(
                        width: 1,
                        height: 54,
                        color: AppColors.warmTaupeBrown.withValues(alpha: 0.2),
                        margin: const EdgeInsets.symmetric(horizontal: AppSpacing.space16),
                      ),

                      // Progress Summary & Gift Badge
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    remainingPayable > 0
                                        ? '$remainingPayable to Pay'
                                        : (dashboard.isCompleted ? 'Completed' : '1 to Pay'),
                                    style: AppTypography.cardTitle(
                                      color: AppColors.espressoCharcoal,
                                    ).copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    '✧ 1 Bonus Month Free',
                                    style: AppTypography.labelMeta(
                                      color: AppColors.honeyGoldAccent,
                                    ).copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Gift Icon Circle
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Container(
                                  width: 38,
                                  height: 38,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.champagneFoil,
                                    border: Border.all(
                                      color: AppColors.honeyGoldAccent.withValues(alpha: 0.35),
                                      width: 1,
                                    ),
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.card_giftcard,
                                      color: AppColors.honeyGoldAccent,
                                      size: 18,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  'BONUS\nMONTH',
                                  textAlign: TextAlign.center,
                                  style: AppTypography.kickerCaps(
                                    color: AppColors.warmTaupeBrown,
                                  ).copyWith(
                                    fontSize: 8,
                                    fontWeight: FontWeight.w700,
                                    height: 1.1,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
