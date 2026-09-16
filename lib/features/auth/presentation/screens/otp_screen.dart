import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/routing/route_paths.dart';
import '../../../../shared/widgets/feedback/kitty_toast.dart';
import '../../../../shared/widgets/inputs/kitty_otp_input.dart';
import '../providers/auth_controller.dart';

/// 6-Digit Segmented OTP Verification Screen (View 2 of Auth Flow).
///
/// Features:
/// - 6-Digit input with auto-advance and clipboard paste via [KittyOtpInput]
/// - 300-Second Contract TTL + 30-Second Resend Countdown Timer
/// - Real-time error handling with shake animation
/// - Navigation to [AuthSuccessScreen] on successful verification
class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({super.key});

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final GlobalKey<KittyOtpInputState> _otpKey = GlobalKey<KittyOtpInputState>();
  String _currentOtp = '';

  Future<void> _handleVerify() async {
    if (_currentOtp.length != 6) return;

    final AuthController controller = ref.read(authControllerProvider.notifier);
    final bool success = await controller.verifyOtp(_currentOtp);

    if (success && mounted) {
      context.go(RoutePaths.authSuccess);
    }
  }

  Future<void> _handleResend() async {
    final AuthController controller = ref.read(authControllerProvider.notifier);
    final bool success = await controller.resendOtp();

    if (success && mounted) {
      _otpKey.currentState?.clear();
      setState(() {
        _currentOtp = '';
      });
      KittyToast.show(
        context,
        message: 'New OTP dispatched successfully.',
        type: KittyToastType.success,
      );
    } else if (mounted) {
      final String? err = ref.read(authControllerProvider).phoneError;
      if (err != null) {
        KittyToast.show(
          context,
          message: err,
          type: KittyToastType.error,
        );
      }
    }
  }

  String _formatTimer(int totalSeconds) {
    final int m = totalSeconds ~/ 60;
    final int s = totalSeconds % 60;
    final String mm = m < 10 ? '0$m' : '$m';
    final String ss = s < 10 ? '0$s' : '$s';
    return '$mm:$ss';
  }

  @override
  Widget build(BuildContext context) {
    final AuthFlowState authState = ref.watch(authControllerProvider);
    final bool hasError = authState.otpError != null && authState.otpError!.isNotEmpty;
    final bool canVerify = _currentOtp.length == 6 && !authState.isVerifying;

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
                                context.go(RoutePaths.phone);
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
                                    'Change Number',
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
                          'Verify your number',
                          style: GoogleFonts.cormorantGaramond(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimaryLight,
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.space6),
                        Row(
                          children: <Widget>[
                            Flexible(
                              child: RichText(
                                text: TextSpan(
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.emeraldTextSubtle,
                                  ),
                                  children: <TextSpan>[
                                    const TextSpan(text: 'Enter the OTP sent to '),
                                    TextSpan(
                                      text: authState.fullFormattedPhone.isNotEmpty
                                          ? authState.fullFormattedPhone
                                          : '+91 98765 43210',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.goldLight,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.edit_outlined,
                                size: 16,
                                color: AppColors.goldPrimary,
                              ),
                              onPressed: () {
                                if (context.canPop()) {
                                  context.pop();
                                } else {
                                  context.go(RoutePaths.phone);
                                }
                              },
                              tooltip: 'Change phone number',
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.space28),

                        // 6-Digit Segmented OTP Input
                        KittyOtpInput(
                          key: _otpKey,
                          length: 6,
                          hasError: hasError,
                          enabled: !authState.isVerifying,
                          autofocus: true,
                          isDarkSurface: true,
                          onChanged: (String val) {
                            setState(() {
                              _currentOtp = val;
                            });
                            if (hasError) {
                              ref.read(authControllerProvider.notifier).clearErrors();
                            }
                          },
                          onCompleted: (String val) {
                            setState(() {
                              _currentOtp = val;
                            });
                            _handleVerify();
                          },
                        ),

                        // Inline Error Feedback
                        if (hasError) ...<Widget>[
                          const SizedBox(height: AppSpacing.space10),
                          Row(
                            children: <Widget>[
                              const Icon(
                                Icons.error_outline_rounded,
                                size: 14,
                                color: AppColors.statusErrorText,
                              ),
                              const SizedBox(width: AppSpacing.space6),
                              Expanded(
                                child: Text(
                                  authState.otpError!,
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

                        const SizedBox(height: AppSpacing.space20),

                        // Resend OTP Bar & Countdown Timer
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            if (authState.resendCountdownSeconds > 0)
                              Row(
                                children: <Widget>[
                                  const Icon(
                                    Icons.timer_outlined,
                                    size: 14,
                                    color: AppColors.emeraldTextSubtle,
                                  ),
                                  const SizedBox(width: AppSpacing.space4),
                                  Text(
                                    'Resend OTP in ',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.emeraldTextSubtle,
                                    ),
                                  ),
                                  Text(
                                    _formatTimer(authState.resendCountdownSeconds),
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.goldLight,
                                    ),
                                  ),
                                ],
                              )
                            else
                              Text(
                                'Didn\'t receive code?',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.emeraldTextSubtle,
                                ),
                              ),
                            TextButton(
                              onPressed: authState.canResend ? _handleResend : null,
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                'Resend OTP',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                  color: authState.canResend
                                      ? AppColors.goldPrimary
                                      : AppColors.textTertiary,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: AppSpacing.space24),

                        // Verify & Continue Button
                        Container(
                          height: AppDimensions.primaryButtonHeight,
                          decoration: BoxDecoration(
                            gradient: canVerify
                                ? AppColors.goldPrimaryGradient
                                : const LinearGradient(
                                    colors: <Color>[Color(0xFF2A3D36), Color(0xFF20322C)],
                                  ),
                            borderRadius: AppRadius.border12,
                            boxShadow: canVerify ? AppShadows.ctaGold : null,
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: canVerify ? _handleVerify : null,
                              borderRadius: AppRadius.border12,
                              child: Center(
                                child: authState.isVerifying
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
                                            'Verifying...',
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
                                            'Verify & Continue',
                                            style: GoogleFonts.plusJakartaSans(
                                              fontSize: 14.5,
                                              fontWeight: FontWeight.w700,
                                              color: canVerify
                                                  ? AppColors.deepEmeraldBase
                                                  : AppColors.textTertiary,
                                              letterSpacing: 0.3,
                                            ),
                                          ),
                                          const SizedBox(width: AppSpacing.space8),
                                          Icon(
                                            Icons.check_circle_outline_rounded,
                                            size: 17,
                                            color: canVerify
                                                ? AppColors.deepEmeraldBase
                                                : AppColors.textTertiary,
                                          ),
                                        ],
                                      ),
                              ),
                            ),
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
