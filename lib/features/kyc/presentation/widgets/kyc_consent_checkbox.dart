import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';

/// Mandatory statutory legal consent checkbox matching `kyc.html`.
class KycConsentCheckbox extends StatelessWidget {
  const KycConsentCheckbox({
    super.key,
    required this.isChecked,
    required this.onChanged,
    this.enabled = true,
  });

  final bool isChecked;
  final ValueChanged<bool> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? () => onChanged(!isChecked) : null,
        borderRadius: AppRadius.border10,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.space6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 22,
                height: 22,
                margin: const EdgeInsets.only(top: 2, right: AppSpacing.space10),
                decoration: BoxDecoration(
                  color: isChecked
                      ? AppColors.goldPrimary
                      : Colors.white.withAlpha(15),
                  borderRadius: AppRadius.border6,
                  border: Border.all(
                    color: isChecked
                        ? AppColors.goldPrimary
                        : Colors.white.withAlpha(50),
                    width: 1.4,
                  ),
                  boxShadow: isChecked
                      ? <BoxShadow>[
                          BoxShadow(
                            color: AppColors.goldPrimary.withAlpha(80),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: isChecked
                    ? const Center(
                        child: Icon(
                          Icons.check,
                          size: 15,
                          color: AppColors.deepEmeraldBase,
                        ),
                      )
                    : null,
              ),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      height: 1.45,
                      color: AppColors.emeraldTextSubtle,
                    ),
                    children: const <TextSpan>[
                      TextSpan(text: 'I agree to '),
                      TextSpan(
                        text: 'Swastik CRM',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimaryLight,
                        ),
                      ),
                      TextSpan(
                        text:
                            ' securely storing and verifying my identity documents in compliance with ',
                      ),
                      TextSpan(
                        text: 'RBI & PMLA',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppColors.goldPrimary,
                        ),
                      ),
                      TextSpan(text: ' statutory regulations.'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
