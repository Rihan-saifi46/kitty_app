import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/routing/route_paths.dart';
import '../../../../shared/screens/route_placeholder_screen.dart';

/// Placeholder screen for My Scheme / Dashboard tab (Phase 8).
class DashboardPlaceholderScreen extends StatelessWidget {
  const DashboardPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RoutePlaceholderScreen(
      title: 'My Kitty Scheme',
      phase: 'Phase 8: Dashboard',
      routePath: RoutePaths.dashboard,
      subtitle: 'VIP active scheme pass card, 24K gold weight accumulation, circular progress gauge, 2x2 stats grid, and Pay Next EMI CTA.',
      icon: Icons.savings_outlined,
      actionButton: Wrap(
        spacing: 12,
        runSpacing: 12,
        alignment: WrapAlignment.center,
        children: <Widget>[
          ElevatedButton(
            onPressed: () => context.push(RoutePaths.checkout),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.goldPrimary,
              foregroundColor: AppColors.deepEmeraldBase,
              shape: const RoundedRectangleBorder(borderRadius: AppRadius.border12),
            ),
            child: const Text('Pay Next EMI (₹5,000)'),
          ),
          OutlinedButton(
            onPressed: () => context.go(RoutePaths.passbook),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.goldPrimary,
              side: const BorderSide(color: AppColors.goldPrimary),
              shape: const RoundedRectangleBorder(borderRadius: AppRadius.border12),
            ),
            child: const Text('View 12-Month Passbook'),
          ),
        ],
      ),
    );
  }
}
