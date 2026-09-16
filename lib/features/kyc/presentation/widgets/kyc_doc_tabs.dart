import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/enums/app_enums.dart';

/// Document selector tab widget matching `kyc.html` / `kyc.css`.
class KycDocTabs extends StatelessWidget {
  const KycDocTabs({
    super.key,
    required this.selectedDocType,
    required this.onDocTypeChanged,
    this.enabled = true,
  });

  final DocTypeEnum selectedDocType;
  final ValueChanged<DocTypeEnum> onDocTypeChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          'Select Document Type',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.emeraldTextSubtle,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: AppSpacing.space8),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(12),
            borderRadius: AppRadius.border12,
            border: Border.all(
              color: Colors.white.withAlpha(25),
              width: 1,
            ),
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: _buildTab(
                  context: context,
                  type: DocTypeEnum.aadhaar,
                  label: 'Aadhaar Card',
                  icon: Icons.badge_outlined,
                  isSelected: selectedDocType == DocTypeEnum.aadhaar,
                ),
              ),
              const SizedBox(width: AppSpacing.space6),
              Expanded(
                child: _buildTab(
                  context: context,
                  type: DocTypeEnum.pan,
                  label: 'PAN Card',
                  icon: Icons.credit_card_outlined,
                  isSelected: selectedDocType == DocTypeEnum.pan,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTab({
    required BuildContext context,
    required DocTypeEnum type,
    required String label,
    required IconData icon,
    required bool isSelected,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? () => onDocTypeChanged(type) : null,
        borderRadius: AppRadius.border10,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 11),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.goldPrimary
                : Colors.transparent,
            borderRadius: AppRadius.border10,
            boxShadow: isSelected
                ? <BoxShadow>[
                    BoxShadow(
                      color: AppColors.goldPrimary.withAlpha(70),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                icon,
                size: 16,
                color: isSelected
                    ? AppColors.deepEmeraldBase
                    : AppColors.emeraldTextSubtle,
              ),
              const SizedBox(width: AppSpacing.space8),
              Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13.5,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected
                      ? AppColors.deepEmeraldBase
                      : AppColors.textPrimaryLight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
