import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/routing/route_paths.dart';
import '../../../../shared/screens/route_placeholder_screen.dart';

/// Placeholder screen for Digital Tax Receipt view (Phase 13).
class ReceiptPlaceholderScreen extends StatelessWidget {
  const ReceiptPlaceholderScreen({
    required this.receiptId,
    super.key,
  });

  final String receiptId;

  @override
  Widget build(BuildContext context) {
    return RoutePlaceholderScreen(
      title: 'Digital Tax Receipt',
      phase: 'Phase 13: Receipts',
      routePath: '/receipt/$receiptId',
      subtitle: 'Paper invoice printable layout with patron details, chit token, fine gold credited, and Cloudinary PDF download.',
      icon: Icons.receipt_long_rounded,
      actionButton: ElevatedButton.icon(
        onPressed: () {
          if (context.canPop()) {
            context.pop();
          } else {
            context.go(RoutePaths.passbook);
          }
        },
        icon: const Icon(Icons.check_rounded, size: 18),
        label: const Text('Done / Close Receipt'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.goldPrimary,
          foregroundColor: AppColors.deepEmeraldBase,
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.border12),
        ),
      ),
    );
  }
}
