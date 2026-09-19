import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../shared/widgets/buttons/kitty_primary_button.dart';
import '../../domain/entities/kyc_entity.dart';

/// Gold and emerald visual constants matching `kyc.html` / `kyc.css`.
class _KycStatusTokens {
  static const Color goldLight = Color(0xFFF4E2AA);
  static const Color goldBright = Color(0xFFFFE899);
  static const Color goldPrimary = Color(0xFFCCA243);
  static const Color goldMuted = Color(0x47CCA243); // rgba(204, 162, 65, 0.28)
  static const Color textMuted = Color(0xFF8FA499);
  static const Color danger = Color(0xFFEF4444);
  static const Color dangerBg = Color(0x1AEF4444);
  static const Color dangerBorder = Color(0x40EF4444);

  static const RadialGradient successOrbGradient = RadialGradient(
    colors: <Color>[
      Color(0x40CCA243), // rgba(204, 162, 65, 0.25)
      Color(0x660D4A3A), // rgba(13, 74, 58, 0.40)
    ],
    stops: <double>[0.0, 1.0],
  );

  static const RadialGradient rejectedOrbGradient = RadialGradient(
    colors: <Color>[
      Color(0x40EF4444),
      Color(0x662A0D0D),
    ],
    stops: <double>[0.0, 1.0],
  );
}

/// KYC Submitted Successfully view matching `kyc.html`.
class KycSuccessView extends StatelessWidget {
  const KycSuccessView({
    super.key,
    required this.result,
    required this.onProceed,
  });

  final KycResultEntity? result;
  final VoidCallback onProceed;

  @override
  Widget build(BuildContext context) {
    final String refCode = result?.referenceId ?? 'KYC-849201';

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const SizedBox(height: 16),

        // Success Badge Orb (72x72) matching kyc.css `.success-badge-orb`
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: _KycStatusTokens.successOrbGradient,
            border: Border.all(
              color: _KycStatusTokens.goldPrimary,
              width: 1.5,
            ),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: Color(0x59CCA243), // rgba(204, 162, 65, 0.35)
                blurRadius: 30,
              ),
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.check_rounded,
              size: 34,
              color: _KycStatusTokens.goldBright,
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Success Heading: Cormorant Garamond 26px
        Text(
          'KYC Submitted Successfully',
          style: GoogleFonts.cormorantGaramond(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: _KycStatusTokens.goldLight,
            letterSpacing: 0.5,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 8),

        // Reference Code Chip: .success-ref-chip
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0x26CCA243), // rgba(204, 162, 65, 0.15)
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _KycStatusTokens.goldMuted,
              width: 1,
            ),
          ),
          child: Text(
            'Ref: #$refCode',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: _KycStatusTokens.goldBright,
              letterSpacing: 0.5,
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Success Paragraph
        Text(
          'Your statutory identity documents have been securely encrypted and submitted. Your Royal Kitty Vault scheme enrollment is authorized.',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13.5,
            height: 1.6,
            color: _KycStatusTokens.textMuted,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 24),

        // Button: Enter Kitty Vault Dashboard
        KittyPrimaryButton(
          label: 'Enter Kitty Vault Dashboard',
          icon: const Icon(Icons.arrow_forward_rounded, size: 16),
          onPressed: onProceed,
        ),

        const SizedBox(height: 10),
      ],
    );
  }
}

/// KYC Under Verification / Pending review state view.
class KycPendingView extends StatelessWidget {
  const KycPendingView({
    super.key,
    required this.result,
    required this.onReturnHome,
  });

  final KycResultEntity? result;
  final VoidCallback onReturnHome;

  @override
  Widget build(BuildContext context) {
    final String refCode = result?.referenceId ?? 'KYC-PENDING';
    final String masked = result?.documentNumberMasked ?? 'XXXX XXXX 1234';

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const SizedBox(height: 16),

        // Pending Clock Badge Orb
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: _KycStatusTokens.successOrbGradient,
            border: Border.all(
              color: _KycStatusTokens.goldPrimary,
              width: 1.5,
            ),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: Color(0x59CCA243),
                blurRadius: 30,
              ),
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.hourglass_top_rounded,
              size: 34,
              color: _KycStatusTokens.goldBright,
            ),
          ),
        ),

        const SizedBox(height: 20),

        Text(
          'KYC Under Verification',
          style: GoogleFonts.cormorantGaramond(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: _KycStatusTokens.goldLight,
            letterSpacing: 0.5,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 8),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0x26CCA243),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _KycStatusTokens.goldMuted,
              width: 1,
            ),
          ),
          child: Text(
            'Ref: #$refCode',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: _KycStatusTokens.goldBright,
              letterSpacing: 0.5,
            ),
          ),
        ),

        const SizedBox(height: 16),

        Text(
          'Your identity documents ($masked) have been submitted and are undergoing statutory review. Verification is typically completed within 2 to 4 business hours.',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13.5,
            height: 1.6,
            color: _KycStatusTokens.textMuted,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 24),

        KittyPrimaryButton(
          label: 'Return to Home',
          icon: const Icon(Icons.home_outlined, size: 16),
          onPressed: onReturnHome,
        ),

        const SizedBox(height: 10),
      ],
    );
  }
}

