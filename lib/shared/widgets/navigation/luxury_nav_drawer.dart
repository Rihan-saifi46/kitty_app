import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/providers/auth_state_provider.dart';
import '../../../../core/routing/route_paths.dart';
import '../../../features/notifications/presentation/providers/notifications_controller.dart';
import 'menu_items_config.dart';

/// Luxury slide-out navigation drawer strictly matching the approved prototype.
///
/// Features 4 categorized sections:
/// 1. KITTY & SAVINGS: My Kitty, Kitty Plans, Savings Passbook
/// 2. BULLION: Gold Coins, Silver Coins
/// 3. ACCOUNT & COMPLIANCE: Profile, KYC Compliance, Orders & Bookings, Settings & Security, Notifications
/// 4. CONCIERGE: Concierge & Support
class LuxuryNavDrawer extends ConsumerWidget {
  const LuxuryNavDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppAuthState authState = ref.watch(appAuthStateProvider);
    final String currentPath = GoRouterState.of(context).uri.path;
    final int unreadNotificationsCount = ref.watch(unreadNotificationsCountProvider);

    return Drawer(
      backgroundColor: AppColors.homeCanvasBg,
      child: SafeArea(
        child: Column(
          children: <Widget>[
            // 1. Drawer Header: Brand Crest & Close Button
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 12, 16),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: SvgPicture.asset(
                        'assets/icons/swastiklogo.svg',
                        key: const Key('drawer_swastik_logo'),
                        height: 28,
                        fit: BoxFit.contain,
                        semanticsLabel: 'Swastik Jewellers',
                      ),
                    ),
                  ),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.close_rounded,
                      color: AppColors.primaryEmerald,
                      size: 22,
                    ),
                    tooltip: 'Close Drawer',
                  ),
                ],
              ),
            ),

            // 2. Patron Profile Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: AppSpacing.all16,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: AppRadius.border16,
                  border: Border.all(color: AppColors.surfaceCardBorder),
                  boxShadow: const <BoxShadow>[
                    BoxShadow(
                      color: Color(0x0A063D2E),
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: const Color(0x18063D2E),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primaryEmerald.withValues(alpha: 0.3),
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          authState.userName.isNotEmpty
                              ? authState.userName[0].toUpperCase()
                              : 'P',
                          style: AppTypography.displaySubtitle(
                            color: AppColors.primaryEmerald,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.space12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            authState.userName,
                            style: AppTypography.bodyBold(
                              color: AppColors.primaryEmerald,
                            ).copyWith(fontWeight: FontWeight.w700),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            authState.userPhone,
                            style: AppTypography.labelMeta(
                              color: AppColors.mutedSlateGray,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.space12),

            // 3. Categorized Navigation Links List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: <Widget>[
                  ...AppNavMenuConfig.getCategories(
                    unreadNotificationsCount: unreadNotificationsCount,
                  ).map((AppNavCategory category) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(14, 12, 14, 4),
                          child: Text(
                            category.categoryName,
                            style: AppTypography.kickerCaps(
                              color: AppColors.mutedSlateGray,
                            ).copyWith(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                        ...category.items.map((AppNavMenuItem item) {
                          return _DrawerNavItem(
                            title: item.title,
                            icon: item.icon,
                            routePath: item.routePath,
                            isActive: currentPath == item.routePath,
                            badgeText: item.badgeText,
                            badgeColor: item.badgeColor ?? AppColors.primaryEmerald,
                            isDestructive: item.isDestructive,
                            onTap: () {
                              if (item.id == 'concierge') {
                                _showConciergeModal(context);
                              } else {
                                _navigateTo(context, item.routePath, extra: item.extra);
                              }
                            },
                          );
                        }),
                      ],
                    );
                  }),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    child: Divider(color: AppColors.surfaceCardBorder, height: 1),
                  ),

                  // 4. Logout Action
                  _DrawerNavItem(
                    title: 'Log Out of Account',
                    icon: Icons.logout_rounded,
                    routePath: RoutePaths.login,
                    isActive: false,
                    isDestructive: true,
                    onTap: () => _handleLogout(context, ref),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateTo(BuildContext context, String path, {Object? extra}) {
    Navigator.of(context).pop(); // Close drawer first
    context.go(path, extra: extra);
  }

  void _showConciergeModal(BuildContext context) {
    Navigator.of(context).pop(); // Close drawer first
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Swastik Concierge',
                    style: AppTypography.cardTitle(color: AppColors.primaryEmerald),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: AppColors.primaryEmerald),
                    onPressed: () => Navigator.of(ctx).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'Personalized jewellery advisory, bespoke orders, and scheme concierge assistance.',
                style: AppTypography.bodyRegular(color: AppColors.mutedSlateGray),
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Color(0x18063D2E),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.phone_in_talk_rounded, color: AppColors.primaryEmerald, size: 20),
                ),
                title: const Text('Toll-Free Helpline', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                subtitle: const Text('1800-SWASTIK (1800-792-7845)', style: TextStyle(fontSize: 12)),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Color(0x18063D2E),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.chat_bubble_outline_rounded, color: AppColors.primaryEmerald, size: 20),
                ),
                title: const Text('Concierge WhatsApp', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                subtitle: const Text('+91 98765 43210 • 10:30 AM - 8:30 PM', style: TextStyle(fontSize: 12)),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Color(0x18063D2E),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.email_outlined, color: AppColors.primaryEmerald, size: 20),
                ),
                title: const Text('Priority Support Email', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                subtitle: const Text('support@swastikjewel.in', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogout(BuildContext context, WidgetRef ref) async {
    final AppAuthNotifier authNotifier = ref.read(appAuthStateProvider.notifier);

    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.border16),
        title: Text(
          'Log Out of Account?',
          style: AppTypography.cardTitle(color: AppColors.primaryEmerald),
        ),
        content: Text(
          'Are you sure you want to end your current session? You will need to re-verify via OTP.',
          style: AppTypography.bodyRegular(color: AppColors.espressoCharcoal),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              'Cancel',
              style: AppTypography.bodyRegular(color: AppColors.mutedSlateGray),
            ),
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

    if (confirmed == true) {
      await authNotifier.logout();
      if (context.mounted) {
        context.go(RoutePaths.login);
      }
    }
  }
}

