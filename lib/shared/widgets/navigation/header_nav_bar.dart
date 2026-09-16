import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/routing/route_paths.dart';

/// Sticky luxury top application header matching the approved Swastik prototype.
///
/// Features the royal brand crest, live 24K gold rate benchmark pill,
/// notifications bell with unread badge, and the navigation drawer hamburger toggle.
class HeaderNavBar extends StatelessWidget implements PreferredSizeWidget {
  const HeaderNavBar({
    super.key,
    this.onMenuPressed,
    this.unreadNotificationsCount = 2,
    this.goldRate24k = 7485.50,
  });

  /// Callback to open the slide-out luxury navigation drawer.
  final VoidCallback? onMenuPressed;

  /// Count of unread transactional notifications.
  final int unreadNotificationsCount;

  /// Daily benchmark gold rate per gram.
  final double goldRate24k;

  @override
  Size get preferredSize => const Size.fromHeight(62);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.deepEmeraldBase,
        border: Border(
          bottom: BorderSide(
            color: AppColors.goldBorder.withValues(alpha: 0.35),
            width: 1,
          ),
        ),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x40000000),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: <Widget>[
              // Left: Brand Crest & Logo
              GestureDetector(
                onTap: () => context.go(RoutePaths.home),
                behavior: HitTestBehavior.opaque,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: AppColors.goldSubtle,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.goldBorder,
                          width: 1.2,
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.diamond_outlined,
                          color: AppColors.goldPrimary,
                          size: 18,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.space8),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'SWASTIK',
                          style: AppTypography.kickerCaps(
                            color: AppColors.goldLight,
                          ).copyWith(
                            letterSpacing: 2.2,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          'JEWELLERS',
                          style: AppTypography.labelMeta(
                            color: AppColors.emeraldTextSubtle,
                          ).copyWith(
                            fontSize: 8.5,
                            letterSpacing: 1.8,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Middle-Right: Live Gold Rate Ticker Pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.goldSubtle,
                  borderRadius: AppRadius.border20,
                  border: Border.all(
                    color: AppColors.goldBorder.withValues(alpha: 0.5),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppColors.statusSuccessText,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '24K: ₹${goldRate24k.toInt()}/g',
                      style: AppTypography.kickerCaps(
                        color: AppColors.goldLight,
                      ).copyWith(fontSize: 10.5),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: AppSpacing.space8),

              // Right: Notifications Bell Icon with Badge
              IconButton(
                onPressed: () => context.push(RoutePaths.notifications),
                icon: Stack(
                  clipBehavior: Clip.none,
                  children: <Widget>[
                    const Icon(
                      Icons.notifications_outlined,
                      color: AppColors.textPrimaryLight,
                      size: 22,
                    ),
                    if (unreadNotificationsCount > 0)
                      Positioned(
                        right: -2,
                        top: -2,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(
                            color: AppColors.goldPrimary,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 14,
                            minHeight: 14,
                          ),
                          child: Center(
                            child: Text(
                              '$unreadNotificationsCount',
                              style: const TextStyle(
                                color: AppColors.deepEmeraldBase,
                                fontSize: 8.5,
                                fontWeight: FontWeight.bold,
                                height: 1,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                splashRadius: 20,
                tooltip: 'Notifications',
              ),

              const SizedBox(width: AppSpacing.space4),

              // Far Right: 3-Lines Navigation Hamburger Toggle Button
              IconButton(
                onPressed: onMenuPressed,
                icon: const Icon(
                  Icons.menu_rounded,
                  color: AppColors.goldPrimary,
                  size: 24,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                splashRadius: 20,
                tooltip: 'Open Menu',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
