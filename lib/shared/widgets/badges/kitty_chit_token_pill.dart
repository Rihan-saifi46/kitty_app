import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';

/// Reusable chit token identifier pill for Kitty App.
///
/// Displays canonical token identifiers like `#SW-042`.
/// Supports both dark emerald surface and light surface styling.
class KittyChitTokenPill extends StatelessWidget {
  const KittyChitTokenPill({
    super.key,
    required this.token,
    this.isDarkSurface = true,
    this.fontSize = 11.0,
  });

  /// Chit token string (e.g. "#SW-042").
  final String token;

  /// Surface mode.
  final bool isDarkSurface;

  /// Font size.
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.space8,
        vertical: 3.5,
      ),
      decoration: BoxDecoration(
        color: isDarkSurface
            ? AppColors.goldSubtle
            : AppColors.champagneFoil,
        borderRadius: BorderRadius.circular(AppRadius.radiusPill),
        border: Border.all(
          color: isDarkSurface
              ? AppColors.goldBorder
              : AppColors.honeyGoldAccent.withValues(alpha: 0.35),
          width: 1.0,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            Icons.tag,
            size: 11,
            color: isDarkSurface ? AppColors.goldPrimary : AppColors.honeyGoldAccent,
          ),
          const SizedBox(width: 2),
          Text(
            token,
            style: GoogleFonts.plusJakartaSans(
              fontSize: fontSize,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
              color: isDarkSurface
                  ? AppColors.goldLight
                  : AppColors.espressoCharcoal,
            ),
          ),
        ],
      ),
    );
  }
}
