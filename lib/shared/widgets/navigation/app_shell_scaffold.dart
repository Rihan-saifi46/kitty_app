import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../features/notifications/presentation/providers/notifications_controller.dart';
import 'app_bottom_nav_bar.dart';
import 'header_nav_bar.dart';
import 'luxury_nav_drawer.dart';

/// Persistent luxury application shell wrapping the primary navigation tabs.
///
/// Houses the sticky header, slide-out navigation drawer, bottom navigation dock,
/// and Android hardware back-button interceptor.
class AppShellScaffold extends ConsumerStatefulWidget {
  const AppShellScaffold({
    required this.navigationShell,
    super.key,
  });

  /// Stateful navigation shell provided by GoRouter.
  final StatefulNavigationShell navigationShell;

  @override
  ConsumerState<AppShellScaffold> createState() => _AppShellScaffoldState();
}

class _AppShellScaffoldState extends ConsumerState<AppShellScaffold> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final int unreadCount = ref.watch(unreadNotificationsCountProvider);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        if (didPop) return;

        // 1. If drawer is open, close drawer first
        if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
          _scaffoldKey.currentState?.closeDrawer();
          return;
        }

        // 2. If not on Tab 0 (Home), return to Tab 0
        if (widget.navigationShell.currentIndex != 0) {
          widget.navigationShell.goBranch(0);
          return;
        }

        // 3. On root Tab 0, allow system pop / exit
        // In full app, can show double-tap to exit toast
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: isDark ? AppColors.deepEmeraldBase : AppColors.surfacePageBg,
        appBar: HeaderNavBar(
          onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
          unreadNotificationsCount: unreadCount,
        ),
        drawer: const LuxuryNavDrawer(),
        body: widget.navigationShell,
        bottomNavigationBar: AppBottomNavBar(
          currentIndex: widget.navigationShell.currentIndex,
          onTap: (int index) {
            widget.navigationShell.goBranch(
              index,
              initialLocation: index == widget.navigationShell.currentIndex,
            );
          },
        ),
      ),
    );
  }
}
