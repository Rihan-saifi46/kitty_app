import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

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

  static const Color _bgPrimary = Color(0xFF05241C);
  static const Color _cardBg = Color(0xC7062018); // rgba(6, 32, 24, 0.78)
  static const Color _goldBorder = Color(0x47CCA243); // rgba(204, 162, 65, 0.28)
  static const Color _goldPrimary = Color(0xFFCCA243);
  static const Color _goldLight = Color(0xFFF4E2AA);

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
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isSmall = screenWidth <= 480;

    // Keep text controller in sync if documentNumber was reset
    if (state.documentNumber.isEmpty && _docNumberController.text.isNotEmpty) {
      _docNumberController.clear();
    }

    return Scaffold(
      backgroundColor: _bgPrimary,
      body: Stack(
        children: <Widget>[
          // 1. Subtle Damask Wallpaper Pattern Overlay (.wallpaper-overlay)
          Positioned.fill(
            child: Opacity(
              opacity: 0.08,
              child: Image.asset(
                'assets/patterns/damask-pattern.jpg',
                repeat: ImageRepeat.repeat,
              ),
            ),
          ),

          // 2. 3D Diamond Jewelry Constellation Canvas (#diamond-bg-canvas)
          Positioned.fill(
            child: CustomPaint(
              painter: Diamond3DPainter(
                rotationY: 0.45,
                scaleFactor: 0.8,
                opacity: 0.28,
              ),
            ),
          ),

          // 3. Ambient Emerald & Gold Radial Glow Orb (.ambient-glow-orb)
          Center(
            child: Container(
              width: screenWidth * 0.92,
              height: screenWidth * 0.92,
              constraints: const BoxConstraints(maxWidth: 650, maxHeight: 650),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: <Color>[
                    Color(0x1FCCA243), // rgba(204, 162, 65, 0.12)
                    Color(0x2E0D4A3A), // rgba(13, 74, 58, 0.18)
                    Colors.transparent,
                  ],
                  stops: <double>[0.0, 0.45, 0.70],
                ),
              ),
            ),
          ),

          // 4. Main Scrollable Content Area (.kyc-viewport)
          SafeArea(
            child: Column(
              children: <Widget>[
                // Top App Bar
                _buildAppBar(context),

                // Dynamic Body Content
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: isSmall ? 12 : 16,
                      vertical: isSmall ? 8 : 16,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 480),
                        child: _buildCardContent(state, controller, isSmall),
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
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SvgPicture.asset(
                  'assets/icons/swastiklogo.svg',
                  width: 22,
                  height: 22,
                  colorFilter: const ColorFilter.mode(
                    _goldPrimary,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: AppSpacing.space8),
                Flexible(
                  child: Text(
                    'SWASTIK JEWEL',
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2.0,
                      color: _goldPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 40), // Balance placeholder
        ],
      ),
    );
  }

  Widget _buildCardContent(KycState state, KycController controller, bool isSmall) {
    if (state.status == KycFormStatus.loadingStatus) {
      return _buildGlassCard(
        isSmall: isSmall,
        child: const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: KittyLoadingIndicator(
              message: 'Verifying Compliance Status...',
            ),
          ),
        ),
      );
    }

    if (state.status == KycFormStatus.error && state.kycResult == null) {
      return _buildGlassCard(
        isSmall: isSmall,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: KittyErrorState(
            message: state.errorMessage ?? 'Unable to connect to verification services.',
            onRetry: () => controller.loadKycStatus(),
            isDarkSurface: true,
          ),
        ),
      );
    }

    // Success / Approved State
    if (state.status == KycFormStatus.verified) {
      return _buildGlassCard(
        isSmall: isSmall,
        child: KycApprovedView(
          result: state.kycResult,
          onProceed: () => context.go(RoutePaths.home),
        ),
      );
    }

    // Pending State (under review)
    if (state.status == KycFormStatus.pending) {
      return _buildGlassCard(
        isSmall: isSmall,
        child: KycPendingView(
          result: state.kycResult,
          onReturnHome: () => context.go(RoutePaths.home),
        ),
      );
    }

    // Rejected State
    if (state.status == KycFormStatus.rejected) {
      return _buildGlassCard(
        isSmall: isSmall,
        child: KycRejectedView(
          result: state.kycResult,
          onRetry: () => controller.retry(),
        ),
      );
    }

    // Default Form View (notSubmitted, submitting)
    return _buildFormView(state, controller, isSmall);
  }

  Widget _buildGlassCard({required Widget child, required bool isSmall}) {
    final double cardRadius = isSmall ? 20 : 26; // var(--radius-lg) vs var(--radius-xl)
    final EdgeInsets padding = isSmall
        ? const EdgeInsets.fromLTRB(18, 28, 18, 22)
        : const EdgeInsets.symmetric(horizontal: 32, vertical: 36);

    return ClipRRect(
      borderRadius: BorderRadius.circular(cardRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          width: double.infinity,
          padding: padding,
          decoration: BoxDecoration(
            color: _cardBg,
            borderRadius: BorderRadius.circular(cardRadius),
            border: Border.all(
              color: _goldBorder,
              width: 1,
            ),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: Color(0xA6000000), // rgba(0, 0, 0, 0.65)
                blurRadius: 60,
                offset: Offset(0, 24),
                spreadRadius: -12,
              ),
              BoxShadow(
                color: Color(0x14CCA243), // rgba(204, 162, 65, 0.08)
                blurRadius: 35,
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _buildFormView(KycState state, KycController controller, bool isSmall) {
    final bool isSubmitting = state.status == KycFormStatus.submitting;
    final double logoWidth = isSmall ? 150 : 172;
    final double titleFontSize = isSmall ? 21 : 25;

    return _buildGlassCard(
      isSmall: isSmall,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // Brand Header matching `kyc.html` <header class="card-brand-header">
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // Brand logo wrapper with swastiklogo.svg
                Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  child: SvgPicture.asset(
                    'assets/icons/swastiklogo.svg',
                    width: logoWidth,
                  ),
                ),

                // Card Title: "KYC Document Verification" with gold gradient
                ShaderMask(
                  blendMode: BlendMode.srcIn,
                  shaderCallback: (Rect bounds) =>
                      _goldGradient.createShader(bounds),
                  child: Text(
                    'KYC Document Verification',
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.03 * titleFontSize,
                      height: 1.25,
                      color: _goldLight,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // 1. Document Selector Tabs (Aadhaar / PAN)
          KycDocTabs(
            selectedDocType: state.selectedDocType,
            onDocTypeChanged: _handleDocTypeChanged,
            enabled: !isSubmitting,
          ),

          const SizedBox(height: 18),

          // 2. Document Number Input Field
          KycDocNumberField(
            docType: state.selectedDocType,
            controller: _docNumberController,
            onChanged: (String val) => controller.updateDocNumber(val),
            isValid: state.isDocNumberValid,
            errorText: state.docNumberError,
            enabled: !isSubmitting,
          ),

          const SizedBox(height: 20),

          // 3. Document Upload / Camera / Gallery Section
          KycUploadCard(
            selectedFile: state.selectedFile,
            onTakePhoto: () => controller.pickFileFromCamera(),
            onChooseGallery: () => controller.pickFileFromGallery(),
            onRemoveFile: () => controller.removeFile(),
            enabled: !isSubmitting,
          ),

          // 4. Mandatory Statutory Legal Consent Checkbox
          KycConsentCheckbox(
            isChecked: state.consentAccepted,
            onChanged: (bool val) => controller.toggleConsent(val),
            enabled: !isSubmitting,
          ),

          // Error Message Banner (if any)
          if (state.errorMessage != null && state.errorMessage!.isNotEmpty) ...<Widget>[
            Container(
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0x26EF4444),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: const Color(0x80EF4444),
                  width: 1,
                ),
              ),
              child: Row(
                children: <Widget>[
                  const Icon(
                    Icons.error_outline_rounded,
                    size: 16,
                    color: Color(0xFFEF4444),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      state.errorMessage!,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFFEF4444),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          // 5. Submit KYC Button (.btn-submit-kyc)
          KittyPrimaryButton(
            label: isSubmitting
                ? 'Verifying & Encrypting...'
                : 'Submit KYC Documents',
            icon: const Icon(Icons.shield_outlined, size: 18),
            isLoading: isSubmitting,
            isEnabled: state.canSubmit,
            onPressed: state.canSubmit ? _handleSubmit : null,
          ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
