import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/providers/auth_state_provider.dart';
import '../../../../core/routing/route_paths.dart';

/// Luxury slide-out navigation drawer strictly matching the approved prototype.
class LuxuryNavDrawer extends ConsumerWidget {
  const LuxuryNavDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppAuthState authState = ref.watch(appAuthStateProvider);
    final String currentPath = GoRouterState.of(context).uri.path;

    return Drawer(
      backgroundColor: AppColors.deepEmeraldBase,
      child: SafeArea(
        child: Column(
          children: <Widget>[
            // 1. Drawer Header & Brand Row
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 12, 16),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.goldSubtle,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.goldBorder),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.diamond_outlined,
                        color: AppColors.goldPrimary,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.space8),
                  Expanded(
                    child: Text(
                      'SWASTIK VAULT',
                      style: AppTypography.displaySubtitle(
                        color: AppColors.goldLight,
                      ).copyWith(letterSpacing: 1.5, fontSize: 16),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.close_rounded,
                      color: AppColors.textPrimaryLight,
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
                  color: AppColors.emeraldCard,
                  borderRadius: AppRadius.border16,
                  border: Border.all(color: AppColors.emeraldBorder),
                ),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: AppColors.goldSubtle,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.goldBorder, width: 1.5),
                      ),
                      child: Center(
                        child: Text(
                          authState.userName.isNotEmpty
                              ? authState.userName[0].toUpperCase()
                              : 'P',
                          style: AppTypography.displaySubtitle(
                            color: AppColors.goldPrimary,
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
                              color: AppColors.textPrimaryLight,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            authState.userPhone,
                            style: AppTypography.labelMeta(
                              color: AppColors.emeraldTextSubtle,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.goldSubtle,
                              borderRadius: AppRadius.border12,
                              border: Border.all(
                                color: AppColors.goldBorder.withValues(alpha: 0.4),
                              ),
                            ),
                            child: Text(
                              authState.tier,
                              style: AppTypography.kickerCaps(
                                color: AppColors.goldLight,
                              ).copyWith(fontSize: 9),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.space16),

            // 3. Navigation Links List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: <Widget>[
                  _DrawerNavItem(
                    title: 'Home',
                    icon: Icons.storefront_outlined,
                    routePath: RoutePaths.home,
                    isActive: currentPath == RoutePaths.home,
                    onTap: () => _navigateTo(context, RoutePaths.home),
                  ),
                  _DrawerNavItem(
                    title: 'My Kitty Scheme',
                    icon: Icons.diamond_outlined,
                    routePath: RoutePaths.dashboard,
                    isActive: currentPath == RoutePaths.dashboard,
                    badgeText: 'Active',
                    badgeColor: AppColors.goldPrimary,
                    onTap: () => _navigateTo(context, RoutePaths.dashboard),
                  ),
                  _DrawerNavItem(
                    title: 'Passbook Ledger',
                    icon: Icons.menu_book_outlined,
                    routePath: RoutePaths.passbook,
                    isActive: currentPath == RoutePaths.passbook,
                    onTap: () => _navigateTo(context, RoutePaths.passbook),
                  ),
                  _DrawerNavItem(
                    title: 'Kitty Offers & Plans',
                    icon: Icons.card_giftcard_rounded,
                    routePath: RoutePaths.offers,
                    isActive: currentPath == RoutePaths.offers,
                    badgeText: 'Special',
                    badgeColor: AppColors.goldLight,
                    onTap: () => _navigateTo(context, RoutePaths.offers),
                  ),
                  _DrawerNavItem(
                    title: 'Notifications',
                    icon: Icons.notifications_outlined,
                    routePath: RoutePaths.notifications,
                    isActive: currentPath == RoutePaths.notifications,
                    onTap: () => _navigateTo(context, RoutePaths.notifications),
                  ),
                  _DrawerNavItem(
                    title: 'KYC Compliance',
                    icon: Icons.verified_user_outlined,
                    routePath: RoutePaths.kyc,
                    isActive: currentPath == RoutePaths.kyc,
                    onTap: () => _navigateTo(context, RoutePaths.kyc),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Divider(color: AppColors.emeraldBorder, height: 1),
                  ),
                  _DrawerNavItem(
                    title: 'Settings & Security',
                    icon: Icons.settings_outlined,
                    routePath: RoutePaths.settings,
                    isActive: currentPath == RoutePaths.settings,
                    onTap: () => _navigateTo(context, RoutePaths.settings),
                  ),
                  _DrawerNavItem(
                    title: 'Log Out of Account',
                    icon: Icons.logout_rounded,
                    routePath: RoutePaths.login,
                    isActive: false,
                    isDestructive: true,
                    onTap: () => _handleLogout(context, ref),
                  ),
                ],
              ),
            ),

            // 4. VIP Concierge Footer Pill
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                decoration: BoxDecoration(
                  color: AppColors.goldSubtle,
                  borderRadius: AppRadius.border12,
                  border: Border.all(
                    color: AppColors.goldBorder.withValues(alpha: 0.4),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      '✦',
                      style: TextStyle(color: AppColors.goldPrimary, fontSize: 13),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'Swastik VIP Concierge • 1800-SWASTIK',
                        style: AppTypography.kickerCaps(
                          color: AppColors.goldLight,
                        ).copyWith(fontSize: 10),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateTo(BuildContext context, String path) {
    Navigator.of(context).pop(); // Close drawer first
    context.go(path);
  }

  Future<void> _handleLogout(BuildContext context, WidgetRef ref) async {
    Navigator.of(context).pop(); // Close drawer

    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        backgroundColor: AppColors.emeraldCard,
        title: Text(
          'Log Out of Account?',
          style: AppTypography.displaySubtitle(color: AppColors.textPrimaryLight),
        ),
        content: Text(
          'Are you sure you want to end your current session?',
          style: AppTypography.bodyRegular(color: AppColors.emeraldTextSubtle),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              'Cancel',
              style: AppTypography.bodyRegular(color: AppColors.emeraldTextSubtle),
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
      await ref.read(appAuthStateProvider.notifier).logout();
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
        : (isActive ? AppColors.goldPrimary : AppColors.textPrimaryLight);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Material(
        color: isActive ? AppColors.goldSubtle : Colors.transparent,
        borderRadius: AppRadius.border12,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.border12,
          splashColor: AppColors.goldSubtle,
          highlightColor: AppColors.goldSubtle.withValues(alpha: 0.5),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
                      fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ),
                if (badgeText != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.goldSubtle,
                      borderRadius: AppRadius.border12,
                      border: Border.all(
                        color: badgeColor ?? AppColors.goldBorder,
                        width: 0.8,
                      ),
                    ),
                    child: Text(
                      badgeText!,
                      style: AppTypography.kickerCaps(
                        color: badgeColor ?? AppColors.goldPrimary,
                      ).copyWith(fontSize: 9),
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
