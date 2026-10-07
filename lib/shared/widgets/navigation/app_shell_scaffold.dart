import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/route_paths.dart';
import '../../../features/menu/presentation/widgets/kitty_menu_sheet.dart';
import 'app_bottom_nav_bar.dart';

/// Persistent luxury application shell wrapping the 4 canonical navigation tabs:
/// 1. Gold Plans
/// 2. My Plan
/// 3. Live Rate
/// 4. Calculator
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
    if (location.startsWith(RoutePaths.offers) || location == '/') return 0;
    if (location.startsWith(RoutePaths.dashboard)) return 1;
    if (location.startsWith(RoutePaths.liveRates)) return 2;
    if (location.startsWith(RoutePaths.calculator)) return 3;
    return 0; // Default to Tab 0 (Gold Plans)
  }

  void _onBottomNavTapped(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    final int activeIndex = _resolveBottomNavIndex(location);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        if (didPop) return;

        // 1. If end drawer is open, close it first
        if (_scaffoldKey.currentState?.isEndDrawerOpen ?? false) {
          _scaffoldKey.currentState?.closeEndDrawer();
          return;
        }

        // 2. If drawer is open, close it
        if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
          _scaffoldKey.currentState?.closeDrawer();
          return;
        }

        // 3. If not on Tab 0 (Gold Plans), return to Tab 0
        if (widget.navigationShell.currentIndex != 0) {
          widget.navigationShell.goBranch(0);
          return;
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: const Color(0xFFFAF7F2),
        endDrawer: const Drawer(
          backgroundColor: Color(0xFF07392F),
          child: SafeArea(
            bottom: false,
            child: KittyMenuSheet(),
          ),
        ),
        body: widget.navigationShell,
        bottomNavigationBar: AppBottomNavBar(
          currentIndex: activeIndex,
          onTap: _onBottomNavTapped,
        ),
      ),
    );
  }
}
