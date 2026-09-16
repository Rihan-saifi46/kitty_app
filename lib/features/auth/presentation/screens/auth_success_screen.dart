import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/providers/auth_state_provider.dart';
import '../../../../core/routing/route_paths.dart';
import '../providers/auth_controller.dart';

/// Post-Authentication Success Screen (View 3 of Auth Flow).
///
/// Displays user status tier, welcome greeting, and primary action to enter
/// the main Kitty App shell (/home).
class AuthSuccessScreen extends ConsumerWidget {
  const AuthSuccessScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppAuthState auth = ref.watch(appAuthStateProvider);
    final AuthFlowState authFlow = ref.watch(authControllerProvider);

    final String displayName = auth.userName.isNotEmpty
        ? auth.userName
        : (authFlow.authSession?.user.name.isNotEmpty == true
            ? authFlow.authSession!.user.name
            : 'Patron');

    final String tierText = auth.tier.isNotEmpty
        ? auth.tier
        : (authFlow.authSession?.user.tier.isNotEmpty == true
            ? authFlow.authSession!.user.tier
            : 'Tier 1 Verified Member');

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
              width: 380,
              height: 380,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: <Color>[
                    AppColors.goldPrimary.withValues(alpha: 0.15),
                    const Color(0xFF0D4A3A).withValues(alpha: 0.20),
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
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.space24,
                      vertical: AppSpacing.space32,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        // Success Checkmark Badge
                        Container(
                          width: 68,
                          height: 68,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: <Color>[
                                Color(0xFF10B981),
                                Color(0xFF059669),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            border: Border.all(
                              color: AppColors.goldLight.withValues(alpha: 0.8),
                              width: 2.0,
                            ),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: const Color(0xFF10B981).withValues(alpha: 0.35),
                                blurRadius: 20,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.check_rounded,
                              size: 38,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.space24),

                        // Title
                        Text(
                          'Welcome Back, $displayName',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.cormorantGaramond(
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimaryLight,
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.space10),

                        // Tier Badge Chip
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.space12,
                            vertical: AppSpacing.space6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.goldPrimary.withValues(alpha: 0.15),
                            borderRadius: AppRadius.border20,
                            border: Border.all(
                              color: AppColors.goldPrimary.withValues(alpha: 0.4),
                              width: 1.0,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              const Icon(
                                Icons.workspace_premium_rounded,
                                size: 14,
                                color: AppColors.goldPrimary,
                              ),
                              const SizedBox(width: AppSpacing.space6),
                              Text(
                                tierText,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.goldLight,
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.space14),

                        // Subtitle
                        Text(
                          'Accessing your Kitty schemes and bullion vault...',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: AppColors.emeraldTextSubtle,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.space32),

                        // Enter Kitty Vault Button
                        Container(
                          width: double.infinity,
                          height: AppDimensions.primaryButtonHeight,
                          decoration: const BoxDecoration(
                            gradient: AppColors.goldPrimaryGradient,
                            borderRadius: AppRadius.border12,
                            boxShadow: AppShadows.ctaGold,
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                context.go(RoutePaths.home);
                              },
                              borderRadius: AppRadius.border12,
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'Enter Kitty Vault',
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
