import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/providers/auth_state_provider.dart';
import '../../../../core/routing/route_paths.dart';
import '../../../../shared/screens/route_placeholder_screen.dart';

/// Placeholder screen for Settings tab (Phase 12).
class SettingsPlaceholderScreen extends ConsumerWidget {
  const SettingsPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RoutePlaceholderScreen(
      title: 'Patron Settings',
      phase: 'Phase 12: Settings',
      routePath: RoutePaths.settings,
      subtitle: 'AutoPay toggle, Nominee registration, Biometric app lock, 4-digit transaction MPIN, and secure logout.',
      icon: Icons.settings_outlined,
      actionButton: ElevatedButton.icon(
        onPressed: () async {
          final bool? confirm = await showDialog<bool>(
            context: context,
            builder: (BuildContext ctx) => AlertDialog(
              backgroundColor: AppColors.emeraldCard,
              title: const Text('Log Out of Account?', style: TextStyle(color: Colors.white)),
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
                  ),
                  child: const Text('Log Out'),
                ),
              ],
            ),
          );

          if (confirm == true) {
            await ref.read(appAuthStateProvider.notifier).logout();
            if (context.mounted) {
              context.go(RoutePaths.login);
            }
          }
        },
        icon: const Icon(Icons.logout_rounded, size: 18),
        label: const Text('Log Out of Account'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.statusErrorBg,
          foregroundColor: AppColors.statusErrorText,
          side: const BorderSide(color: AppColors.statusErrorText),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.border12),
        ),
      ),
    );
  }
}
