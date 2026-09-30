import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../shared/widgets/badges/kitty_status_badge.dart';
import '../../../../shared/widgets/buttons/kitty_primary_button.dart';
import '../../domain/entities/scheme_entity.dart';
import 'kitty_plan_detail_sheet.dart';

/// Card component representing a single Gold Savings Scheme plan.
///
/// Implements the approved benefit-first presentation:
/// - Prominent 11+1 bonus calculation callout
/// - Clear monthly deposit and total maturity value
/// - Key benefits checklist
/// - "View Plan Details & Rules" trigger for the slide-up sheet
/// - Standard 52px primary Start Kitty CTA
class OffersSchemeCard extends StatelessWidget {
  const OffersSchemeCard({
    super.key,
    required this.scheme,
    required this.onEnrollTap,
    this.onDetailsTap,
  });

  final SchemeEntity scheme;
  final ValueChanged<SchemeEntity> onEnrollTap;
  final ValueChanged<SchemeEntity>? onDetailsTap;

  @override
  Widget build(BuildContext context) {
    final String formattedMonthly =
        CurrencyFormatter.formatRupees(scheme.monthlyInstallment);
    final String durationSub =
        '${scheme.durationMonths} Months • Monthly $formattedMonthly';

    final int customerMonths = scheme.durationMonths == 12
        ? 11
        : scheme.durationMonths == 18
            ? 16
            : (scheme.durationMonths - 1).clamp(1, scheme.durationMonths);
    final int bonusMonths = scheme.durationMonths - customerMonths;
    final int customerDeposit = customerMonths * scheme.monthlyInstallment;
    final int bonusGift = bonusMonths * scheme.monthlyInstallment;
    final int totalMaturity = customerDeposit + bonusGift;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.space16),
      decoration: BoxDecoration(
        color: AppColors.creamIvoryCard,
        borderRadius: AppRadius.border20,
        border: Border.all(
          color: scheme.isPopular ? AppColors.honeyGoldAccent : AppColors.warmLinenInset,
          width: scheme.isPopular ? 1.6 : 1.2,
        ),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x0D063D2E),
            blurRadius: 14,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: AppRadius.border20,
        child: InkWell(
          onTap: () => _openDetailsSheet(context),
          borderRadius: AppRadius.border20,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.space20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Header (Title & Badge)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            scheme.name,
                            style: AppTypography.cardTitle(
                              color: AppColors.espressoCharcoal,
                            ).copyWith(
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
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      alignment: WrapAlignment.end,
                      children: <Widget>[
                        if (scheme.isPopular)
                          const KittyStatusBadge(
                            status: KittyInstallmentStatus.bonus,
                            customLabel: 'POPULAR SAVINGS',
                          ),
                        if (scheme.durationMonths == 12)
                          const KittyStatusBadge(
                            status: KittyInstallmentStatus.active,
                            customLabel: '11+1 PLAN',
                          ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.space14),

                // Benefit-First Mathematics Callout Banner
                _buildBonusMathBanner(
                  customerMonths: customerMonths,
                  bonusMonths: bonusMonths,
                  customerDeposit: customerDeposit,
                  bonusGift: bonusGift,
                  totalMaturity: totalMaturity,
                ),
                const SizedBox(height: AppSpacing.space14),

                // Benefits List
                ...scheme.benefits.take(3).map((String benefit) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
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
                const SizedBox(height: AppSpacing.space8),

                // View Plan Rules & Details link
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: () => _openDetailsSheet(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    icon: const Text(
                      'View Plan Details & Rules',
                      style: TextStyle(
                        color: AppColors.goldPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    label: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 11,
                      color: AppColors.goldPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.space12),

                // Enrollment CTA Button (52px height)
                KittyPrimaryButton(
                  label: _getCtaLabel(),
                  height: 52,
                  icon: const Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                  onPressed: () => onEnrollTap(scheme),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openDetailsSheet(BuildContext context) {
    if (onDetailsTap != null) {
      onDetailsTap!(scheme);
    } else {
      KittyPlanDetailSheet.show(
        context,
        scheme: scheme,
        onStartKitty: onEnrollTap,
      );
    }
  }

  Widget _buildBonusMathBanner({
    required int customerMonths,
    required int bonusMonths,
    required int customerDeposit,
    required int bonusGift,
    required int totalMaturity,
  }) {
    final String formulaText = scheme.durationMonths == 12
        ? '✦ 11 + 1 SWASTIK BONUS BENEFIT'
        : scheme.durationMonths == 18
            ? '✦ 16 + 2 SWASTIK ROYAL BONUS'
            : '✦ EXPRESS SAVINGS ADVANTAGE';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.space12),
      decoration: BoxDecoration(
        color: AppColors.champagneFoil.withValues(alpha: 0.35),
        borderRadius: AppRadius.border12,
        border: Border.all(
          color: AppColors.honeyGoldAccent.withValues(alpha: 0.6),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            formulaText,
            style: const TextStyle(
              color: AppColors.deepUmberBronze,
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'You Pay ($customerMonths mo)',
                      style: const TextStyle(
                        color: AppColors.warmTaupeBrown,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      CurrencyFormatter.formatRupees(customerDeposit),
                      style: const TextStyle(
                        color: AppColors.espressoCharcoal,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  '+',
                  style: TextStyle(
                    color: AppColors.goldPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Bonus ($bonusMonths mo)',
                      style: const TextStyle(
                        color: AppColors.primaryEmerald,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '+${CurrencyFormatter.formatRupees(bonusGift)}',
                      style: const TextStyle(
                        color: AppColors.primaryEmerald,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  '=',
                  style: TextStyle(
                    color: AppColors.goldPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    const Text(
                      'Total Value',
                      style: TextStyle(
                        color: AppColors.warmTaupeBrown,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      CurrencyFormatter.formatRupees(totalMaturity),
                      style: const TextStyle(
                        color: AppColors.deepUmberBronze,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getCtaLabel() {
    if (scheme.durationMonths == 12) {
      return 'Start 12-Month Gold Scheme';
    } else if (scheme.durationMonths == 18) {
      return 'Enquire Bridal Gold Scheme';
    } else if (scheme.durationMonths == 6) {
      return 'Start Express Gold Scheme';
    }
    return 'Start Kitty Plan';
  }
}
