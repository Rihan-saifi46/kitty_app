import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../buttons/kitty_ghost_button.dart';

/// Standard section title header with optional eyebrow kicker and action button.
class KittySectionHeader extends StatelessWidget {
  const KittySectionHeader({
    super.key,
    required this.title,
    this.eyebrow,
    this.actionLabel,
    this.onAction,
    this.isDarkSurface = false,
    this.padding = EdgeInsets.zero,
  });

  /// Main section title.
  final String title;

  /// Optional top uppercase kicker (e.g. "EXCLUSIVE PRIVILEGES").
  final String? eyebrow;

  /// Optional right-aligned action button label (e.g. "View All", "Download PDF").
  final String? actionLabel;

  /// Action callback.
  final VoidCallback? onAction;

  /// Surface mode.
  final bool isDarkSurface;

  /// Outer padding.
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final Color titleColor = isDarkSurface
        ? AppColors.textPrimaryLight
        : AppColors.textPrimaryDark;

    return Padding(
      padding: padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (eyebrow != null) ...<Widget>[
                  Text(
                    eyebrow!.toUpperCase(),
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                      color: AppColors.goldPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                ],
                Text(
                  title,
                  style: GoogleFonts.cinzel(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: titleColor,
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
          ),
          if (actionLabel != null && onAction != null) ...<Widget>[
            KittyGhostButton(
              label: actionLabel!,
              onPressed: onAction,
              fontSize: 12.5,
            ),
          ],
        ],
      ),
    );
  }
}
