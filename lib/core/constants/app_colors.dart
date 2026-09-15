import 'package:flutter/material.dart';

/// Centralized color design tokens for Kitty App.
///
/// Implements the Royal Indian Heritage Luxury palette with Deep Emerald Forest (#05241C)
/// and Metallic Gold (#C59B27), paired with crisp light surfaces for financial clarity.
abstract final class AppColors {
  // ---------------------------------------------------------------------------
  // Brand Emerald & Royal Green Palette
  // ---------------------------------------------------------------------------

  /// Canvas background for Splash, Login, and high-impact hero screens (#05241C).
  static const Color deepEmeraldBase = Color(0xFF05241C);

  /// Luxury dark emerald card and container background (#092B22).
  static const Color emeraldCard = Color(0xFF092B22);

  /// Alternate deep emerald card surface (#0B3026).
  static const Color emeraldCardAlt = Color(0xFF0B3026);

  /// Brand primary dark green used for headers and active filter buttons (#064E3B).
  static const Color emeraldPrimary = Color(0xFF064E3B);

  /// Deep emerald container surface (#0C2B24).
  static const Color emeraldContainer = Color(0xFF0C2B24);

  /// Secondary muted text and labels on dark emerald surfaces (#9FB8AE).
  static const Color emeraldTextSubtle = Color(0xFF9FB8AE);

  /// Muted labels on dark cards (#A3BCB2).
  static const Color emeraldTextMuted = Color(0xFFA3BCB2);

  /// Emerald accent border (#10B981 with 20% opacity).
  static const Color emeraldBorder = Color(0x3310B981);

  // ---------------------------------------------------------------------------
  // Brand Metallic Gold Palette
  // ---------------------------------------------------------------------------

  /// Primary luxury metallic gold for logos, active badges, and key accents (#C59B27).
  static const Color goldPrimary = Color(0xFFC59B27);

  /// Secondary gold accent (#C49746).
  static const Color goldAccent = Color(0xFFC49746);

  /// Gradient start for primary luxury CTAs (#E6C275).
  static const Color goldGradientStart = Color(0xFFE6C275);

  /// Gradient end for primary luxury CTAs (#CCA043).
  static const Color goldGradientEnd = Color(0xFFCCA043);

  /// Light champagne gold for subtle highlights (#DFC178).
  static const Color goldLight = Color(0xFFDFC178);

  /// Frosted champagne gold background for chips and icons (12% opacity).
  static const Color goldSubtle = Color(0x1FC59B27);

  /// Subtle gold border for badges and frames (28% opacity).
  static const Color goldBorder = Color(0x47C59B27);

  // ---------------------------------------------------------------------------
  // Refined Light Surface Palette (Passbook & Settings)
  // ---------------------------------------------------------------------------

  /// Soft modern off-white page background canvas (#F8F9FA).
  static const Color surfacePageBg = Color(0xFFF8F9FA);

  /// Crisp white container card background (#FFFFFF).
  static const Color surfaceCardBg = Color(0xFFFFFFFF);

  /// Subtle modern gray border for cards and inputs (#E5E7EB).
  static const Color surfaceCardBorder = Color(0xFFE5E7EB);

  /// Secondary modern border gray (#EAECEF).
  static const Color surfaceCardBorderAlt = Color(0xFFEAECEF);

  /// Table row separator and section divider (#F1F5F9).
  static const Color surfaceDivider = Color(0xFFF1F5F9);

  // ---------------------------------------------------------------------------
  // Neutral Text Palette
  // ---------------------------------------------------------------------------

  /// Primary high-contrast text on light cards (#0F172A).
  static const Color textPrimaryDark = Color(0xFF0F172A);

  /// Subtitles, helper text, and timestamps on light cards (#64748B).
  static const Color textSecondaryMuted = Color(0xFF64748B);

  /// Tertiary placeholder and disabled text (#94A3B8).
  static const Color textTertiary = Color(0xFF94A3B8);

  /// Crisp white text on dark emerald cards (#FFFFFF).
  static const Color textPrimaryLight = Color(0xFFFFFFFF);

  /// Soft off-white text for luxury dark surfaces (#FAF8F2).
  static const Color textPrimaryLightOff = Color(0xFFFAF8F2);

  /// Secondary perk descriptions and labels on dark cards (#8CA59B).
  static const Color textSecondaryLight = Color(0xFF8CA59B);

  /// Light secondary label on dark cards (#D1DCD6).
  static const Color textSecondaryLightAlt = Color(0xFFD1DCD6);

  // ---------------------------------------------------------------------------
  // Status & Lifecycle Colors
  // ---------------------------------------------------------------------------

  /// Green tint pill background for PAID / Verified (#ECFDF5).
  static const Color statusSuccessBg = Color(0xFFECFDF5);

  /// Green text and icon for success state (#047857).
  static const Color statusSuccessText = Color(0xFF047857);

  /// Green border for verified / paid pills (#A7F3D0).
  static const Color statusSuccessBorder = Color(0xFFA7F3D0);

  /// Amber highlight background for CURRENT due month (#FFFBEB).
  static const Color statusWarningBg = Color(0xFFFFFBEB);

  /// Amber text for current due month and warnings (#D97706).
  static const Color statusWarningText = Color(0xFFD97706);

  /// Dark amber text (#B45309).
  static const Color statusWarningTextAlt = Color(0xFFB45309);

  /// Amber border for warning badges (#FDE68A).
  static const Color statusWarningBorder = Color(0xFFFDE68A);

  /// Yellow highlight background for 12th month 100% Jeweler BONUS deposit (#FEFCE8).
  static const Color statusBonusBg = Color(0xFFFEFCE8);

  /// Bonus text color (#CA8A04).
  static const Color statusBonusText = Color(0xFFCA8A04);

  /// Red background for form errors, failed payments, and destructive actions (#FEF2F2).
  static const Color statusErrorBg = Color(0xFFFEF2F2);

  /// Red text for errors and destructive actions (#DC2626).
  static const Color statusErrorText = Color(0xFFDC2626);

  /// Red border for error banners (#FECACA).
  static const Color statusErrorBorder = Color(0xFFFECACA);

  // ---------------------------------------------------------------------------
  // Gradients
  // ---------------------------------------------------------------------------

  /// Primary metallic gold button and CTA gradient.
  static const LinearGradient goldPrimaryGradient = LinearGradient(
    colors: <Color>[goldGradientStart, goldGradientEnd],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  /// Deep emerald luxury card gradient.
  static const LinearGradient emeraldHeroGradient = LinearGradient(
    colors: <Color>[emeraldCard, deepEmeraldBase],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Light gold accent gradient.
  static const LinearGradient goldCardGradient = LinearGradient(
    colors: <Color>[goldLight, goldPrimary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
