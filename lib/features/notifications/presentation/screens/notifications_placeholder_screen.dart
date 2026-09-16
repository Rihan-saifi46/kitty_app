import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/routing/route_paths.dart';
import '../../../../shared/screens/route_placeholder_screen.dart';

/// Placeholder screen for In-App Notifications Center (Phase 14).
class NotificationsPlaceholderScreen extends StatelessWidget {
  const NotificationsPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RoutePlaceholderScreen(
      title: 'Notifications Center',
      phase: 'Phase 14: Notifications',
      routePath: RoutePaths.notifications,
      subtitle: 'Transactional alerts (Payment Received, Lucky Draw Winner, EMI Due, Gold Rate Benchmarks) with read states and deep links.',
      icon: Icons.notifications_active_outlined,
      actionButton: ElevatedButton.icon(
        onPressed: () {
          if (context.canPop()) {
            context.pop();
          } else {
            context.go(RoutePaths.home);
          }
        },
        icon: const Icon(Icons.arrow_back_rounded, size: 18),
        label: const Text('Back to App'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.goldPrimary,
          foregroundColor: AppColors.deepEmeraldBase,
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.border12),
        ),
      ),
    );
  }
}
