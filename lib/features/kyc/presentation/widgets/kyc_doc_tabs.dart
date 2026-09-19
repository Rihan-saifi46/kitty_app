import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

  static const Color _goldLight = Color(0xFFF4E2AA);
  static const Color _tabGroupBg = Color(0xD9041913); // rgba(4, 25, 19, 0.85)
  static const Color _tabBorder = Color(0x40CCA243); // rgba(204, 162, 65, 0.25)
  static const Color _textMuted = Color(0xFF8FA499);
  static const Color _darkText = Color(0xFF1A1404);

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          'SELECT DOCUMENT TYPE',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: _goldLight,
            letterSpacing: 0.04 * 12,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: _tabGroupBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: _tabBorder,
              width: 1,
            ),
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: _buildTab(
                  type: DocTypeEnum.aadhaar,
                  label: 'Aadhaar Card',
                  icon: Icons.badge_outlined,
                  isSelected: selectedDocType == DocTypeEnum.aadhaar,
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: _buildTab(
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
    required DocTypeEnum type,
    required String label,
    required IconData icon,
    required bool isSelected,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? () => onDocTypeChanged(type) : null,
        borderRadius: BorderRadius.circular(10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          height: 44,
          decoration: BoxDecoration(
            gradient: isSelected ? _goldGradient : null,
            color: isSelected ? null : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isSelected
                ? const <BoxShadow>[
                    BoxShadow(
                      color: Color(0x4DCCA243), // rgba(204, 162, 65, 0.3)
                      blurRadius: 14,
                      offset: Offset(0, 4),
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
                color: isSelected ? _darkText : _textMuted,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? _darkText : _textMuted,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
