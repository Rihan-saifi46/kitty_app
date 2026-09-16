import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/routing/route_paths.dart';
import '../../../../shared/screens/route_placeholder_screen.dart';

/// Placeholder screen for Payment Checkout Modal (Phase 11).
class CheckoutPlaceholderScreen extends StatelessWidget {
  const CheckoutPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RoutePlaceholderScreen(
      title: 'Payment Checkout',
      phase: 'Phase 11: Payments',
      routePath: RoutePaths.checkout,
      subtitle: 'Slide-up modal with payment methods (UPI, NetBanking, Cards) and GoKwik payment order initiation.',
      icon: Icons.payment_rounded,
      actionButton: Wrap(
        spacing: 12,
        children: <Widget>[
          ElevatedButton(
            onPressed: () => context.push(RoutePaths.gokwikGateway),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.goldPrimary,
              foregroundColor: AppColors.deepEmeraldBase,
              shape: const RoundedRectangleBorder(borderRadius: AppRadius.border12),
            ),
            child: const Text('Open GoKwik Gateway Host'),
          ),
          OutlinedButton(
            onPressed: () => context.pop(),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.goldPrimary,
              side: const BorderSide(color: AppColors.goldPrimary),
              shape: const RoundedRectangleBorder(borderRadius: AppRadius.border12),
            ),
            child: const Text('Dismiss Checkout'),
          ),
        ],
      ),
    );
  }
}
