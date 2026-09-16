import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/routing/route_paths.dart';
import '../../../../shared/widgets/inputs/kitty_phone_input_field.dart';
import '../../../../shared/widgets/sheets/kitty_bottom_sheet.dart';
import '../providers/auth_controller.dart';

/// Phone Number Entry Screen (View 1 of Auth Flow).
///
/// Features:
/// - Country code selector modal (+91 🇮🇳, +971 🇦🇪, etc.)
/// - Phase 3 [KittyPhoneInputField] with real-time validation
/// - Continuous button loading state and duplicate submit prevention
/// - Dispatches OTP request through [AuthController]
class PhoneScreen extends ConsumerStatefulWidget {
  const PhoneScreen({super.key});

  @override
  ConsumerState<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends ConsumerState<PhoneScreen> {
  late final TextEditingController _phoneController;

  static const List<Map<String, String>> _countryOptions = <Map<String, String>>[
    <String, String>{'code': '+91', 'flag': '🇮🇳', 'name': 'India (+91)'},
    <String, String>{'code': '+971', 'flag': '🇦🇪', 'name': 'UAE (+971)'},
    <String, String>{'code': '+44', 'flag': '🇬🇧', 'name': 'United Kingdom (+44)'},
    <String, String>{'code': '+1', 'flag': '🇺🇸', 'name': 'USA / Canada (+1)'},
    <String, String>{'code': '+65', 'flag': '🇸🇬', 'name': 'Singapore (+65)'},
    <String, String>{'code': '+61', 'flag': '🇦🇺', 'name': 'Australia (+61)'},
  ];

  @override
  void initState() {
    super.initState();
    final AuthFlowState current = ref.read(authControllerProvider);
    _phoneController = TextEditingController(text: current.phone);
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _showCountryCodePicker(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext ctx) {
        return KittyBottomSheet(
          title: 'Select Country Code',
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _countryOptions.length,
            separatorBuilder: (BuildContext context, int index) => const Divider(
              color: AppColors.surfaceCardBorder,
              height: 1,
            ),
            itemBuilder: (BuildContext context, int index) {
              final Map<String, String> item = _countryOptions[index];
              final AuthFlowState state = ref.read(authControllerProvider);
              final bool isSelected = state.countryCode == item['code'];

              return ListTile(
                leading: Text(
                  item['flag'] ?? '',
                  style: const TextStyle(fontSize: 22),
                ),
                title: Text(
                  item['name'] ?? '',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? AppColors.goldPrimary : AppColors.textPrimaryLight,
                  ),
                ),
                trailing: isSelected
                    ? const Icon(
                        Icons.check_circle_rounded,
                        color: AppColors.goldPrimary,
                        size: 20,
                      )
                    : null,
                onTap: () {
                  ref.read(authControllerProvider.notifier).setCountry(
                        item['code']!,
                        item['flag']!,
                      );
                  Navigator.of(ctx).pop();
                },
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _handleSubmit() async {
    final AuthController controller = ref.read(authControllerProvider.notifier);
    controller.setPhone(_phoneController.text.trim());

    final bool success = await controller.sendOtp();
    if (success && mounted) {
      await context.push(RoutePaths.otp);
    }
  }

  @override
  Widget build(BuildContext context) {
    final AuthFlowState authState = ref.watch(authControllerProvider);
    final bool isPhoneValid = _phoneController.text.replaceAll(RegExp(r'\D'), '').length == 10;
    final bool canSubmit = isPhoneValid && !authState.isSubmitting;

    return Scaffold(
      backgroundColor: AppColors.deepEmeraldBase, // Exact: #05241C
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          // Subtle Damask Wallpaper Pattern
          Opacity(
            opacity: 0.08,
            child: Image.asset(
              'assets/patterns/damask-pattern.jpg',
              fit: BoxFit.cover,
              repeat: ImageRepeat.repeat,
              color: AppColors.goldPrimary,
              colorBlendMode: BlendMode.screen,
              errorBuilder: (BuildContext ctx, Object error, StackTrace? st) {
                return const SizedBox.shrink();
              },
            ),
          ),

          // Ambient Radial Glow
          Center(
            child: Container(
              width: 360,
              height: 360,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: <Color>[
                    AppColors.goldPrimary.withValues(alpha: 0.12),
                    const Color(0xFF0D4A3A).withValues(alpha: 0.16),
                    Colors.transparent,
                  ],
                  stops: const <double>[0.0, 0.45, 0.70],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.space20,
                  vertical: AppSpacing.space20,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xD8041913),
                      borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                      border: Border.all(
                        color: AppColors.goldBorder,
                        width: 1.2,
                      ),
                      boxShadow: const <BoxShadow>[
                        BoxShadow(
                          color: Color(0x73000000),
                          blurRadius: 36,
                          offset: Offset(0, 16),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.space24,
                      vertical: AppSpacing.space28,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        // Back Navigation Bar
                        Align(
                          alignment: Alignment.centerLeft,
                          child: InkWell(
                            onTap: () {
                              if (context.canPop()) {
                                context.pop();
                              } else {
                                context.go(RoutePaths.login);
                              }
                            },
                            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.space4,
                                vertical: AppSpacing.space4,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  const Icon(
                                    Icons.arrow_back_rounded,
                                    size: 17,
                                    color: AppColors.goldPrimary,
                                  ),
                                  const SizedBox(width: AppSpacing.space6),
                                  Text(
                                    'Back',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.goldPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.space20),

                        // Heading Group
                        Text(
                          'Enter your mobile number',
                          style: GoogleFonts.cormorantGaramond(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimaryLight,
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.space6),
                        Text(
                          "We'll send an OTP to verify your account and secure your bullion vault.",
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: AppColors.emeraldTextSubtle,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.space28),

                        // Reusable Phase 3 Phone Input Field
                        KittyPhoneInputField(
                          controller: _phoneController,
                          countryCode: authState.countryCode,
                          countryFlag: authState.countryFlag,
                          errorText: authState.phoneError,
                          autofocus: true,
                          isDarkSurface: true,
                          onCountryCodeTap: () => _showCountryCodePicker(context),
                          onChanged: (String value) {
                            setState(() {});
                            ref.read(authControllerProvider.notifier).setPhone(value);
                          },
                          onSubmitted: (String _) {
                            if (canSubmit) {
                              _handleSubmit();
                            }
                          },
                        ),

                        const SizedBox(height: AppSpacing.space24),

                        // Continue Button
                        Container(
                          height: AppDimensions.primaryButtonHeight,
                          decoration: BoxDecoration(
                            gradient: canSubmit
                                ? AppColors.goldPrimaryGradient
                                : const LinearGradient(
                                    colors: <Color>[Color(0xFF2A3D36), Color(0xFF20322C)],
                                  ),
                            borderRadius: AppRadius.border12,
                            boxShadow: canSubmit ? AppShadows.ctaGold : null,
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: canSubmit ? _handleSubmit : null,
                              borderRadius: AppRadius.border12,
                              child: Center(
                                child: authState.isSubmitting
                                    ? Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          const SizedBox(
                                            width: 18,
                                            height: 18,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2.2,
                                              valueColor: AlwaysStoppedAnimation<Color>(
                                                AppColors.deepEmeraldBase,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: AppSpacing.space10),
                                          Text(
                                            'Sending OTP...',
                                            style: GoogleFonts.plusJakartaSans(
                                              fontSize: 14.5,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.deepEmeraldBase,
                                            ),
                                          ),
                                        ],
                                      )
                                    : Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            'Continue',
                                            style: GoogleFonts.plusJakartaSans(
                                              fontSize: 14.5,
                                              fontWeight: FontWeight.w700,
                                              color: canSubmit
                                                  ? AppColors.deepEmeraldBase
                                                  : AppColors.textTertiary,
                                              letterSpacing: 0.3,
                                            ),
                                          ),
                                          const SizedBox(width: AppSpacing.space8),
                                          Icon(
                                            Icons.arrow_forward_rounded,
                                            size: 17,
                                            color: canSubmit
                                                ? AppColors.deepEmeraldBase
                                                : AppColors.textTertiary,
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: AppSpacing.space20),

                        // Helper note
                        Text(
                          'Standard SMS rates may apply • OTP valid for 5 minutes',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            color: AppColors.emeraldTextSubtle,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
