import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/routing/route_paths.dart';
import '../../../../shared/widgets/feedback/kitty_toast.dart';
import '../providers/auth_controller.dart';

/// Login Entry Screen offering Google SSO and Mobile Phone authentication.
///
/// Faithfully reproduces `login.html` (View 0: Initial Login Options).
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final AuthFlowState authState = ref.watch(authControllerProvider);
    final AuthController controller = ref.read(authControllerProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.deepEmeraldBase, // Strict: #05241C
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          // 1. Subtle Damask Wallpaper Pattern
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

          // 2. Ambient Emerald & Gold Radial Glow Orb
          Center(
            child: Container(
              width: 380,
              height: 380,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: <Color>[
                    AppColors.goldPrimary.withValues(alpha: 0.12),
                    const Color(0xFF0D4A3A).withValues(alpha: 0.18),
                    Colors.transparent,
                  ],
                  stops: const <double>[0.0, 0.45, 0.70],
                ),
              ),
            ),
          ),

          // 3. Main Glassmorphic Login Card
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.space20,
                  vertical: AppSpacing.space24,
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
                        BoxShadow(
                          color: Color(0x1A05241C),
                          blurRadius: 12,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.space24,
                      vertical: AppSpacing.space32,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        // Brand Logo Header
                        Center(
                          child: SvgPicture.asset(
                            'assets/icons/swastiklogo.svg',
                            width: 180,
                            height: 64,
                            fit: BoxFit.contain,
                            placeholderBuilder: (BuildContext context) {
                              return const Icon(
                                Icons.diamond_outlined,
                                size: 48,
                                color: AppColors.goldPrimary,
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: AppSpacing.space8),
                        Text(
                          'Sign in to continue',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.cormorantGaramond(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: AppColors.goldLight,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.space4),
                        Text(
                          'Access your certified bullion vault & schemes',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w400,
                            color: AppColors.emeraldTextSubtle,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.space32),

                        // Google SSO Button
                        _buildGoogleButton(
                          isLoading: authState.isSubmitting,
                          onPressed: () async {
                            final bool success = await controller.loginWithGoogle();
                            if (success && context.mounted) {
                              context.go(RoutePaths.authSuccess);
                            } else if (authState.phoneError != null && context.mounted) {
                              KittyToast.show(
                                context,
                                message: authState.phoneError!,
                                type: KittyToastType.error,
                              );
                            }
                          },
                        ),

                        const SizedBox(height: AppSpacing.space20),

                        // Luxury Gold Divider: "OR"
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                height: 1,
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: <Color>[
                                      Colors.transparent,
                                      AppColors.goldBorder,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.space16,
                              ),
                              child: Text(
                                'OR',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.5,
                                  color: AppColors.goldLight.withValues(alpha: 0.7),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: 1,
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: <Color>[
                                      AppColors.goldBorder,
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: AppSpacing.space20),

                        // Continue with Mobile Button
                        _buildMobileButton(
                          onPressed: authState.isSubmitting
                              ? null
                              : () {
                                  controller.clearErrors();
                                  context.push(RoutePaths.phone);
                                },
                        ),

                        const SizedBox(height: AppSpacing.space24),

                        // Security & Privacy Note
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Icon(
                              Icons.lock_outline_rounded,
                              size: 13,
                              color: AppColors.emeraldTextSubtle,
                            ),
                            const SizedBox(width: AppSpacing.space6),
                            Flexible(
                              child: Text(
                                '256-bit SSL Encrypted • RBI & PMLA Compliant',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.emeraldTextSubtle,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
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

  Widget _buildGoogleButton({
    required bool isLoading,
    required VoidCallback onPressed,
  }) {
    return Container(
      height: AppDimensions.primaryButtonHeight,
      decoration: const BoxDecoration(
        color: Color(0xFFFFFFFF),
        borderRadius: AppRadius.border12,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: AppRadius.border12,
          child: Center(
            child: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.2,
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4285F4)),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // Google Logo G
                      CustomPaint(
                        size: const Size(20, 20),
                        painter: _GoogleLogoPainter(),
                      ),
                      const SizedBox(width: AppSpacing.space12),
                      Text(
                        'Continue with Google',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1F2937),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileButton({required VoidCallback? onPressed}) {
    return Container(
      height: AppDimensions.primaryButtonHeight,
      decoration: const BoxDecoration(
        gradient: AppColors.goldPrimaryGradient,
        borderRadius: AppRadius.border12,
        boxShadow: AppShadows.ctaGold,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: AppRadius.border12,
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.space16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.phone_iphone_rounded,
                  size: 19,
                  color: AppColors.deepEmeraldBase,
                ),
                SizedBox(width: AppSpacing.space10),
                Text(
                  'Continue with Mobile',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.deepEmeraldBase,
                    letterSpacing: 0.3,
                  ),
                ),
                SizedBox(width: AppSpacing.space8),
                Icon(
                  Icons.arrow_forward_rounded,
                  size: 17,
                  color: AppColors.deepEmeraldBase,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    final Paint paint = Paint()..style = PaintingStyle.fill;

    // Blue
    paint.color = const Color(0xFF4285F4);
    final Path bluePath = Path()
      ..moveTo(w * 0.98, h * 0.51)
      ..lineTo(w * 0.5, h * 0.51)
      ..lineTo(w * 0.5, h * 0.70)
      ..lineTo(w * 0.78, h * 0.70)
      ..arcToPoint(Offset(w * 0.73, h * 0.85), radius: Radius.circular(w * 0.35))
      ..lineTo(w * 0.89, h * 0.98)
      ..arcToPoint(Offset(w * 0.98, h * 0.51), radius: Radius.circular(w * 0.5))
      ..close();
    canvas.drawPath(bluePath, paint);

    // Green
    paint.color = const Color(0xFF34A853);
    final Path greenPath = Path()
      ..moveTo(w * 0.5, h)
      ..arcToPoint(Offset(w * 0.89, h * 0.98), radius: Radius.circular(w * 0.5))
      ..lineTo(w * 0.73, h * 0.85)
      ..arcToPoint(Offset(w * 0.5, h * 0.82), radius: Radius.circular(w * 0.35))
      ..arcToPoint(Offset(w * 0.22, h * 0.70), radius: Radius.circular(w * 0.35))
      ..lineTo(w * 0.05, h * 0.83)
      ..arcToPoint(Offset(w * 0.5, h), radius: Radius.circular(w * 0.5))
      ..close();
    canvas.drawPath(greenPath, paint);

    // Yellow
    paint.color = const Color(0xFFFBBC05);
    final Path yellowPath = Path()
      ..moveTo(w * 0.05, h * 0.83)
      ..lineTo(w * 0.22, h * 0.70)
      ..arcToPoint(Offset(w * 0.22, h * 0.30), radius: Radius.circular(w * 0.35))
      ..lineTo(w * 0.05, h * 0.17)
      ..arcToPoint(Offset(w * 0.05, h * 0.83), radius: Radius.circular(w * 0.5))
      ..close();
    canvas.drawPath(yellowPath, paint);

    // Red
    paint.color = const Color(0xFFEA4335);
    final Path redPath = Path()
      ..moveTo(w * 0.5, 0)
      ..arcToPoint(Offset(w * 0.88, h * 0.15), radius: Radius.circular(w * 0.5))
      ..lineTo(w * 0.73, h * 0.28)
      ..arcToPoint(Offset(w * 0.5, h * 0.18), radius: Radius.circular(w * 0.35))
      ..arcToPoint(Offset(w * 0.22, h * 0.30), radius: Radius.circular(w * 0.35))
      ..lineTo(w * 0.05, h * 0.17)
      ..arcToPoint(Offset(w * 0.5, 0), radius: Radius.circular(w * 0.5))
      ..close();
    canvas.drawPath(redPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
