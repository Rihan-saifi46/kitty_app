import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/routing/route_paths.dart';
import 'app_bottom_nav_bar.dart';
import 'header_nav_bar.dart';
import 'luxury_nav_drawer.dart';

/// Persistent luxury application shell wrapping the primary navigation tabs.
///
/// Houses the sticky header, slide-out navigation drawer, blurry frosted-glass bottom navigation dock,
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

  int _resolveBottomNavIndex(String location) {
    if (location.startsWith(RoutePaths.coinRates)) return 1;
    if (location.startsWith(RoutePaths.jewellery)) return 2;
    if (location.startsWith(RoutePaths.calculator)) return 3;
    return 0; // Home or default
  }

  void _onBottomNavTapped(int index) {
    switch (index) {
      case 0:
        widget.navigationShell.goBranch(0);
        break;
      case 1:
        widget.navigationShell.goBranch(1);
        break;
      case 2:
        widget.navigationShell.goBranch(2);
        break;
      case 3:
        widget.navigationShell.goBranch(3);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    final int activeIndex = _resolveBottomNavIndex(location);

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
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: AppColors.homeCanvasBg,
        appBar: HeaderNavBar(
          onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        drawer: const LuxuryNavDrawer(),
        body: widget.navigationShell,
        bottomNavigationBar: AppBottomNavBar(
          currentIndex: activeIndex,
          onTap: _onBottomNavTapped,
        ),
      ),
    );
  }
}
