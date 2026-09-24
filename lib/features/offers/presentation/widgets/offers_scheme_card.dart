import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../domain/entities/scheme_entity.dart';

/// Card component representing a single Gold Kitty Savings Scheme plan.
///
/// Matches `.offer-page-plan-card` in `offers.html`.
class OffersSchemeCard extends StatelessWidget {
  const OffersSchemeCard({
    super.key,
    required this.scheme,
    required this.onEnrollTap,
  });

  final SchemeEntity scheme;
  final ValueChanged<SchemeEntity> onEnrollTap;

  @override
  Widget build(BuildContext context) {
    final String formattedMonthly =
        CurrencyFormatter.formatRupees(scheme.monthlyInstallment);
    final String durationSub =
        '${scheme.durationMonths} Months • Monthly $formattedMonthly';

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.space16),
      decoration: BoxDecoration(
        color: AppColors.creamIvoryCard,
        borderRadius: AppRadius.border20,
        border: Border.all(
          color: scheme.isPopular
              ? AppColors.honeyGoldAccent.withValues(alpha: 0.6)
              : AppColors.warmLinenInset,
          width: scheme.isPopular ? 1.5 : 1.2,
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
          Padding(
            padding: const EdgeInsets.all(AppSpacing.space20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Header (Title & Duration)
                Padding(
                  padding: EdgeInsets.only(
                    right: scheme.isPopular ? 85.0 : 0.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        scheme.name,
                        style: AppTypography.cardTitle(color: AppColors.espressoCharcoal)
                            .copyWith(
                          fontFamily: 'Cinzel',
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        durationSub,
                        style: AppTypography.bodySmall(
                          color: AppColors.warmTaupeBrown,
                        ).copyWith(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.space14),

                // Bonus Callout Box
                _buildBonusBox(),
                const SizedBox(height: AppSpacing.space16),

                // Benefits List
                ...scheme.benefits.map((String benefit) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 9),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 18,
                          height: 18,
                          margin: const EdgeInsets.only(top: 2),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.champagneFoil,
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            '✓',
                            style: TextStyle(
                              color: AppColors.deepUmberBronze,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            benefit,
                            style: AppTypography.bodySmall(
                              color: AppColors.warmTaupeBrown,
                            ).copyWith(
                              fontSize: 12,
                              height: 1.35,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: AppSpacing.space14),

                // Enrollment CTA Button
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => onEnrollTap(scheme),
                      borderRadius: AppRadius.border12,
                      child: Ink(
                        decoration: const BoxDecoration(
                          color: AppColors.deepUmberBronze,
                          borderRadius: AppRadius.border12,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              _getCtaLabel(),
                              style: const TextStyle(
                                color: AppColors.champagneFoil,
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.8,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.arrow_forward_rounded,
                              color: AppColors.champagneFoil,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Most Popular Tag
          if (scheme.isPopular)
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.champagneFoil,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: AppColors.honeyGoldAccent.withValues(alpha: 0.4),
                  ),
                ),
                child: const Text(
                  'MOST POPULAR',
                  style: TextStyle(
                    color: AppColors.deepUmberBronze,
                    fontSize: 9.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBonusBox() {
    String bonusHighlight = '1 Month Free Jeweler Bonus Deposit';
    if (scheme.durationMonths == 18) {
      bonusHighlight = '2 Months Free Sponsored + ₹25,000 Diamond Gift';
    } else if (scheme.durationMonths == 6) {
      bonusHighlight = '50% Sponsored Bonus on Month 6';
    } else if (scheme.benefits.isNotEmpty) {
      bonusHighlight = scheme.benefits.first;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: AppColors.warmLinenInset,
        borderRadius: AppRadius.border12,
        border: Border.all(
          color: AppColors.warmLinenInset,
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            '✦ ',
            style: TextStyle(
              color: AppColors.honeyGoldAccent,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  color: AppColors.espressoCharcoal,
                  fontSize: 12,
                  height: 1.4,
                ),
                children: <TextSpan>[
                  const TextSpan(
                    text: 'Bonus Privilege: ',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: AppColors.honeyGoldAccent,
                    ),
                  ),
                  TextSpan(text: bonusHighlight),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getCtaLabel() {
    if (scheme.durationMonths == 12) {
      return 'Start 12-Month Kitty';
    } else if (scheme.durationMonths == 18) {
      return 'Enquire Bridal Kitty';
    } else if (scheme.durationMonths == 6) {
      return 'Start Express Kitty';
    }
    return 'Explore Plan';
  }
}
