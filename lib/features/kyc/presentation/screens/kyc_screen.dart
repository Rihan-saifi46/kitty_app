import 'dart:io' as io;
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/enums/app_enums.dart';
import '../../../../core/routing/route_paths.dart';
import '../../../../shared/widgets/buttons/kitty_primary_button.dart';
import '../../../../shared/widgets/feedback/kitty_error_state.dart';
import '../../../../shared/widgets/feedback/kitty_loading_indicator.dart';
import '../../../auth/presentation/widgets/jewelry_constellation_painter.dart';
import '../providers/kyc_controller.dart';
import '../providers/kyc_state.dart';
import '../widgets/kyc_consent_checkbox.dart';
import '../widgets/kyc_doc_number_field.dart';
import '../widgets/kyc_doc_tabs.dart';
import '../widgets/kyc_status_views.dart';
import '../widgets/kyc_upload_card.dart';

/// Statutory KYC Identity Verification screen matching Login Screen visual design:
/// - 3D rotating jewelry constellation (diamonds, solitaire rings, bangles with starburst sparkles)
/// - Damask wallpaper texture overlay & ambient radial glow orb
/// - Centered glassmorphic card container with 16px backdrop blur, top specular highlight, and double shadow
/// - Single authoritative Swastik brand header with gold gradient shader mask
/// - Exact responsive alignment matching `login_screen.dart`.
class KycScreen extends ConsumerStatefulWidget {
  const KycScreen({super.key});

  @override
  ConsumerState<KycScreen> createState() => _KycScreenState();
}

