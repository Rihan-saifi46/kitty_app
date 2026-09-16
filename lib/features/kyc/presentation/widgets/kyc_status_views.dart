import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../shared/widgets/buttons/kitty_primary_button.dart';
import '../../domain/entities/kyc_entity.dart';

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
        const SizedBox(height: AppSpacing.space16),

        // Success Badge Orb
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.statusSuccessText.withAlpha(30),
            border: Border.all(
              color: AppColors.statusSuccessText.withAlpha(120),
              width: 1.5,
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: AppColors.statusSuccessText.withAlpha(60),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.check_rounded,
              size: 38,
              color: AppColors.statusSuccessText,
            ),
          ),
        ),

        const SizedBox(height: AppSpacing.space20),

        Text(
          'KYC Submitted Successfully',
          style: GoogleFonts.cormorantGaramond(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimaryLight,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: AppSpacing.space8),

        // Reference Chip
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.goldPrimary.withAlpha(25),
            borderRadius: AppRadius.border20,
            border: Border.all(
              color: AppColors.goldPrimary.withAlpha(120),
              width: 1,
            ),
          ),
          child: Text(
            'Ref: #$refCode',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: AppColors.goldPrimary,
              letterSpacing: 0.5,
            ),
          ),
        ),

        const SizedBox(height: AppSpacing.space16),

        Text(
          'Your statutory identity documents have been securely encrypted and submitted. Your Royal Kitty Vault scheme enrollment is authorized.',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            height: 1.5,
            color: AppColors.emeraldTextSubtle,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: AppSpacing.space28),

        KittyPrimaryButton(
          label: 'Enter Kitty Vault Dashboard',
          icon: const Icon(Icons.arrow_forward_rounded, size: 18),
          onPressed: onProceed,
        ),

        const SizedBox(height: AppSpacing.space16),
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
        const SizedBox(height: AppSpacing.space16),

        // Pending Clock Badge Orb
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.goldPrimary.withAlpha(25),
            border: Border.all(
              color: AppColors.goldPrimary.withAlpha(120),
              width: 1.5,
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: AppColors.goldPrimary.withAlpha(50),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.hourglass_top_rounded,
              size: 36,
              color: AppColors.goldPrimary,
            ),
          ),
        ),

        const SizedBox(height: AppSpacing.space20),

        Text(
          'KYC Under Verification',
          style: GoogleFonts.cormorantGaramond(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimaryLight,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: AppSpacing.space8),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.goldPrimary.withAlpha(25),
            borderRadius: AppRadius.border20,
            border: Border.all(
              color: AppColors.goldPrimary.withAlpha(120),
              width: 1,
            ),
          ),
          child: Text(
            'Ref: #$refCode',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: AppColors.goldPrimary,
              letterSpacing: 0.5,
            ),
          ),
        ),

        const SizedBox(height: AppSpacing.space16),

        Text(
          'Your identity documents ($masked) have been submitted and are undergoing statutory review. Verification is typically completed within 2 to 4 business hours.',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            height: 1.5,
            color: AppColors.emeraldTextSubtle,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: AppSpacing.space28),

        KittyPrimaryButton(
          label: 'Return to Home',
          icon: const Icon(Icons.home_outlined, size: 18),
          onPressed: onReturnHome,
        ),

        const SizedBox(height: AppSpacing.space16),
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
        const SizedBox(height: AppSpacing.space16),

        // Shield Check Orb
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.statusSuccessText.withAlpha(30),
            border: Border.all(
              color: AppColors.statusSuccessText.withAlpha(120),
              width: 1.5,
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: AppColors.statusSuccessText.withAlpha(60),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.verified_user_rounded,
              size: 38,
              color: AppColors.statusSuccessText,
            ),
          ),
        ),

        const SizedBox(height: AppSpacing.space20),

        Text(
          'KYC Verified & Approved',
          style: GoogleFonts.cormorantGaramond(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimaryLight,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: AppSpacing.space8),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.statusSuccessText.withAlpha(25),
            borderRadius: AppRadius.border20,
            border: Border.all(
              color: AppColors.statusSuccessText.withAlpha(120),
              width: 1,
            ),
          ),
          child: Text(
            'Ref: #$refCode • $masked',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: AppColors.statusSuccessText,
              letterSpacing: 0.5,
            ),
          ),
        ),

        const SizedBox(height: AppSpacing.space16),

        Text(
          'Your account is fully compliant with statutory gold investment guidelines. You can enroll in schemes and manage your vault without restrictions.',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            height: 1.5,
            color: AppColors.emeraldTextSubtle,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: AppSpacing.space28),

        KittyPrimaryButton(
          label: 'Enter Kitty Dashboard',
          icon: const Icon(Icons.arrow_forward_rounded, size: 18),
          onPressed: onProceed,
        ),

        const SizedBox(height: AppSpacing.space16),
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
        const SizedBox(height: AppSpacing.space16),

        // Rejected Alert Orb
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.statusErrorText.withAlpha(30),
            border: Border.all(
              color: AppColors.statusErrorText.withAlpha(120),
              width: 1.5,
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: AppColors.statusErrorText.withAlpha(60),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.warning_amber_rounded,
              size: 38,
              color: AppColors.statusErrorText,
            ),
          ),
        ),

        const SizedBox(height: AppSpacing.space20),

        Text(
          'KYC Verification Rejected',
          style: GoogleFonts.cormorantGaramond(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppColors.statusErrorText,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: AppSpacing.space12),

        if (reason != null && reason.isNotEmpty) ...<Widget>[
          Container(
            padding: AppSpacing.all12,
            decoration: BoxDecoration(
              color: AppColors.statusErrorText.withAlpha(20),
              borderRadius: AppRadius.border10,
              border: Border.all(
                color: AppColors.statusErrorText.withAlpha(80),
                width: 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Icon(
                  Icons.info_outline,
                  size: 16,
                  color: AppColors.statusErrorText,
                ),
                const SizedBox(width: AppSpacing.space8),
                Expanded(
                  child: Text(
                    reason,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.statusErrorText,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.space16),
        ],

        Text(
          'Your document submission could not be verified by compliance. Please ensure the document is clear, valid, and re-submit your verification.',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            height: 1.5,
            color: AppColors.emeraldTextSubtle,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: AppSpacing.space28),

        KittyPrimaryButton(
          label: 'Retry KYC Submission',
          icon: const Icon(Icons.refresh_rounded, size: 18),
          onPressed: onRetry,
        ),

        const SizedBox(height: AppSpacing.space16),
      ],
    );
  }
}
