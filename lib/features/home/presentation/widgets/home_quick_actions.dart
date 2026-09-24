import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';

/// Model representing a quick action shortcut.
class QuickActionItem {
  const QuickActionItem({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final VoidCallback onTap;
}

/// Fast action shortcut row for instant navigation.
class HomeQuickActions extends StatelessWidget {
  const HomeQuickActions({
    super.key,
    required this.actions,
  });

  final List<QuickActionItem> actions;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.space16,
        vertical: AppSpacing.space6,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: actions.map((QuickActionItem action) {
          return InkWell(
            onTap: action.onTap,
            borderRadius: AppRadius.border12,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.homeNavbarBg,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.homeCategoryRingBorder,
                        width: 1.2,
                      ),
                      boxShadow: const <BoxShadow>[
                        BoxShadow(
                          color: Color(0x0A0C2B24),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        action.icon,
                        color: AppColors.homeBrandGold,
                        size: 22,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    action.title,
                    style: AppTypography.labelMeta(
                      color: AppColors.homeBodySubtitle,
                    ).copyWith(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
