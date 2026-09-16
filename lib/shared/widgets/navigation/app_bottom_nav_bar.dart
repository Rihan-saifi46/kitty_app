import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';

/// Fixed luxury bottom navigation dock strictly matching the approved prototype.
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
      label: 'My Kitty',
      icon: Icons.diamond_outlined,
      activeIcon: Icons.diamond_rounded,
    ),
    _NavItemData(
      label: 'Passbook',
      icon: Icons.menu_book_outlined,
      activeIcon: Icons.menu_book_rounded,
    ),
    _NavItemData(
      label: 'Offers',
      icon: Icons.card_giftcard_outlined,
      activeIcon: Icons.card_giftcard_rounded,
    ),
    _NavItemData(
      label: 'Settings',
      icon: Icons.settings_outlined,
      activeIcon: Icons.settings_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.deepEmeraldBase,
        border: Border(
          top: BorderSide(
            color: AppColors.goldBorder.withValues(alpha: 0.35),
            width: 1,
          ),
        ),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x59000000),
            blurRadius: 30,
            offset: Offset(0, -8),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
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
    final Color itemColor = isSelected ? AppColors.goldLight : AppColors.emeraldTextSubtle;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: isSelected
            ? const EdgeInsets.symmetric(horizontal: 14, vertical: 6)
            : const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.goldSubtle : Colors.transparent,
          borderRadius: AppRadius.border16,
          border: Border.all(
            color: isSelected
                ? AppColors.goldBorder.withValues(alpha: 0.4)
                : Colors.transparent,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              isSelected ? data.activeIcon : data.icon,
              color: itemColor,
              size: 20,
            ),
            const SizedBox(height: 3),
            Text(
              data.label,
              style: AppTypography.labelMeta(
                color: itemColor,
              ).copyWith(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