class _DrawerNavItem extends StatelessWidget {
  const _DrawerNavItem({
    required this.title,
    required this.icon,
    required this.routePath,
    required this.isActive,
    required this.onTap,
    this.badgeText,
    this.badgeColor,
    this.isDestructive = false,
  });

  final String title;
  final IconData icon;
  final String routePath;
  final bool isActive;
  final VoidCallback onTap;
  final String? badgeText;
  final Color? badgeColor;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final Color itemColor = isDestructive
        ? AppColors.statusErrorText
        : AppColors.primaryEmerald;

    return Semantics(
      button: true,
      label: title,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Material(
          color: isActive ? const Color(0x18063D2E) : Colors.transparent,
          borderRadius: AppRadius.border12,
          child: InkWell(
            onTap: onTap,
            borderRadius: AppRadius.border12,
            splashColor: const Color(0x1A063D2E),
            highlightColor: const Color(0x0F063D2E),
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 48),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Row(
                  children: <Widget>[
                    Icon(icon, color: itemColor, size: 20),
                    const SizedBox(width: AppSpacing.space12),
                    Expanded(
                      child: Text(
                        title,
                        style: AppTypography.bodyBold(
                          color: itemColor,
                        ).copyWith(
                          fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
                        ),
                      ),
                    ),
                    if (badgeText != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0x14063D2E),
                          borderRadius: AppRadius.border12,
                          border: Border.all(
                            color: badgeColor ?? AppColors.primaryEmerald.withValues(alpha: 0.3),
                            width: 0.8,
                          ),
                        ),
                        child: Text(
                          badgeText!,
                          style: AppTypography.kickerCaps(
                            color: badgeColor ?? AppColors.primaryEmerald,
                          ).copyWith(fontSize: 9, fontWeight: FontWeight.w700),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
