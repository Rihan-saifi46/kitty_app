import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';

/// Fixed luxury frosted-glass bottom navigation dock matching the Warm Luxury aesthetic.
///
/// Features 5 items:
/// 1. Home
/// 2. Coin Rates
/// 3. Jewellery
/// 4. KYC
/// 5. Menu
class AppBottomNavBar extends StatefulWidget {
  const AppBottomNavBar({
    required this.currentIndex,
    required this.onTap,
    super.key,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const List<_NavItemData> _items = <_NavItemData>[
    _NavItemData(
      label: 'Home',
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
    ),
    _NavItemData(
      label: 'My Kitty',
      icon: Icons.workspace_premium_outlined,
      activeIcon: Icons.workspace_premium_rounded,
    ),
    _NavItemData(
      label: 'Kitty Plans',
      icon: Icons.card_giftcard_outlined,
      activeIcon: Icons.card_giftcard_rounded,
    ),
    _NavItemData(
      label: 'Calculator',
      icon: Icons.calculate_outlined,
      activeIcon: Icons.calculate_rounded,
    ),
    _NavItemData(
      label: 'Jewellery',
      icon: Icons.diamond_outlined,
      activeIcon: Icons.diamond_rounded,
    ),
  ];

  @override
  State<AppBottomNavBar> createState() => _AppBottomNavBarState();
}

class _AppBottomNavBarState extends State<AppBottomNavBar> {
  late int _activeIndex;

  @override
  void initState() {
    super.initState();
    _activeIndex = widget.currentIndex;
  }

  @override
  void didUpdateWidget(covariant AppBottomNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentIndex != _activeIndex) {
      setState(() {
        _activeIndex = widget.currentIndex;
      });
    }
  }

  void _onTabSelected(int index) {
    if (_activeIndex != index) {
      setState(() {
        _activeIndex = index;
      });
    }
    HapticFeedback.selectionClick();
    widget.onTap(index);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.pureWhite.withValues(alpha: 0.94),
            border: const Border(
              top: BorderSide(
                color: AppColors.homeNavbarBorder,
                width: 1.0,
              ),
            ),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: Color(0x0D063D2E),
                blurRadius: 16,
                offset: Offset(0, -4),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  final double tabWidth = constraints.maxWidth / AppBottomNavBar._items.length;
                  final double pillWidth = (tabWidth - 8).clamp(50.0, 70.0);
                  final bool hasActiveTab = _activeIndex >= 0 && _activeIndex < AppBottomNavBar._items.length;
                  final double indicatorLeft = hasActiveTab
                      ? _activeIndex * tabWidth + (tabWidth - pillWidth) / 2
                      : 0.0;

                  return SizedBox(
                    height: 52,
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: <Widget>[
                        // Smooth Sliding Active Indicator Capsule
                        AnimatedPositioned(
                          duration: const Duration(milliseconds: 280),
                          curve: Curves.easeOutCubic,
                          left: indicatorLeft,
                          top: 2,
                          bottom: 2,
                          width: pillWidth,
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 200),
                            opacity: hasActiveTab ? 1.0 : 0.0,
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0x18063D2E),
                                borderRadius: AppRadius.border16,
                                border: Border.all(
                                  color: AppColors.primaryEmerald.withValues(alpha: 0.22),
                                  width: 1,
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Nav Items Row
                        Row(
                          children: List<Widget>.generate(
                            AppBottomNavBar._items.length,
                            (int index) => Expanded(
                              child: _DockNavItem(
                                data: AppBottomNavBar._items[index],
                                isSelected: hasActiveTab && _activeIndex == index,
                                onTap: () => _onTabSelected(index),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItemData {
  const _NavItemData({
    required this.label,
    required this.icon,
    required this.activeIcon,
  });

  final String label;
  final IconData icon;
  final IconData activeIcon;
}

class _DockNavItem extends StatelessWidget {
  const _DockNavItem({
    required this.data,
    required this.isSelected,
    required this.onTap,
  });

  final _NavItemData data;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color itemColor = isSelected ? AppColors.primaryEmerald : AppColors.mutedNavGray;
    final Color iconColor = isSelected ? AppColors.primaryEmerald : AppColors.mutedNavGray;

    return Semantics(
      button: true,
      selected: isSelected,
      label: '${data.label} tab, ${isSelected ? "selected" : "not selected"}',
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              isSelected ? data.activeIcon : data.icon,
              color: iconColor,
              size: 21,
            ),
            const SizedBox(height: 2),
            Text(
              data.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.labelMeta(
                color: itemColor,
              ).copyWith(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                letterSpacing: isSelected ? 0.2 : 0,
              ),
            ),
          ],
        ),
      ),
    ),
  );
  }
}
