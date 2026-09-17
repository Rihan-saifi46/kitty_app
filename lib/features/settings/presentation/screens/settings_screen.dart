import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/routing/route_paths.dart';
import '../providers/settings_controller.dart';
import '../providers/settings_state.dart';
import '../widgets/mpin_dialog.dart';
import '../widgets/nominee_details_modal.dart';
import '../widgets/patron_profile_card.dart';
import '../widgets/settings_group_card.dart';
import '../widgets/terms_and_compliance_modal.dart';

/// Luxury Patron Settings, Security & Profile screen strictly matching `settings.html`.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SettingsState state = ref.watch(settingsControllerProvider);
    final SettingsController controller = ref.read(settingsControllerProvider.notifier);
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final Color pageBg = isDark ? AppColors.deepEmeraldBase : const Color(0xFFF8F9FA);
    final Color headerBg = isDark ? AppColors.deepEmeraldBase : Colors.white;
    final Color headerBorder = isDark ? AppColors.emeraldBorder : const Color(0xFFF1F3F5);
    final Color titleColor = isDark ? AppColors.textPrimaryLight : const Color(0xFF0F172A);

    return Scaffold(
      backgroundColor: pageBg,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            // 1. Top Navigation Bar (Sticky Header)
            _buildTopNavBar(
              context: context,
              headerBg: headerBg,
              headerBorder: headerBorder,
              titleColor: titleColor,
              isDark: isDark,
            ),

            // 2. Scrollable Settings Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    // Patron Profile Quick Card
                    PatronProfileCard(user: state.user),
                    const SizedBox(height: AppSpacing.space20),

                    // Section 1: Gold Kitty & Scheme Automation
                    SettingsGroupCard(
                      title: 'Gold Kitty & Scheme Settings',
                      items: <SettingsItemModel>[
                        SettingsItemModel(
                          icon: Icons.autorenew_rounded,
                          title: 'UPI AutoPay / e-Mandate',
                          subtitle: 'Auto-deduct ₹5,000 on 15th every month',
                          trailing: Switch(
                            value: state.preferences.autoPayEnabled,
                            activeThumbColor: isDark ? AppColors.goldPrimary : const Color(0xFF0C2B24),
                            activeTrackColor: isDark
                                ? AppColors.emeraldPrimary
                                : const Color(0xFF0C2B24).withValues(alpha: 0.3),
                            onChanged: (bool value) => controller.toggleAutoPay(value),
                          ),
                        ),
                        SettingsItemModel(
                          icon: Icons.people_outline_rounded,
                          title: 'Nominee Registration',
                          subtitle: state.user?.nomineeName?.isNotEmpty == true
                              ? '${state.user!.nomineeName} (${state.user?.nomineeRelationship ?? 'Beneficiary'}) • 100% Share'
                              : 'Amina Saifi (Spouse) • 100% Share',
                          badgeText: 'Registered',
                          onTap: () => NomineeDetailsModal.show(
                            context,
                            nomineeName: state.user?.nomineeName,
                            relationship: state.user?.nomineeRelationship,
                          ),
                        ),
                        SettingsItemModel(
                          icon: Icons.star_border_rounded,
                          title: 'Maturity Gold Redemption',
                          subtitle: 'Physical 24K Gold or Showroom Jewellery',
                          onTap: () => TermsAndComplianceModal.show(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.space20),

                    // Section 2: Security & App Privacy
                    SettingsGroupCard(
                      title: 'Security & PIN',
                      items: <SettingsItemModel>[
                        SettingsItemModel(
                          icon: Icons.fingerprint_rounded,
                          title: 'Biometric App Lock',
                          subtitle: 'Fingerprint / Face ID for Passbook',
                          trailing: Switch(
                            value: state.preferences.biometricEnabled,
                            activeThumbColor: isDark ? AppColors.goldPrimary : const Color(0xFF0C2B24),
                            activeTrackColor: isDark
                                ? AppColors.emeraldPrimary
                                : const Color(0xFF0C2B24).withValues(alpha: 0.3),
                            onChanged: (bool value) => controller.toggleBiometric(value),
                          ),
                        ),
                        SettingsItemModel(
                          icon: Icons.lock_outline_rounded,
                          title: 'Change 4-Digit MPIN',
                          subtitle: state.hasMpin
                              ? 'MPIN configured • Tap to update'
                              : 'Required for payment authorization',
                          onTap: () => MpinDialog.show(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.space20),

                    // Section 3: KYC Verification
                    SettingsGroupCard(
                      title: 'KYC Verification',
                      items: <SettingsItemModel>[
                        SettingsItemModel(
                          icon: Icons.badge_outlined,
                          title: '${state.user?.kyc.documentType?.toJson() ?? 'PAN'} Verification (Government ID)',
                          subtitle: state.user?.kyc.documentNumberMasked?.isNotEmpty == true
                              ? '${state.user!.kyc.documentNumberMasked} (${state.user?.name ?? 'Rajesh Sharma'})'
                              : 'XXXX XXXX 9012 (${state.user?.name ?? 'Patron'})',
                          badgeText: state.user?.kyc.isVerified == true ? 'Verified' : 'Pending',
                          onTap: () => context.push(RoutePaths.kyc),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.space20),

                    // Section 4: App Preferences & Legal
                    SettingsGroupCard(
                      title: 'App & Legal',
                      items: <SettingsItemModel>[
                        SettingsItemModel(
                          icon: Icons.palette_outlined,
                          title: 'Theme Appearance',
                          subtitle: _getThemeLabel(state.preferences.themeMode),
                          onTap: () => _showThemeSelectionModal(context, controller, state.preferences.themeMode),
                        ),
                        SettingsItemModel(
                          icon: Icons.language_rounded,
                          title: 'Language',
                          subtitle: state.preferences.language == 'hi' ? 'Hindi (हिन्दी)' : 'English (UK)',
                          onTap: () => _showLanguageSelectionModal(context, controller, state.preferences.language),
                        ),
                        SettingsItemModel(
                          icon: Icons.verified_outlined,
                          title: 'Kitty Scheme Terms & BIS 24K Hallmarking',
                          subtitle: '100% Guaranteed 999 purity compliance',
                          onTap: () => TermsAndComplianceModal.show(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.space24),

                    // Destructive Sign Out Button
                    _buildLogoutButton(context, ref),
                    const SizedBox(height: AppSpacing.space20),

                    // Footer Legal Text
                    _buildFooterLegal(),
                    const SizedBox(height: AppSpacing.space24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopNavBar({
    required BuildContext context,
    required Color headerBg,
    required Color headerBorder,
    required Color titleColor,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: headerBg,
        border: Border(bottom: BorderSide(color: headerBorder)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          // Back Button Circle: #0C2B24 with #FFFFFF arrow
          GestureDetector(
            onTap: () {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              } else {
                context.go(RoutePaths.home);
              }
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isDark ? AppColors.goldSubtle : const Color(0xFF0C2B24),
                shape: BoxShape.circle,
                boxShadow: const <BoxShadow>[
                  BoxShadow(
                    color: Color(0x1F0C2B24),
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 16,
                  color: isDark ? AppColors.goldPrimary : Colors.white,
                ),
              ),
            ),
          ),

          // Header Title
          Text(
            'Patron Settings',
            style: TextStyle(
              fontFamily: 'Cinzel',
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: titleColor,
              letterSpacing: 0.5,
            ),
          ),

          // 3-Lines Navigation Icon (Hamburger)
          GestureDetector(
            onTap: () {
              Scaffold.maybeOf(context)?.openDrawer();
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isDark ? AppColors.emeraldCard : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? AppColors.emeraldBorder : const Color(0xFFE2E8F0),
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.menu_rounded,
                  size: 20,
                  color: isDark ? AppColors.goldPrimary : const Color(0xFF0C2B24),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () async {
        final bool? confirm = await showDialog<bool>(
          context: context,
          builder: (BuildContext ctx) => AlertDialog(
            backgroundColor: AppColors.emeraldCard,
            shape: const RoundedRectangleBorder(borderRadius: AppRadius.border20),
            title: const Text(
              'Log Out of Account?',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
            ),
            content: const Text(
              'Are you sure you want to end your current session?',
              style: TextStyle(color: AppColors.emeraldTextSubtle),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text('Cancel', style: TextStyle(color: AppColors.emeraldTextSubtle)),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.statusErrorText,
                  foregroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(borderRadius: AppRadius.border12),
                ),
                child: const Text('Log Out'),
              ),
            ],
          ),
        );

        if (confirm == true && context.mounted) {
          await ref.read(settingsControllerProvider.notifier).logout();
          if (context.mounted) {
            context.go(RoutePaths.login);
          }
        }
      },
      borderRadius: AppRadius.border16,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFFEF2F2),
          borderRadius: AppRadius.border16,
          border: Border.all(color: const Color(0xFFFEE2E2)),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.logout_rounded, size: 18, color: Color(0xFFDC2626)),
            SizedBox(width: 8),
            Text(
              'Log Out of Account',
              style: TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w700,
                color: Color(0xFFDC2626),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooterLegal() {
    return const Column(
      children: <Widget>[
        Text(
          'Swastik Jewellers Active Gold Vault • v2.4.0',
          style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
        ),
        SizedBox(height: 3),
        Text(
          '256-bit Bank Grade Encryption • ISO 9001 Certified',
          style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
        ),
      ],
    );
  }

  String _getThemeLabel(String mode) {
    switch (mode) {
      case 'dark':
        return 'Dark Emerald Luxury';
      case 'light':
        return 'Light Bank-Grade';
      case 'system':
      default:
        return 'System Default';
    }
  }

  void _showThemeSelectionModal(BuildContext context, SettingsController controller, String currentMode) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext ctx) {
        final bool isDark = Theme.of(ctx).brightness == Brightness.dark;
        return Material(
          color: isDark ? AppColors.emeraldCard : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Choose Theme',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 12),
                _buildThemeOption(ctx, controller, 'System Default', 'system', currentMode == 'system'),
                _buildThemeOption(ctx, controller, 'Dark Emerald Luxury', 'dark', currentMode == 'dark'),
                _buildThemeOption(ctx, controller, 'Light Bank-Grade', 'light', currentMode == 'light'),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildThemeOption(
    BuildContext ctx,
    SettingsController controller,
    String label,
    String mode,
    bool isSelected,
  ) {
    return ListTile(
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      trailing: isSelected ? const Icon(Icons.check_rounded, color: AppColors.goldPrimary) : null,
      onTap: () {
        controller.setThemeMode(mode);
        Navigator.of(ctx).pop();
      },
    );
  }

  void _showLanguageSelectionModal(BuildContext context, SettingsController controller, String currentLang) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext ctx) {
        final bool isDark = Theme.of(ctx).brightness == Brightness.dark;
        return Material(
          color: isDark ? AppColors.emeraldCard : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Select App Language',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 12),
                ListTile(
                  title: const Text('English (UK)', style: TextStyle(fontWeight: FontWeight.w600)),
                  trailing: currentLang == 'en' ? const Icon(Icons.check_rounded, color: AppColors.goldPrimary) : null,
                  onTap: () {
                    controller.setLanguage('en');
                    Navigator.of(ctx).pop();
                  },
                ),
                ListTile(
                  title: const Text('Hindi (हिन्दी)', style: TextStyle(fontWeight: FontWeight.w600)),
                  trailing: currentLang == 'hi' ? const Icon(Icons.check_rounded, color: AppColors.goldPrimary) : null,
                  onTap: () {
                    controller.setLanguage('hi');
                    Navigator.of(ctx).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
