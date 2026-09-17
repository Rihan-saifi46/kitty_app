import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../auth/domain/entities/user_entity.dart';

/// Luxury Customer Profile Card displayed at the top of the Settings & Profile screen.
/// Strictly presents canonical fields from [UserEntity]: Name, Phone, Email, Tier, KYC status.
class PatronProfileCard extends StatelessWidget {
  const PatronProfileCard({
    required this.user,
    super.key,
  });

  final UserEntity? user;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final String name = user?.name.isNotEmpty == true ? user!.name : 'Patron';
    final String phone = user?.phone.isNotEmpty == true ? user!.phone : '+91 98765 43210';
    final String? email = user?.email;
    final String tier = user?.tier.isNotEmpty == true ? user!.tier : 'Tier 1 Verified Member';
    final bool isKycVerified = user?.kyc.isVerified == true;

    final Color cardBg = isDark ? AppColors.emeraldCard : Colors.white;
    final Color cardBorder = isDark ? AppColors.emeraldBorder : const Color(0xFFEAECEF);
    final Color titleColor = isDark ? AppColors.textPrimaryLight : const Color(0xFF0F172A);
    final Color subColor = isDark ? AppColors.emeraldTextSubtle : const Color(0xFF64748B);

    return Container(
      padding: AppSpacing.all16,
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: AppRadius.border20,
        border: Border.all(color: cardBorder),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          // Royal Monogram Avatar
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.goldSubtle,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.goldBorder,
                width: 1.5,
              ),
            ),
            child: Center(
              child: Text(
                name.isNotEmpty ? name[0].toUpperCase() : 'P',
                style: AppTypography.displaySubtitle(
                  color: AppColors.goldPrimary,
                ).copyWith(fontSize: 22, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.space14),

          // User Metadata Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Flexible(
                      child: Text(
                        name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: titleColor,
                          letterSpacing: 0.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    if (isKycVerified)
                      const Tooltip(
                        message: 'KYC Verified Patron',
                        child: Icon(
                          Icons.verified_rounded,
                          size: 16,
                          color: AppColors.goldPrimary,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  phone,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: subColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (email != null && email.isNotEmpty) ...<Widget>[
                  const SizedBox(height: 2),
                  Text(
                    email,
                    style: TextStyle(
                      fontSize: 11.5,
                      color: subColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
                  decoration: BoxDecoration(
                    color: AppColors.goldSubtle,
                    borderRadius: AppRadius.border12,
                    border: Border.all(
                      color: AppColors.goldBorder.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Text(
                    tier,
                    style: AppTypography.kickerCaps(
                      color: isDark ? AppColors.goldLight : AppColors.goldPrimary,
                    ).copyWith(fontSize: 9.5, letterSpacing: 0.5),
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
