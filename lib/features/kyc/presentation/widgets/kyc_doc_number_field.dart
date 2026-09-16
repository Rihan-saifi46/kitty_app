import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/enums/app_enums.dart';

/// Custom formatter to insert space every 4 digits for Aadhaar: `1234 5678 9012`.
class AadhaarInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final String digitsOnly = newValue.text.replaceAll(RegExp(r'\D'), '');
    final StringBuffer buffer = StringBuffer();

    for (int i = 0; i < digitsOnly.length && i < 12; i++) {
      if (i > 0 && i % 4 == 0) {
        buffer.write(' ');
      }
      buffer.write(digitsOnly[i]);
    }

    final String formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

/// Document number input field with live validation icons matching `kyc.html`.
class KycDocNumberField extends StatelessWidget {
  const KycDocNumberField({
    super.key,
    required this.docType,
    required this.controller,
    required this.onChanged,
    required this.isValid,
    this.errorText,
    this.enabled = true,
  });

  final DocTypeEnum docType;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final bool isValid;
  final String? errorText;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final bool isAadhaar = docType == DocTypeEnum.aadhaar;
    final String label = isAadhaar
        ? 'Aadhaar Number (12 Digits)'
        : 'PAN Card Number (10 Characters)';
    final String placeholder = isAadhaar ? 'XXXX XXXX XXXX' : 'ABCDE1234F';
    final String hint = isAadhaar ? '12 Digits' : '10 Characters';

    final bool hasError = errorText != null && errorText!.isNotEmpty;
    final bool hasText = controller.text.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.emeraldTextSubtle,
                  letterSpacing: 0.2,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: AppSpacing.space8),
            Text(
              hint,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11.5,
                fontWeight: FontWeight.w500,
                color: AppColors.emeraldTextSubtle.withAlpha(160),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.space6),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(18),
            borderRadius: AppRadius.border12,
            border: Border.all(
              color: hasError
                  ? AppColors.statusErrorText
                  : (isValid
                      ? AppColors.statusSuccessText
                      : Colors.white.withAlpha(35)),
              width: hasError || isValid ? 1.4 : 1.0,
            ),
            boxShadow: isValid
                ? <BoxShadow>[
                    BoxShadow(
                      color: AppColors.statusSuccessText.withAlpha(30),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : (hasError
                    ? <BoxShadow>[
                        BoxShadow(
                          color: AppColors.statusErrorText.withAlpha(30),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null),
          ),
          child: Row(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(left: AppSpacing.space14),
                child: Icon(
                  Icons.lock_outline,
                  size: 18,
                  color: AppColors.goldPrimary,
                ),
              ),
              Expanded(
                child: TextField(
                  controller: controller,
                  enabled: enabled,
                  keyboardType: isAadhaar
                      ? TextInputType.number
                      : TextInputType.text,
                  textCapitalization: isAadhaar
                      ? TextCapitalization.none
                      : TextCapitalization.characters,
                  inputFormatters: isAadhaar
                      ? <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                          AadhaarInputFormatter(),
                          LengthLimitingTextInputFormatter(14), // 12 digits + 2 spaces
                        ]
                      : <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
                          UpperCaseTextFormatter(),
                          LengthLimitingTextInputFormatter(10),
                        ],
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    letterSpacing: isAadhaar ? 2.0 : 1.5,
                    color: AppColors.textPrimaryLight,
                  ),
                  cursorColor: AppColors.goldPrimary,
                  onChanged: onChanged,
                  decoration: InputDecoration(
                    hintText: placeholder,
                    hintStyle: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      letterSpacing: isAadhaar ? 2.0 : 1.5,
                      color: AppColors.emeraldTextSubtle.withAlpha(120),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.space12,
                      vertical: AppSpacing.space14,
                    ),
                  ),
                ),
              ),
              // Live status indicator icon
              if (isValid) ...<Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.space12),
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.statusSuccessText.withAlpha(30),
                    ),
                    child: const Icon(
                      Icons.check,
                      size: 15,
                      color: AppColors.statusSuccessText,
                    ),
                  ),
                ),
              ] else if (hasError || (hasText && !isValid && _isComplete(isAadhaar, controller.text))) ...<Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.space12),
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.statusErrorText.withAlpha(30),
                    ),
                    child: const Icon(
                      Icons.error_outline,
                      size: 15,
                      color: AppColors.statusErrorText,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        if (hasError) ...<Widget>[
          const SizedBox(height: AppSpacing.space4),
          Row(
            children: <Widget>[
              const Icon(
                Icons.error_outline,
                size: 13,
                color: AppColors.statusErrorText,
              ),
              const SizedBox(width: AppSpacing.space4),
              Expanded(
                child: Text(
                  errorText!,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.statusErrorText,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  bool _isComplete(bool isAadhaar, String text) {
    if (isAadhaar) {
      return text.replaceAll(' ', '').length >= 12;
    }
    return text.trim().length >= 10;
  }
}

/// Formatter to convert text to uppercase.
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
