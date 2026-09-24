import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/providers/auth_state_provider.dart';
import '../../../../core/routing/route_paths.dart';
import '../../../notifications/presentation/providers/notifications_controller.dart';

/// Fullscreen Menu Page containing the exact items from the 3-lines navbar drawer,
/// rendered in the warm luxury color scheme matching Home, Passbook, and Settings.
class MenuScreen extends ConsumerWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppAuthState authState = ref.watch(appAuthStateProvider);
    final int unreadNotificationsCount = ref.watch(unreadNotificationsCountProvider);
    String currentPath = RoutePaths.menu;
    try {
      currentPath = GoRouterState.of(context).uri.path;
    } catch (_) {}

    return Scaffold(
      backgroundColor: AppColors.homeCanvasBg,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          slivers: <Widget>[
            // 1. Patron Profile Card
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
                child: Container(
                  padding: AppSpacing.all16,
                  decoration: BoxDecoration(
                    color: AppColors.creamIvoryCard,
                    borderRadius: AppRadius.border16,
                    border: Border.all(color: AppColors.warmLinenInset),
                    boxShadow: const <BoxShadow>[
                      BoxShadow(
                        color: Color(0x062B2521),
                        blurRadius: 10,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: AppColors.champagneFoil,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.honeyGoldAccent.withValues(alpha: 0.5),
                            width: 1.5,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            authState.userName.isNotEmpty
                                ? authState.userName[0].toUpperCase()
                                : 'P',
                            style: AppTypography.displaySubtitle(
                              color: AppColors.espressoCharcoal,
                            ).copyWith(fontWeight: FontWeight.w900),
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
                              style: AppTypography.cardTitle(
                                color: AppColors.espressoCharcoal,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              authState.userPhone,
                              style: AppTypography.caption(
                                color: AppColors.warmTaupeBrown,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.warmLinenInset,
                                borderRadius: AppRadius.border12,
                                border: Border.all(
                                  color: AppColors.honeyGoldAccent.withValues(alpha: 0.3),
                                ),
                              ),
                              child: Text(
                                authState.tier,
                                style: AppTypography.kickerCaps(
                                  color: AppColors.honeyGoldAccent,
                                ).copyWith(fontSize: 9.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 2. Navigation Items List (Matching 3-lines Drawer)
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  <Widget>[
                    _MenuNavItem(
                      title: 'Home',
                      icon: Icons.storefront_outlined,
                      routePath: RoutePaths.home,
                      isActive: currentPath == RoutePaths.home,
                      onTap: () => context.go(RoutePaths.home),
                    ),
                    _MenuNavItem(
                      title: 'My Kitty Scheme',
                      icon: Icons.diamond_outlined,
                      routePath: RoutePaths.dashboard,
                      isActive: currentPath == RoutePaths.dashboard,
                      badgeText: 'Active',
                      badgeColor: AppColors.honeyGoldAccent,
                      onTap: () => context.go(RoutePaths.dashboard),
                    ),
                    _MenuNavItem(
                      title: 'Passbook Ledger',
                      icon: Icons.menu_book_outlined,
                      routePath: RoutePaths.passbook,
                      isActive: currentPath == RoutePaths.passbook,
                      onTap: () => context.go(RoutePaths.passbook),
                    ),
                    _MenuNavItem(
                      title: 'Kitty Offers & Plans',
                      icon: Icons.card_giftcard_rounded,
                      routePath: RoutePaths.offers,
                      isActive: currentPath == RoutePaths.offers,
                      badgeText: 'Special',
                      badgeColor: AppColors.honeyGoldAccent,
                      onTap: () => context.go(RoutePaths.offers),
                    ),
                    _MenuNavItem(
                      title: 'Notifications',
                      icon: Icons.notifications_outlined,
                      routePath: RoutePaths.notifications,
                      isActive: currentPath == RoutePaths.notifications,
                      badgeText: unreadNotificationsCount > 0 ? '$unreadNotificationsCount' : null,
                      badgeColor: AppColors.honeyGoldAccent,
                      onTap: () => context.push(RoutePaths.notifications),
                    ),
                    _MenuNavItem(
                      title: 'KYC Compliance',
                      icon: Icons.verified_user_outlined,
                      routePath: RoutePaths.kyc,
                      isActive: currentPath == RoutePaths.kyc,
                      onTap: () => context.push(RoutePaths.kyc),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Divider(color: AppColors.warmLinenInset, height: 1),
                    ),
                    _MenuNavItem(
                      title: 'Settings & Security',
                      icon: Icons.settings_outlined,
                      routePath: RoutePaths.settings,
                      isActive: currentPath == RoutePaths.settings,
                      onTap: () => context.go(RoutePaths.settings),
                    ),
                    _MenuNavItem(
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
            ),

            // 3. VIP Concierge Footer
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 64),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.creamIvoryCard,
                    borderRadius: AppRadius.border16,
                    border: Border.all(
                      color: AppColors.honeyGoldAccent.withValues(alpha: 0.35),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        '✦',
                        style: TextStyle(color: AppColors.honeyGoldAccent, fontSize: 14),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          'Swastik VIP Concierge • 1800-SWASTIK',
                          style: AppTypography.kickerCaps(
                            color: AppColors.espressoCharcoal,
                          ).copyWith(fontSize: 10.5),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleLogout(BuildContext context, WidgetRef ref) async {
    final AppAuthNotifier authNotifier = ref.read(appAuthStateProvider.notifier);

    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        backgroundColor: AppColors.creamIvoryCard,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.border16),
        title: Text(
          'Log Out of Account?',
          style: AppTypography.cardTitle(color: AppColors.espressoCharcoal),
        ),
        content: Text(
          'Are you sure you want to end your current session? You will need to re-verify via OTP.',
          style: AppTypography.bodyRegular(color: AppColors.warmTaupeBrown),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              'Cancel',
              style: AppTypography.bodyRegular(color: AppColors.warmTaupeBrown),
            ),
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

    if (confirmed == true) {
      await authNotifier.logout();
      if (context.mounted) {
        context.go(RoutePaths.login);
      }
    }
  }
}

/// Navigation item widget matching warm luxury styling.
class _MenuNavItem extends StatelessWidget {
  const _MenuNavItem({
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
        : (isActive ? AppColors.honeyGoldAccent : AppColors.espressoCharcoal);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Container(
        decoration: BoxDecoration(
          color: isActive ? AppColors.champagneFoil.withValues(alpha: 0.35) : AppColors.creamIvoryCard,
          borderRadius: AppRadius.border16,
          border: Border.all(
            color: isActive ? AppColors.honeyGoldAccent.withValues(alpha: 0.4) : AppColors.warmLinenInset,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: AppRadius.border16,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: <Widget>[
                  Icon(icon, color: itemColor, size: 21),
                  const SizedBox(width: AppSpacing.space12),
                  Expanded(
                    child: Text(
                      title,
                      style: AppTypography.bodyBold(
                        color: itemColor,
                      ).copyWith(
                        fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  if (badgeText != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.champagneFoil,
                        borderRadius: AppRadius.border12,
                        border: Border.all(
                          color: badgeColor ?? AppColors.honeyGoldAccent,
                          width: 0.8,
                        ),
                      ),
                      child: Text(
                        badgeText!,
                        style: AppTypography.kickerCaps(
                          color: AppColors.espressoCharcoal,
                        ).copyWith(fontSize: 9.5),
                      ),
                    ),
                  if (badgeText == null && !isDestructive)
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 13,
                      color: AppColors.warmTaupeBrown,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
