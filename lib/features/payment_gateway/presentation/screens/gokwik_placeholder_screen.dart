import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/routing/route_paths.dart';
import '../../../../shared/screens/route_placeholder_screen.dart';

/// Placeholder screen for GoKwik Payment Gateway WebView host (Phase 11).
class GokwikPlaceholderScreen extends StatelessWidget {
  const GokwikPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RoutePlaceholderScreen(
      title: 'GoKwik Gateway Host',
      phase: 'Phase 11: Payments',
      routePath: RoutePaths.gokwikGateway,
      subtitle: 'Isolated webview host presenting GoKwik checkout with payment reconciliation return callbacks.',
      icon: Icons.security_rounded,
      actionButton: ElevatedButton(
        onPressed: () {
          // Return to dashboard upon simulated payment completion
          context.go(RoutePaths.dashboard);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.goldPrimary,
          foregroundColor: AppColors.deepEmeraldBase,
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.border12),
        ),
        child: const Text('Simulate Successful Return -> /dashboard'),
      ),
    );
  }
}
