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
        gradient: const LinearGradient(
          begin: Alignment(-0.8, -0.6),
          end: Alignment(0.8, 0.6),
          colors: <Color>[
            Color(0xFF092B22),
            Color(0xFF051A14),
          ],
        ),
        borderRadius: AppRadius.border20,
        border: Border.all(
          color: scheme.isPopular
              ? AppColors.goldPrimary.withValues(alpha: 0.5)
              : AppColors.goldPrimary.withValues(alpha: 0.25),
          width: scheme.isPopular ? 1.5 : 1,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: const Color(0xFF092B22).withValues(alpha: 0.28),
            blurRadius: 28,
            offset: const Offset(0, 10),
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
                        style: AppTypography.cardTitle(color: Colors.white)
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
                          color: Colors.white.withValues(alpha: 0.9),
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
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.goldPrimary.withValues(alpha: 0.2),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            '✓',
                            style: TextStyle(
                              color: AppColors.goldPrimary,
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
                              color: const Color(0xFFD1DCD6),
                            ).copyWith(
                              fontSize: 12,
                              height: 1.45,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: AppSpacing.space14),

                // CTA Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () => onEnrollTap(scheme),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: const RoundedRectangleBorder(
                        borderRadius: AppRadius.border12,
                      ),
                    ),
                    child: Ink(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: <Color>[
                            Color(0xFFE6C275),
                            Color(0xFFCCA043),
                          ],
                        ),
                        borderRadius: AppRadius.border12,
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              _getCtaLabel(),
                              style: const TextStyle(
                                color: Color(0xFF092B22),
                                fontSize: 13.5,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.4,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.arrow_forward_rounded,
                              color: Color(0xFF092B22),
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
                  color: AppColors.goldPrimary,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: const <BoxShadow>[
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: const Text(
                  'MOST POPULAR',
                  style: TextStyle(
                    color: Color(0xFF092B22),
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
        color: const Color(0xFF061F18),
        borderRadius: AppRadius.border12,
        border: Border.all(
          color: AppColors.goldPrimary.withValues(alpha: 0.8),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            '✦ ',
            style: TextStyle(
              color: AppColors.goldPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  color: Color(0xFFFDE68A),
                  fontSize: 12,
                  height: 1.4,
                ),
                children: <TextSpan>[
                  const TextSpan(
                    text: 'Bonus Privilege: ',
                    style: TextStyle(fontWeight: FontWeight.w800),
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
