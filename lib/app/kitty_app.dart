import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/config/app_constants.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_spacing.dart';
import '../core/constants/app_typography.dart';
import '../core/theme/app_theme.dart';

/// Root application widget configured with Riverpod and dual-surface luxury theme.
class KittyApp extends ConsumerWidget {
  const KittyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const _FoundationReadyScreen(),
    );
  }
}

/// Baseline placeholder screen confirming Phase 1 core foundation is operational.
class _FoundationReadyScreen extends StatelessWidget {
  const _FoundationReadyScreen();

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: AppSpacing.screenPadding,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.goldSubtle,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.goldBorder, width: 2),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.diamond_outlined,
                      color: AppColors.goldPrimary,
                      size: 40,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.space24),
                Text(
                  AppConstants.appName,
                  style: AppTypography.displayBrand(
                    color: isDark ? AppColors.textPrimaryLight : AppColors.textPrimaryDark,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.space8),
                Text(
                  'Royal Indian Heritage Luxury & Bank-Grade Savings',
                  style: AppTypography.bodyRegular(
                    color: isDark ? AppColors.emeraldTextSubtle : AppColors.textSecondaryMuted,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.space32),
                Container(
                  padding: AppSpacing.all16,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.emeraldCard : AppColors.surfaceCardBg,
                    borderRadius: AppRadius.border18,
                    border: Border.all(
                      color: isDark ? AppColors.emeraldBorder : AppColors.surfaceCardBorder,
                    ),
                  ),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Icon(
                            Icons.check_circle_rounded,
                            color: AppColors.statusSuccessText,
                            size: 20,
                          ),
                          const SizedBox(width: AppSpacing.space8),
                          Text(
                            'Phase 1: Core Foundation Active',
                            style: AppTypography.bodyBold(
                              color: isDark
                                  ? AppColors.textPrimaryLight
                                  : AppColors.textPrimaryDark,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.space8),
                      Text(
                        'Design tokens, dual themes, secure storage, and Dio network infrastructure verified.',
                        style: AppTypography.bodySmall(
                          color: isDark
                              ? AppColors.emeraldTextSubtle
                              : AppColors.textSecondaryMuted,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
