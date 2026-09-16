import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/enums/app_enums.dart';
import '../../../../core/routing/route_paths.dart';
import '../../../../shared/widgets/buttons/kitty_icon_button.dart';
import '../../../../shared/widgets/buttons/kitty_primary_button.dart';
import '../../../../shared/widgets/feedback/kitty_error_state.dart';
import '../../../../shared/widgets/feedback/kitty_loading_indicator.dart';
import '../../../splash/presentation/widgets/diamond_3d_painter.dart';
import '../providers/kyc_controller.dart';
import '../providers/kyc_state.dart';
import '../widgets/kyc_consent_checkbox.dart';
import '../widgets/kyc_doc_number_field.dart';
import '../widgets/kyc_doc_tabs.dart';
import '../widgets/kyc_status_views.dart';
import '../widgets/kyc_upload_card.dart';

/// Statutory KYC Identity Verification screen matching `kyc.html` / `kyc.css`.
class KycScreen extends ConsumerStatefulWidget {
  const KycScreen({super.key});

  @override
  ConsumerState<KycScreen> createState() => _KycScreenState();
}

class _KycScreenState extends ConsumerState<KycScreen> {
  late final TextEditingController _docNumberController;

  @override
  void initState() {
    super.initState();
    _docNumberController = TextEditingController();

    // Check existing statutory KYC status on appearance
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(kycControllerProvider.notifier).loadKycStatus();
    });
  }

  @override
  void dispose() {
    _docNumberController.dispose();
    super.dispose();
  }

  void _handleBack() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(RoutePaths.home);
    }
  }

  void _handleDocTypeChanged(DocTypeEnum newType) {
    _docNumberController.clear();
    ref.read(kycControllerProvider.notifier).selectDocType(newType);
  }

  Future<void> _handleSubmit() async {
    final KycController controller = ref.read(kycControllerProvider.notifier);
    await controller.submitKyc();
  }

  @override
  Widget build(BuildContext context) {
    final KycState state = ref.watch(kycControllerProvider);
    final KycController controller = ref.read(kycControllerProvider.notifier);

    // Keep text controller in sync if documentNumber was reset
    if (state.documentNumber.isEmpty && _docNumberController.text.isNotEmpty) {
      _docNumberController.clear();
    }

    return Scaffold(
      backgroundColor: AppColors.deepEmeraldBase,
      body: Stack(
        children: <Widget>[
          // 1. 3D Diamond Jewelry Constellation Canvas
          Positioned.fill(
            child: CustomPaint(
              painter: Diamond3DPainter(
                rotationY: 0.45,
                scaleFactor: 0.8,
                opacity: 0.3,
              ),
            ),
          ),

          // 2. Subtle Damask Wallpaper Pattern Overlay
          Positioned.fill(
            child: Opacity(
              opacity: 0.05,
              child: Image.asset(
                'assets/patterns/emerald_damask_pattern.png',
                repeat: ImageRepeat.repeat,
              ),
            ),
          ),

          // 3. Ambient Emerald & Gold Radial Glow
          Positioned(
            top: -100,
            left: MediaQuery.of(context).size.width * 0.1,
            right: MediaQuery.of(context).size.width * 0.1,
            height: 360,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: <Color>[
                    AppColors.goldPrimary.withAlpha(35),
                    AppColors.deepEmeraldBase.withAlpha(20),
                    Colors.transparent,
                  ],
                  stops: const <double>[0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),

          // 4. Main Scrollable Content Area
          SafeArea(
            child: Column(
              children: <Widget>[
                // Top App Bar
                _buildAppBar(context),

                // Dynamic Body Content
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.space20,
                      vertical: AppSpacing.space12,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 480),
                        child: _buildCardContent(state, controller),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.space16,
        vertical: AppSpacing.space8,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          KittyIconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: _handleBack,
            tooltip: 'Back',
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SvgPicture.asset(
                'assets/icons/swastiklogo.svg',
                width: 22,
                height: 22,
                colorFilter: const ColorFilter.mode(
                  AppColors.goldPrimary,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: AppSpacing.space8),
              Text(
                'SWASTIK JEWEL',
                style: GoogleFonts.cormorantGaramond(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2.0,
                  color: AppColors.goldPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(width: 40), // Balance placeholder
        ],
      ),
    );
  }

  Widget _buildCardContent(KycState state, KycController controller) {
    if (state.status == KycFormStatus.loadingStatus) {
      return Container(
        padding: AppSpacing.all24,
        decoration: BoxDecoration(
          color: const Color(0xD8041913),
          borderRadius: AppRadius.border18,
          border: Border.all(color: AppColors.goldBorder, width: 1.2),
        ),
        child: const Center(
          child: KittyLoadingIndicator(
            message: 'Verifying Compliance Status...',
          ),
        ),
      );
    }

    if (state.status == KycFormStatus.error && state.kycResult == null) {
      return Container(
        padding: AppSpacing.all24,
        decoration: BoxDecoration(
          color: const Color(0xD8041913),
          borderRadius: AppRadius.border18,
          border: Border.all(color: AppColors.goldBorder, width: 1.2),
        ),
        child: KittyErrorState(
          message: state.errorMessage ?? 'Unable to connect to verification services.',
          onRetry: () => controller.loadKycStatus(),
          isDarkSurface: true,
        ),
      );
    }

    // Success State
    if (state.status == KycFormStatus.verified) {
      return _buildGlassContainer(
        child: KycApprovedView(
          result: state.kycResult,
          onProceed: () => context.go(RoutePaths.home),
        ),
      );
    }

    // Pending State (under review)
    if (state.status == KycFormStatus.pending) {
      return _buildGlassContainer(
        child: KycPendingView(
          result: state.kycResult,
          onReturnHome: () => context.go(RoutePaths.home),
        ),
      );
    }

    // Rejected State
    if (state.status == KycFormStatus.rejected) {
      return _buildGlassContainer(
        child: KycRejectedView(
          result: state.kycResult,
          onRetry: () => controller.retry(),
        ),
      );
    }

    // Default Form View (notSubmitted, submitting)
    return _buildFormView(state, controller);
  }

  Widget _buildGlassContainer({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.space20,
        vertical: AppSpacing.space24,
      ),
      decoration: BoxDecoration(
        color: const Color(0xD8041913),
        borderRadius: AppRadius.border18,
        border: Border.all(
          color: AppColors.goldBorder,
          width: 1.2,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withAlpha(160),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildFormView(KycState state, KycController controller) {
    final bool isSubmitting = state.status == KycFormStatus.submitting;

    return _buildGlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // Header
          Center(
            child: Column(
              children: <Widget>[
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.goldPrimary.withAlpha(25),
                    border: Border.all(
                      color: AppColors.goldPrimary.withAlpha(100),
                      width: 1.2,
                    ),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/icons/swastiklogo.svg',
                      width: 26,
                      height: 26,
                      colorFilter: const ColorFilter.mode(
                        AppColors.goldPrimary,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.space12),
                Text(
                  'KYC Document Verification',
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimaryLight,
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.space4),
                Text(
                  'Statutory Identity Authentication',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.emeraldTextSubtle,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.space24),

          // 1. Document Selector Tabs (Aadhaar / PAN)
          KycDocTabs(
            selectedDocType: state.selectedDocType,
            onDocTypeChanged: _handleDocTypeChanged,
            enabled: !isSubmitting,
          ),

          const SizedBox(height: AppSpacing.space16),

          // 2. Document Number Input
          KycDocNumberField(
            docType: state.selectedDocType,
            controller: _docNumberController,
            onChanged: (String val) => controller.updateDocNumber(val),
            isValid: state.isDocNumberValid,
            errorText: state.docNumberError,
            enabled: !isSubmitting,
          ),

          const SizedBox(height: AppSpacing.space16),

          // 3. Document Upload / Camera / Gallery Section
          KycUploadCard(
            selectedFile: state.selectedFile,
            onTakePhoto: () => controller.pickFileFromCamera(),
            onChooseGallery: () => controller.pickFileFromGallery(),
            onRemoveFile: () => controller.removeFile(),
            enabled: !isSubmitting,
          ),

          const SizedBox(height: AppSpacing.space16),

          // 4. Mandatory Statutory Legal Consent Checkbox
          KycConsentCheckbox(
            isChecked: state.consentAccepted,
            onChanged: (bool val) => controller.toggleConsent(val),
            enabled: !isSubmitting,
          ),

          // Error Message Banner (if any)
          if (state.errorMessage != null && state.errorMessage!.isNotEmpty) ...<Widget>[
            const SizedBox(height: AppSpacing.space14),
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
                children: <Widget>[
                  const Icon(
                    Icons.error_outline,
                    size: 16,
                    color: AppColors.statusErrorText,
                  ),
                  const SizedBox(width: AppSpacing.space8),
                  Expanded(
                    child: Text(
                      state.errorMessage!,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.statusErrorText,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: AppSpacing.space24),

          // 5. Submit KYC Button
          KittyPrimaryButton(
            label: isSubmitting
                ? 'Verifying & Encrypting...'
                : 'Submit KYC Documents',
            icon: const Icon(Icons.verified_user_outlined, size: 18),
            isLoading: isSubmitting,
            onPressed: state.canSubmit ? _handleSubmit : null,
          ),

          const SizedBox(height: AppSpacing.space8),
        ],
      ),
    );
  }
}