class _KycScreenState extends ConsumerState<KycScreen>
    with TickerProviderStateMixin {
  late final TextEditingController _docNumberController;

  // Animation Controllers matching Login Screen
  late final AnimationController _cardEntranceController;
  late final Animation<double> _cardScaleAnimation;
  late final Animation<Offset> _cardSlideAnimation;
  late final Animation<double> _cardFadeAnimation;

  late final AnimationController _bgConstellationController;

  static const Color _bgPrimary = Color(0xFF05241C);
  static const Color _cardBg = Color(0xD9062018); // rgba(6, 32, 24, 0.85) luxury emerald glass
  static const Color _goldBorder = Color(0x47CCA243); // rgba(204, 162, 65, 0.28)

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

  bool get _isInTest =>
      !kIsWeb && io.Platform.environment.containsKey('FLUTTER_TEST');

  @override
  void initState() {
    super.initState();
    _docNumberController = TextEditingController();

    // 1. Card Entrance Animation (Fast luxury ease ~260ms)
    _cardEntranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );

    final CurvedAnimation cardCurved = CurvedAnimation(
      parent: _cardEntranceController,
      curve: const Cubic(0.16, 1.0, 0.3, 1.0),
    );

    _cardFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(cardCurved);
    _cardScaleAnimation = Tween<double>(begin: 0.97, end: 1.0).animate(cardCurved);
    _cardSlideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.04),
      end: Offset.zero,
    ).animate(cardCurved);

    _cardEntranceController.forward();

    // 2. 3D Background Jewelry Constellation (continuous 24s loop matching Login)
    _bgConstellationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 24),
    );
    if (!_isInTest) {
      _bgConstellationController.repeat();
    } else {
      _bgConstellationController.value = 0.5;
    }

    // Check existing statutory KYC status on appearance
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(kycControllerProvider.notifier).loadKycStatus();
    });
  }

  @override
  void dispose() {
    _cardEntranceController.dispose();
    _bgConstellationController.dispose();
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
    final Size screenSize = MediaQuery.sizeOf(context);
    final double screenWidth = screenSize.width;
    final bool isTiny = screenWidth <= 340;
    final bool isSmall = screenWidth <= 480;

    final EdgeInsets cardPadding = isTiny
        ? const EdgeInsets.symmetric(horizontal: 14.0, vertical: 24.0)
        : isSmall
            ? const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0)
            : const EdgeInsets.symmetric(horizontal: 36.0, vertical: 40.0);

    final double cardRadius = isSmall ? 20.0 : 26.0;
    final double orbSize = math.min(600.0, screenWidth * 0.90);

    // Keep text controller in sync if documentNumber was reset
    if (state.documentNumber.isEmpty && _docNumberController.text.isNotEmpty) {
      _docNumberController.clear();
    }

    return Scaffold(
      backgroundColor: _bgPrimary,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          // 1. Subtle Damask Wallpaper Pattern Overlay (.wallpaper-overlay)
          Positioned.fill(
            child: Opacity(
              opacity: 0.08,
              child: Image.asset(
                'assets/patterns/damask-pattern.jpg',
                fit: BoxFit.cover,
                repeat: ImageRepeat.repeat,
                color: const Color(0xFFCCA243),
                colorBlendMode: BlendMode.screen,
                errorBuilder: (BuildContext ctx, Object err, StackTrace? st) {
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),

          // 2. 3D Faceted Jewelry Constellation Canvas (#diamond-bg-canvas)
          // Renders rotating brilliant diamonds, solitaire rings, and gold bangles with sparkles
          Positioned.fill(
            child: RepaintBoundary(
              child: AnimatedBuilder(
                animation: _bgConstellationController,
                builder: (BuildContext context, Widget? child) {
                  return CustomPaint(
                    painter: JewelryConstellationPainter(
                      progress: _bgConstellationController.value,
                      opacity: 0.90,
                    ),
                  );
                },
              ),
            ),
          ),

          // 3. Ambient Emerald & Gold Radial Glow Orb (.ambient-glow-orb)
          Center(
            child: RepaintBoundary(
              child: ImageFiltered(
                imageFilter: ui.ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                child: Container(
                  width: orbSize,
                  height: orbSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: <Color>[
                        const Color(0xFFCCA243).withValues(alpha: 0.12),
                        const Color(0xFF0D4A3A).withValues(alpha: 0.18),
                        Colors.transparent,
                      ],
                      stops: const <double>[0.0, 0.45, 0.70],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // 4. Foreground Content with Floating Back Button and Centered Glass Card
          SafeArea(
            child: Stack(
              children: <Widget>[
                // Floating Luxury Back Button in top-left
                Positioned(
                  top: 8,
                  left: 12,
                  child: Tooltip(
                    message: 'Back',
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _handleBack,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0x33000000),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0x47CCA243),
                              width: 1,
                            ),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              size: 16,
                              color: Color(0xFFF4E2AA),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Centered Glassmorphic Card Container matching Login Screen
                Center(
                  child: RepaintBoundary(
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                        horizontal: isSmall ? 12.0 : 16.0,
                        vertical: isSmall ? 16.0 : 24.0,
                      ),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 440),
                        child: FadeTransition(
                          opacity: _cardFadeAnimation,
                          child: SlideTransition(
                            position: _cardSlideAnimation,
                            child: ScaleTransition(
                              scale: _cardScaleAnimation,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(cardRadius),
                                child: BackdropFilter(
                                  filter: ui.ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: _cardBg,
                                      borderRadius: BorderRadius.circular(cardRadius),
                                      border: Border.all(
                                        color: _goldBorder,
                                        width: 1.0,
                                      ),
                                      boxShadow: const <BoxShadow>[
                                        BoxShadow(
                                          color: Color(0xA6000000), // rgba(0,0,0,0.65)
                                          blurRadius: 60,
                                          spreadRadius: -12,
                                          offset: Offset(0, 24),
                                        ),
                                        BoxShadow(
                                          color: Color(0x14CCA243), // rgba(204, 162, 65, 0.08)
                                          blurRadius: 35,
                                          offset: Offset(0, 0),
                                        ),
                                      ],
                                    ),
                                    child: Stack(
                                      children: <Widget>[
                                        // Top Specular Hairline Highlight (matching Login card)
                                        Positioned(
                                          top: 0,
                                          left: 0,
                                          right: 0,
                                          height: 1.2,
                                          child: Container(
                                            decoration: const BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: <Color>[
                                                  Colors.transparent,
                                                  Color(0x33FFFFFF),
                                                  Color(0x55F4E2AA),
                                                  Color(0x33FFFFFF),
                                                  Colors.transparent,
                                                ],
                                                stops: <double>[0.0, 0.2, 0.5, 0.8, 1.0],
                                              ),
                                            ),
                                          ),
                                        ),

                                        // Card Inner Content
                                        Padding(
                                          padding: cardPadding,
                                          child: _buildCardContent(state, controller, isSmall),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
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

  Widget _buildCardContent(KycState state, KycController controller, bool isSmall) {
    if (state.status == KycFormStatus.loadingStatus) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 36),
          child: KittyLoadingIndicator(
            message: 'Verifying Compliance Status...',
          ),
        ),
      );
    }

    if (state.status == KycFormStatus.error && state.kycResult == null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: KittyErrorState(
          message: state.errorMessage ?? 'Unable to connect to verification services.',
          onRetry: () => controller.loadKycStatus(),
          isDarkSurface: true,
        ),
      );
    }

    // Success / Approved State
    if (state.status == KycFormStatus.verified) {
      return KycApprovedView(
        result: state.kycResult,
        onProceed: () => context.go(RoutePaths.home),
      );
    }

    // Pending State (under review)
    if (state.status == KycFormStatus.pending) {
      return KycPendingView(
        result: state.kycResult,
        onReturnHome: () => context.go(RoutePaths.home),
      );
    }

    // Rejected State
    if (state.status == KycFormStatus.rejected) {
      return KycRejectedView(
        result: state.kycResult,
        onRetry: () => controller.retry(),
      );
    }

    // Default Form View (notSubmitted, submitting)
    return _buildFormView(state, controller, isSmall);
  }

  Widget _buildFormView(KycState state, KycController controller, bool isSmall) {
    final bool isSubmitting = state.status == KycFormStatus.submitting;
    final double logoWidth = isSmall ? 140 : 156;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // Brand Header matching Login Screen
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // Swastik Logo with Drop Shadow (.brand-logo-img)
              Container(
                margin: const EdgeInsets.only(bottom: 14),
                child: SvgPicture.asset(
                  'assets/icons/swastiklogo.svg',
                  width: logoWidth,
                  semanticsLabel: 'Swastik Jewellers',
                  fit: BoxFit.contain,
                  placeholderBuilder: (BuildContext context) {
                    return const Icon(
                      Icons.diamond_outlined,
                      size: 44,
                      color: Color(0xFFCCA243),
                    );
                  },
                ),
              ),

              // Card Title: "KYC Document Verification" with gold gradient
              ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (Rect bounds) =>
                    _goldGradient.createShader(bounds),
                child: Text(
                  'KYC Document Verification',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 21.0,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.63,
                    height: 1.25,
                    color: Colors.white,
                  ),
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
                    style: GoogleFonts.montserrat(
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
    );
  }
}
