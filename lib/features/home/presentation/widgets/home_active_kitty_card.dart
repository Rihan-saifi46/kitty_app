import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../shared/widgets/badges/kitty_chit_token_pill.dart';
import '../../../../shared/widgets/buttons/kitty_primary_button.dart';
import '../../../../shared/widgets/progress/kitty_circular_progress_gauge.dart';
import '../../../dashboard/domain/entities/dashboard_summary_entity.dart';

/// Luxury emerald card showcasing the patron's active gold kitty savings scheme.
class HomeActiveKittyCard extends StatelessWidget {
  const HomeActiveKittyCard({
    super.key,
    required this.dashboard,
    required this.onSeeActiveSchemeTap,
    this.onPayTap,
    this.onDetailsTap,
  });

  final DashboardSummaryEntity dashboard;
  final VoidCallback onSeeActiveSchemeTap;
  final VoidCallback? onPayTap;
  final VoidCallback? onDetailsTap;

  @override
  Widget build(BuildContext context) {
    final int monthsPaid = dashboard.monthsPaid ?? 0;
    final int totalMonths = dashboard.totalMonths ?? 12;

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
          width: 1.2,
        ),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x0A2B2521),
            blurRadius: 18,
            offset: Offset(0, 6),
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
                    AppColors.honeyGoldAccent.withValues(alpha: 0.12),
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
                          color: AppColors.honeyGoldAccent,
                          size: 20,
                        ),
                        const SizedBox(width: 7),
                        Text(
                          'ACTIVE JEWEL PLAN',
                          style: AppTypography.kickerCaps(
                            color: AppColors.honeyGoldAccent,
                          ).copyWith(
                            fontSize: 14.5,
                            letterSpacing: 1.4,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                    if (dashboard.chitToken != null)
                      KittyChitTokenPill(
                        token: dashboard.chitToken!,
                        isDarkSurface: false,
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
                              color: AppColors.espressoCharcoal,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$monthsPaid of $totalMonths installments deposited',
                            style: AppTypography.bodySmall(
                              color: AppColors.warmTaupeBrown,
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
                      isDarkSurface: false,
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.space16),

                // See Active Scheme CTA
                KittyPrimaryButton(
                  label: 'SEE ACTIVE SCHEME',
                  backgroundColor: AppColors.honeyGoldAccent,
                  textColor: AppColors.deepUmberBronze,
                  icon: const Icon(
                    Icons.arrow_forward_rounded,
                    size: 16,
                    color: AppColors.deepUmberBronze,
                  ),
                  onPressed: onSeeActiveSchemeTap,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
