import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import '../constants/app_spacing.dart';

/// Centralized application theme configurations for Kitty App.
///
/// Implements dual-surface architecture:
/// 1. [darkTheme] (Surface Dark) for Splash, Login, KYC, Hero Banners, and Modal sheets.
/// 2. [lightTheme] (Surface Light) for Passbook ledger, Settings, and Detail views.
abstract final class AppTheme {
  // ---------------------------------------------------------------------------
  // Dark Theme (Deep Emerald & Metallic Gold Luxury)
  // ---------------------------------------------------------------------------

  /// Luxury dark emerald theme for brand-centric and authentication surfaces.
  static ThemeData get darkTheme => _cachedDarkTheme;

  /// Clean light luxury theme for readability-first operational surfaces.
  static ThemeData get lightTheme => _cachedLightTheme;

  static final ThemeData _cachedDarkTheme = _buildDarkTheme();
  static final ThemeData _cachedLightTheme = _buildLightTheme();

  static ThemeData _buildDarkTheme() {
    const ColorScheme colorScheme = ColorScheme.dark(
      primary: AppColors.goldPrimary,
      onPrimary: AppColors.emeraldCard,
      primaryContainer: AppColors.emeraldPrimary,
      onPrimaryContainer: AppColors.goldLight,
      secondary: AppColors.goldLight,
      onSecondary: AppColors.deepEmeraldBase,
      surface: AppColors.emeraldCard,
      onSurface: AppColors.textPrimaryLight,
      error: AppColors.statusErrorText,
      onError: AppColors.textPrimaryLight,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.homeCanvasBg,
      canvasColor: AppColors.homeCanvasBg,

      // Typography
      textTheme: _buildTextTheme(
        primaryColor: AppColors.textPrimaryLight,
        secondaryColor: AppColors.emeraldTextSubtle,
      ),

      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.deepEmeraldBase,
        foregroundColor: AppColors.textPrimaryLight,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.cinzel(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimaryLight,
          letterSpacing: 0.3,
        ),
      ),

      // Card Theme
      cardTheme: const CardThemeData(
        color: AppColors.emeraldCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.border18,
          side: BorderSide(color: AppColors.emeraldBorder),
        ),
        margin: EdgeInsets.zero,
      ),

