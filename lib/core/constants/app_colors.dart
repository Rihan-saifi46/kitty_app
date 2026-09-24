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
  // Official Warm Luxury Palette (Warm Alabaster Silk & Polished Cream Ivory)
  // ---------------------------------------------------------------------------

  /// Warm Alabaster Silk (#FAF7F2): Full-screen base / canvas behind cards.
  static const Color alabasterSilk = Color(0xFFFAF7F2);

  /// Polished Cream Ivory (#F4F0EA): Active Jewel Plan card & Bottom Offers card background.
  static const Color creamIvoryCard = Color(0xFFF4F0EA);

  /// Soft Warm Linen (#EDE8DF): The subtle inner box around "Total Deposited" & "Monthly EMI".
  static const Color warmLinenInset = Color(0xFFEDE8DF);

  /// Rich Warm Ochre / Honey Gold (#DCA237): "PAY INSTALLMENT" button, progress ring, active plan title, icon badge.
  static const Color honeyGoldAccent = Color(0xFFDCA237);

  /// Champagne Gold Foil (#F3E0B5): #SW-042 chip pill, 24K price banner pill, "Royal Club" badge.
  static const Color champagneFoil = Color(0xFFF3E0B5);

  /// Espresso Charcoal (#2B2521): High-contrast numbers (₹40,000), "Namaste, Rihan Saifi", main headings.
  static const Color espressoCharcoal = Color(0xFF2B2521);

  /// Warm Taupe Brown (#6E6259): Labels ("TOTAL DEPOSITED", "MONTHLY EMI", "8 of 12 installments").
  static const Color warmTaupeBrown = Color(0xFF6E6259);

  /// Dark Contrast CTA: Deep Umber Bronze (#26211E): "Explore Plan" button at the bottom.
  static const Color deepUmberBronze = Color(0xFF26211E);

  // ---------------------------------------------------------------------------
  // Settings & Warm Luxury Palette (Exact User-Specified Hex Codes)
  // ---------------------------------------------------------------------------

  /// Warm Alabaster Silk (#FAF7F2): Screen base background.
  static const Color settingsBg = Color(0xFFFAF7F2);

  /// Polished Cream Ivory (#F5F1EB): Profile card, settings group cards background.
  static const Color settingsCardBg = Color(0xFFF5F1EB);

  /// Soft Warm Linen (#EAE4D9): Rounded icon boxes (UPI, Nominee, MPIN icons).
  static const Color settingsIconBg = Color(0xFFEAE4D9);

  /// Espresso Charcoal (#241E1A): Primary text & headings.
  static const Color settingsTextPrimary = Color(0xFF241E1A);

  /// Warm Taupe Brown (#6E6259): Secondary & subtitle captions.
  static const Color settingsTextSecondary = Color(0xFF6E6259);

  /// Warm Antique Gold (#B88B4A): Section titles & accents.
  static const Color settingsAccentGold = Color(0xFFB88B4A);

  /// Sage Mint Tint (#E1F2E9): Status pill background (Registered, Verified).
  static const Color settingsBadgeBg = Color(0xFFE1F2E9);

  /// Forest Jade Green (#1E7A4D): Status pill text and checkmark.
  static const Color settingsBadgeText = Color(0xFF1E7A4D);

  /// Light Sand Beige (#E6DFD5): Divider lines and 1px subtle borders.
  static const Color settingsBorder = Color(0xFFE6DFD5);

  // ---------------------------------------------------------------------------
  // Luxury Design Tokens mapped to Warm Luxury Palette
  // ---------------------------------------------------------------------------

  /// Canvas background canvas matching Warm Alabaster Silk (#FAF7F2).
  static const Color homeCanvasBg = alabasterSilk;

  /// Top luxury navbar & product card background matching Polished Cream Ivory (#F4F0EA).
  static const Color homeNavbarBg = creamIvoryCard;

  /// Header & footer border matching Soft Warm Linen (#EDE8DF).
  static const Color homeNavbarBorder = warmLinenInset;

  /// Primary heading font color matching Espresso Charcoal (#2B2521).
  static const Color homePrimaryHeading = espressoCharcoal;

  /// Body & subtitle font color matching Warm Taupe Brown (#6E6259).
  static const Color homeBodySubtitle = warmTaupeBrown;

  /// Brand gold accent matching Rich Warm Ochre / Honey Gold (#DCA237).
  static const Color homeBrandGold = honeyGoldAccent;

  /// Brand gold hover matching Rich Warm Ochre / Honey Gold (#C8902A).
  static const Color homeBrandGoldHover = Color(0xFFC8902A);

  /// Category ring background matching Polished Cream Ivory (#F4F0EA).
  static const Color homeCategoryRingBg = creamIvoryCard;

  /// Category ring border matching Soft Warm Linen (#EDE8DF).
  static const Color homeCategoryRingBorder = warmLinenInset;

  /// Product card background matching Polished Cream Ivory (#F4F0EA).
  static const Color homeProductCardBg = creamIvoryCard;

  /// Product card border matching Soft Warm Linen (#EDE8DF).
  static const Color homeProductCardBorder = warmLinenInset;

  /// Promo banner emerald card.
  static const Color homePromoBannerEmerald = creamIvoryCard;

  /// Promo golden button matching Honey Gold (#DCA237).
  static const Color homePromoGoldenBtn = honeyGoldAccent;

  // ---------------------------------------------------------------------------
  // Refined Light Surface Palette (Passbook & Settings)
  // ---------------------------------------------------------------------------

  /// Soft modern off-white page background canvas (#FAF7F2).
  static const Color surfacePageBg = alabasterSilk;

  /// Crisp cream container card background (#F4F0EA).
  static const Color surfaceCardBg = creamIvoryCard;

  /// Subtle modern warm border for cards and inputs (#EDE8DF).
  static const Color surfaceCardBorder = warmLinenInset;

  /// Secondary modern border (#EDE8DF).
  static const Color surfaceCardBorderAlt = warmLinenInset;

  /// Table row separator and section divider (#EDE8DF).
  static const Color surfaceDivider = warmLinenInset;

  // ---------------------------------------------------------------------------
  // Neutral Text Palette
  // ---------------------------------------------------------------------------

  /// Primary high-contrast text on light cards (#2B2521 Espresso Charcoal).
  static const Color textPrimaryDark = espressoCharcoal;

  /// Subtitles, helper text, and timestamps on light cards (#6E6259 Warm Taupe Brown).
  static const Color textSecondaryMuted = warmTaupeBrown;

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