/// KYC Verified & Approved state view.
class KycApprovedView extends StatelessWidget {
  const KycApprovedView({
    super.key,
    required this.result,
    required this.onProceed,
  });

  final KycResultEntity? result;
  final VoidCallback onProceed;

  @override
  Widget build(BuildContext context) {
    final String refCode = result?.referenceId ?? 'KYC-VERIFIED';
    final String masked = result?.documentNumberMasked ?? 'XXXX XXXX 1234';

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const SizedBox(height: 16),

        // Shield Check Orb
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: _KycStatusTokens.successOrbGradient,
            border: Border.all(
              color: _KycStatusTokens.goldPrimary,
              width: 1.5,
            ),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: Color(0x59CCA243),
                blurRadius: 30,
              ),
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.verified_user_rounded,
              size: 34,
              color: _KycStatusTokens.goldBright,
            ),
          ),
        ),

        const SizedBox(height: 20),

        Text(
          'KYC Verified & Approved',
          style: GoogleFonts.cormorantGaramond(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: _KycStatusTokens.goldLight,
            letterSpacing: 0.5,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 8),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0x26CCA243),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _KycStatusTokens.goldMuted,
              width: 1,
            ),
          ),
          child: Text(
            'Ref: #$refCode • $masked',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: _KycStatusTokens.goldBright,
              letterSpacing: 0.5,
            ),
          ),
        ),

        const SizedBox(height: 16),

        Text(
          'Your account is fully compliant with statutory gold investment guidelines. You can enroll in schemes and manage your vault without restrictions.',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13.5,
            height: 1.6,
            color: _KycStatusTokens.textMuted,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 24),

        KittyPrimaryButton(
          label: 'Enter Kitty Dashboard',
          icon: const Icon(Icons.arrow_forward_rounded, size: 16),
          onPressed: onProceed,
        ),

        const SizedBox(height: 10),
      ],
    );
  }
}

/// KYC Rejected view with reason display and retry action.
class KycRejectedView extends StatelessWidget {
  const KycRejectedView({
    super.key,
    required this.result,
    required this.onRetry,
  });

  final KycResultEntity? result;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final String? reason = result?.rejectionReason;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const SizedBox(height: 16),

        // Rejected Alert Orb
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: _KycStatusTokens.rejectedOrbGradient,
            border: Border.all(
              color: _KycStatusTokens.danger,
              width: 1.5,
            ),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: Color(0x4DEF4444),
                blurRadius: 30,
              ),
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.warning_amber_rounded,
              size: 34,
              color: _KycStatusTokens.danger,
            ),
          ),
        ),

        const SizedBox(height: 20),

        Text(
          'KYC Verification Rejected',
          style: GoogleFonts.cormorantGaramond(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: _KycStatusTokens.danger,
            letterSpacing: 0.5,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 12),

        if (reason != null && reason.isNotEmpty) ...<Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: _KycStatusTokens.dangerBg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: _KycStatusTokens.dangerBorder,
                width: 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Icon(
                  Icons.info_outline_rounded,
                  size: 16,
                  color: _KycStatusTokens.danger,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    reason,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500,
                      color: _KycStatusTokens.danger,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],

        Text(
          'Your document submission could not be verified by compliance. Please ensure the document is clear, valid, and re-submit your verification.',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13.5,
            height: 1.6,
            color: _KycStatusTokens.textMuted,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 24),

        KittyPrimaryButton(
          label: 'Retry KYC Submission',
          icon: const Icon(Icons.refresh_rounded, size: 16),
          onPressed: onRetry,
        ),

        const SizedBox(height: 10),
      ],
    );
  }
}
