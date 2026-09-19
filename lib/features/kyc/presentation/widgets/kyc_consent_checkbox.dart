import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

  static const Color _goldLight = Color(0xFFF4E2AA);
  static const Color _goldBright = Color(0xFFFFE899);
  static const Color _checkboxBg = Color(0xD9041913); // rgba(4, 25, 19, 0.85)
  static const Color _checkboxBorder = Color(0x59CCA243); // rgba(204, 162, 65, 0.35)
  static const Color _textMuted = Color(0xFF8FA499);
  static const Color _darkCheck = Color(0xFF1A1404);

  static const LinearGradient _goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[
      Color(0xFFCCA243),
      Color(0xFFF4E2AA),
      Color(0xFFCCA243),
    ],
    stops: <double>[0.0, 0.5, 1.0],
  );

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? () => onChanged(!isChecked) : null,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Custom 20x20 Checkbox Box
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOutCubic,
                width: 20,
                height: 20,
                margin: const EdgeInsets.only(top: 2, right: 12),
                decoration: BoxDecoration(
                  gradient: isChecked ? _goldGradient : null,
                  color: isChecked ? null : _checkboxBg,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: isChecked ? _goldBright : _checkboxBorder,
                    width: 1.5,
                  ),
                  boxShadow: isChecked
                      ? const <BoxShadow>[
                          BoxShadow(
                            color: Color(0x59CCA243), // rgba(204, 162, 65, 0.35)
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ]
                      : null,
                ),
                child: isChecked
                    ? const Center(
                        child: Icon(
                          Icons.check_rounded,
                          size: 14,
                          color: _darkCheck,
                        ),
                      )
                    : null,
              ),

              // Consent Text
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11.8,
                      height: 1.5,
                      color: _textMuted,
                    ),
                    children: const <TextSpan>[
                      TextSpan(text: 'I agree to '),
                      TextSpan(
                        text: 'Swastik CRM',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: _goldLight,
                        ),
                      ),
                      TextSpan(
                        text:
                            ' securely storing and verifying my identity documents in compliance with ',
                      ),
                      TextSpan(
                        text: 'RBI & PMLA',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: _goldLight,
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
