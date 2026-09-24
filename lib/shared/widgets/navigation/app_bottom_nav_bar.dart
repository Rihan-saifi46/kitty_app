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
class AppBottomNavBar extends StatelessWidget {
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
      icon: Icons.storefront_outlined,
      activeIcon: Icons.storefront_rounded,
    ),
    _NavItemData(
      label: 'Coin Rates',
      icon: Icons.monetization_on_outlined,
      activeIcon: Icons.monetization_on_rounded,
    ),
    _NavItemData(
      label: 'Jewellery',
      icon: Icons.diamond_outlined,
      activeIcon: Icons.diamond_rounded,
    ),
    _NavItemData(
      label: 'Calculator',
      icon: Icons.calculate_outlined,
      activeIcon: Icons.calculate_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.creamIvoryCard.withValues(alpha: 0.85),
            border: const Border(
              top: BorderSide(
                color: AppColors.warmLinenInset,
                width: 1.2,
              ),
            ),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: Color(0x122B2521),
                blurRadius: 20,
                offset: Offset(0, -6),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List<Widget>.generate(
                  _items.length,
                  (int index) => _DockNavItem(
                    data: _items[index],
                    isSelected: currentIndex == index,
                    onTap: () {
                      HapticFeedback.selectionClick();
                      onTap(index);
                    },
                  ),
                ),
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
    final Color itemColor = isSelected ? AppColors.espressoCharcoal : AppColors.warmTaupeBrown;
    final Color iconColor = isSelected ? AppColors.honeyGoldAccent : AppColors.warmTaupeBrown;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: isSelected
            ? const EdgeInsets.symmetric(horizontal: 10, vertical: 5)
            : const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.champagneFoil.withValues(alpha: 0.55) : Colors.transparent,
          borderRadius: AppRadius.border16,
          border: Border.all(
            color: isSelected
                ? AppColors.honeyGoldAccent.withValues(alpha: 0.35)
                : Colors.transparent,
            width: 1,
          ),
        ),
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
    );
  }
}