      // Elevated Button Theme (Primary Gold CTA)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.goldPrimary,
          foregroundColor: AppColors.emeraldCard,
          elevation: 0,
          minimumSize: const Size.fromHeight(AppDimensions.primaryButtonHeight),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space20, vertical: AppSpacing.space12),
          shape: const RoundedRectangleBorder(
            borderRadius: AppRadius.border14,
          ),
          textStyle: GoogleFonts.montserrat(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
          ),
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.goldLight,
          minimumSize: const Size.fromHeight(AppDimensions.primaryButtonHeight),
          side: const BorderSide(color: AppColors.goldPrimary, width: 1.5),
          shape: const RoundedRectangleBorder(
            borderRadius: AppRadius.border14,
          ),
          textStyle: GoogleFonts.montserrat(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.goldLight,
          textStyle: GoogleFonts.montserrat(
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Input Decoration Theme (Dark Glassmorphic)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withAlpha(20),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.space16,
          vertical: AppSpacing.space16,
        ),
        hintStyle: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          color: AppColors.emeraldTextSubtle,
        ),
        labelStyle: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          color: AppColors.emeraldTextSubtle,
        ),
        border: OutlineInputBorder(
          borderRadius: AppRadius.border12,
          borderSide: BorderSide(color: Colors.white.withAlpha(30)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.border12,
          borderSide: BorderSide(color: Colors.white.withAlpha(30)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: AppRadius.border12,
          borderSide: BorderSide(color: AppColors.goldPrimary, width: 1.5),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: AppRadius.border12,
          borderSide: BorderSide(color: AppColors.statusErrorText),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: AppRadius.border12,
          borderSide: BorderSide(color: AppColors.statusErrorText, width: 1.5),
        ),
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: AppColors.emeraldBorder,
        thickness: 1,
        space: 1,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Light Theme (Clean Financial Passbook & Settings Ledger)
  // ---------------------------------------------------------------------------

  /// Crisp off-white theme for financial ledgers, passbook tables, and settings.
  static ThemeData _buildLightTheme() {
    const ColorScheme colorScheme = ColorScheme.light(
      primary: AppColors.goldPrimary,
      onPrimary: Colors.white,
      primaryContainer: AppColors.goldSubtle,
      onPrimaryContainer: AppColors.goldPrimary,
      secondary: AppColors.emeraldPrimary,
      onSecondary: Colors.white,
      surface: AppColors.surfaceCardBg,
      onSurface: AppColors.textPrimaryDark,
      error: AppColors.statusErrorText,
      onError: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.surfacePageBg,
      canvasColor: AppColors.surfacePageBg,

      // Typography
      textTheme: _buildTextTheme(
        primaryColor: AppColors.textPrimaryDark,
        secondaryColor: AppColors.textSecondaryMuted,
      ),

      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surfaceCardBg,
        foregroundColor: AppColors.textPrimaryDark,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: GoogleFonts.cinzel(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimaryDark,
          letterSpacing: 0.3,
        ),
      ),

      // Card Theme
      cardTheme: const CardThemeData(
        color: AppColors.surfaceCardBg,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.border18,
          side: BorderSide(color: AppColors.surfaceCardBorder),
        ),
        margin: EdgeInsets.zero,
      ),

      // Elevated Button Theme (Primary Gold Action)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.goldPrimary,
          foregroundColor: AppColors.emeraldCard,
          elevation: 0,
          minimumSize: const Size.fromHeight(AppDimensions.primaryButtonHeight),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space20, vertical: AppSpacing.space12),
          shape: const RoundedRectangleBorder(
            borderRadius: AppRadius.border14,
          ),
          textStyle: GoogleFonts.montserrat(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
          ),
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimaryDark,
          minimumSize: const Size.fromHeight(AppDimensions.primaryButtonHeight),
          side: const BorderSide(color: AppColors.surfaceCardBorder, width: 1.2),
          shape: const RoundedRectangleBorder(
            borderRadius: AppRadius.border10,
          ),
          textStyle: GoogleFonts.montserrat(
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.emeraldPrimary,
          textStyle: GoogleFonts.montserrat(
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Input Decoration Theme (Clean White Input)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceCardBg,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.space16,
          vertical: AppSpacing.space16,
        ),
        hintStyle: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          color: AppColors.textTertiary,
        ),
        labelStyle: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          color: AppColors.textSecondaryMuted,
        ),
        border: const OutlineInputBorder(
          borderRadius: AppRadius.border12,
          borderSide: BorderSide(color: AppColors.surfaceCardBorder),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: AppRadius.border12,
          borderSide: BorderSide(color: AppColors.surfaceCardBorder),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: AppRadius.border12,
          borderSide: BorderSide(color: AppColors.goldPrimary, width: 1.5),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: AppRadius.border12,
          borderSide: BorderSide(color: AppColors.statusErrorText),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: AppRadius.border12,
          borderSide: BorderSide(color: AppColors.statusErrorText, width: 1.5),
        ),
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: AppColors.surfaceDivider,
        thickness: 1,
        space: 1,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Helper: Build TextTheme with Google Fonts
  // ---------------------------------------------------------------------------

  static TextTheme _buildTextTheme({
    required Color primaryColor,
    required Color secondaryColor,
  }) {
    return TextTheme(
      displayLarge: GoogleFonts.cinzel(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: primaryColor,
      ),
      displayMedium: GoogleFonts.cinzel(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        color: primaryColor,
        letterSpacing: -0.2,
      ),
      displaySmall: GoogleFonts.cinzel(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: primaryColor,
        letterSpacing: 0.4,
      ),
      headlineMedium: GoogleFonts.montserrat(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: primaryColor,
      ),
      headlineSmall: GoogleFonts.montserrat(
        fontSize: 17,
        fontWeight: FontWeight.w700,
        color: primaryColor,
      ),
      titleLarge: GoogleFonts.montserrat(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: primaryColor,
      ),
      titleMedium: GoogleFonts.montserrat(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: primaryColor,
      ),
      titleSmall: GoogleFonts.montserrat(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: secondaryColor,
      ),
      bodyLarge: GoogleFonts.montserrat(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: primaryColor,
      ),
      bodyMedium: GoogleFonts.montserrat(
        fontSize: 13.5,
        fontWeight: FontWeight.w500,
        color: secondaryColor,
      ),
      bodySmall: GoogleFonts.montserrat(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: secondaryColor,
      ),
      labelLarge: GoogleFonts.montserrat(
        fontSize: 14,
        fontWeight: FontWeight.w800,
        color: primaryColor,
        letterSpacing: 1.0,
      ),
      labelMedium: GoogleFonts.montserrat(
        fontSize: 11.5,
        fontWeight: FontWeight.w600,
        color: secondaryColor,
        letterSpacing: 0.6,
      ),
      labelSmall: GoogleFonts.montserrat(
        fontSize: 10,
        fontWeight: FontWeight.w800,
        color: AppColors.goldPrimary,
        letterSpacing: 1.8,
      ),
    );
  }
}
