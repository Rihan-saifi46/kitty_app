import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Centralized typography definitions for Kitty App.
///
/// Implements the classical Indian heritage luxury pairing:
/// - [Cinzel] for brand prestige, royal hero titles, and scheme branding.
/// - [Plus Jakarta Sans] for high-density financial UI, passbook tables, and body copy.
abstract final class AppTypography {
  // ---------------------------------------------------------------------------
  // Display & Hero Titles (Cinzel - Heritage Serif)
  // ---------------------------------------------------------------------------

  /// Section titles and scheme branding names (26px, Bold, Tracking: -0.2px).
  static TextStyle displayBrand({
    Color color = AppColors.textPrimaryDark,
  }) {
    return GoogleFonts.cinzel(
      fontSize: 26,
      fontWeight: FontWeight.w700,
      height: 1.25,
      letterSpacing: -0.2,
      color: color,
    );
  }

  /// Active scheme pass title and hero banners (22px, Bold, Tracking: +0.4px).
  static TextStyle heroTitle({
    Color color = AppColors.textPrimaryLight,
  }) {
    return GoogleFonts.cinzel(
      fontSize: 22,
      fontWeight: FontWeight.w700,
      height: 1.30,
      letterSpacing: 0.4,
      color: color,
    );
  }

  /// Secondary serif subtitle (18px, SemiBold).
  static TextStyle displaySubtitle({
    Color color = AppColors.goldPrimary,
  }) {
    return GoogleFonts.cinzel(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      height: 1.30,
      letterSpacing: 0.3,
      color: color,
    );
  }

  // ---------------------------------------------------------------------------
  // Headings & Card Titles (Plus Jakarta Sans - Geometric Sans-Serif)
  // ---------------------------------------------------------------------------

  /// Card title and screen sub-headers (17px, Bold, Tracking: 0.0px).
  static TextStyle cardTitle({
    Color color = AppColors.textPrimaryDark,
  }) {
    return GoogleFonts.plusJakartaSans(
      fontSize: 17,
      fontWeight: FontWeight.w700,
      height: 1.35,
      letterSpacing: 0.0,
      color: color,
    );
  }

  /// Section heading (15px, SemiBold).
  static TextStyle sectionHeading({
    Color color = AppColors.textPrimaryDark,
  }) {
    return GoogleFonts.plusJakartaSans(
      fontSize: 15,
      fontWeight: FontWeight.w600,
      height: 1.35,
      color: color,
    );
  }

  // ---------------------------------------------------------------------------
  // Body Text & Button Labels (Plus Jakarta Sans)
  // ---------------------------------------------------------------------------

  /// Primary button labels and table text (14px, Bold, Tracking: +0.2px).
  static TextStyle bodyBold({
    Color color = AppColors.textPrimaryDark,
  }) {
    return GoogleFonts.plusJakartaSans(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      height: 1.40,
      letterSpacing: 0.2,
      color: color,
    );
  }

  /// Descriptions, financial notes, and general body copy (13.5px, Medium).
  static TextStyle bodyRegular({
    Color color = AppColors.textSecondaryMuted,
  }) {
    return GoogleFonts.plusJakartaSans(
      fontSize: 13.5,
      fontWeight: FontWeight.w500,
      height: 1.50,
      letterSpacing: 0.0,
      color: color,
    );
  }

  /// Compact body text for secondary notes (12px, Regular).
  static TextStyle bodySmall({
    Color color = AppColors.textSecondaryMuted,
  }) {
    return GoogleFonts.plusJakartaSans(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      height: 1.40,
      color: color,
    );
  }

  // ---------------------------------------------------------------------------
  // Labels, Meta, & Badges (Plus Jakarta Sans)
  // ---------------------------------------------------------------------------

  /// Table headers and secondary stats labels (11.5px, SemiBold, Tracking: +0.6px).
  static TextStyle labelMeta({
    Color color = AppColors.textSecondaryMuted,
  }) {
    return GoogleFonts.plusJakartaSans(
      fontSize: 11.5,
      fontWeight: FontWeight.w600,
      height: 1.30,
      letterSpacing: 0.6,
      color: color,
    );
  }

  /// Eyebrow badges and uppercase chips (10px, ExtraBold, Tracking: +1.8px).
  static TextStyle kickerCaps({
    Color color = AppColors.goldPrimary,
  }) {
    return GoogleFonts.plusJakartaSans(
      fontSize: 10,
      fontWeight: FontWeight.w800,
      height: 1.20,
      letterSpacing: 1.8,
      color: color,
    );
  }

  /// Primary gold CTA uppercase button text (14px, ExtraBold, Tracking: +1.2px).
  static TextStyle buttonGoldCta({
    Color color = AppColors.emeraldCard,
  }) {
    return GoogleFonts.plusJakartaSans(
      fontSize: 14,
      fontWeight: FontWeight.w800,
      height: 1.20,
      letterSpacing: 1.2,
      color: color,
    );
  }

  /// Financial currency and amount display (20px, Bold, Tracking: -0.4px).
  static TextStyle amountDisplay({
    Color color = AppColors.textPrimaryDark,
  }) {
    return GoogleFonts.plusJakartaSans(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      height: 1.20,
      letterSpacing: -0.4,
      color: color,
    );
  }
}
