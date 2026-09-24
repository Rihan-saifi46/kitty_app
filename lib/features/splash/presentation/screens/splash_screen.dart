import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/providers/auth_state_provider.dart';
import '../../../../core/routing/route_paths.dart';
import '../widgets/diamond_3d_painter.dart';
import 'web_loader_stub.dart' if (dart.library.js_interop) 'web_loader_web.dart';

/// Luxury Splash & Loading Screen reproducing the Swastik Jewel 3D sequence
/// from `index.html` + `loader.js` + `styles.css`.
///
/// Exact Timeline:
/// - 0.0s – 2.3s: 3D Faceted Brilliant-Cut Diamond rotates 360° and zooms toward camera
///   (passing through and beyond viewport edges with smooth opacity envelope).
/// - 2.3s: Diamond exits outside viewport.
/// - 2.32s – 3.32s: Royal Damask Wallpaper Pattern (opacity 0 -> 0.16) + Swastik Jewel Logo
///   fade & scale in with luxury cubic-bezier easing (`Cubic(0.16, 1.0, 0.3, 1.0)`).
/// - ~3.32s: Sequence completes smoothly; resolves session check and navigates
///   to `/home` (if authenticated) or `/auth/login`.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({
    super.key,
    this.totalDuration = const Duration(milliseconds: 2800),
    this.autoNavigate = true,
  });

  final Duration totalDuration;
  final bool autoNavigate;

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  bool _isAnimationCompleted = false;
  bool _isNavigated = false;

  static const double _diamondStartFraction = 0.0;
  static const double _diamondEndFraction = 1750.0 / 2800.0;
  static const double _logoRevealStartFraction = 1350.0 / 2800.0;
  static const double _logoRevealEndFraction = 1950.0 / 2800.0;

  static const Curve _luxuryCurve = Cubic(0.16, 1.0, 0.3, 1.0);

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: widget.totalDuration,
    );

    int webElapsedOffsetMs = 0;
    if (kIsWeb) {
      final double? webElapsed = getWebLoaderElapsedSeconds();
      if (webElapsed != null && widget.totalDuration.inMilliseconds > 0) {
        webElapsedOffsetMs = (webElapsed * 1000).toInt();
        dismissWebLoader();
      }
    }

    final int totalMs = widget.totalDuration.inMilliseconds;
    final double initialProgress = totalMs > 0
        ? (webElapsedOffsetMs / totalMs).clamp(0.0, 1.0)
        : 0.0;

    _animController.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        _isAnimationCompleted = true;
        if (widget.autoNavigate) {
          _checkAndNavigate();
        }
      }
    });

    _animController.forward(from: initialProgress);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  /// Synchronized navigation handoff: Triggers immediately when the branded animation
  /// finishes AND auth status is determined. Navigation is executed strictly once.
  void _checkAndNavigate() {
    if (_isNavigated || !mounted) return;

    final AppAuthState auth = ref.read(appAuthStateProvider);

    // Only navigate once the branded animation has fully completed
    // and the auth state is resolved (not initial/pending)
    if (_isAnimationCompleted && !auth.isInitial) {
      _isNavigated = true;
      if (auth.isAuthenticated) {
        if (!auth.isKycVerified) {
          context.go(RoutePaths.kyc);
        } else {
          context.go(RoutePaths.home);
        }
      } else {
        context.go(RoutePaths.login);
      }
    }
  }

  /// Instant handoff: If a patron taps the splash screen, fast-forward to completion
  /// and perform the immediate authenticated navigation handoff.
  void _completeAndNavigateNow() {
    if (_isAnimationCompleted || _isNavigated || !mounted) return;
    _animController.stop();
    _animController.value = 1.0;
    _isAnimationCompleted = true;
    if (widget.autoNavigate) {
      _checkAndNavigate();
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AppAuthState>(appAuthStateProvider, (previous, next) {
      if (!next.isInitial && mounted) {
        _checkAndNavigate();
      }
    });

    return Scaffold(
      backgroundColor: AppColors.deepEmeraldBase, // Exact #05241C
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _completeAndNavigateNow,
        child: Stack(
          fit: StackFit.expand,
        children: <Widget>[
          // 1. Ambient radial lighting glow (static, zero-cost)
          Center(
            child: Container(
              width: 360,
              height: 360,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: <Color>[
                    AppColors.goldPrimary.withValues(alpha: 0.14),
                    AppColors.emeraldCard.withValues(alpha: 0.08),
                    Colors.transparent,
                  ],
                  stops: const <double>[0.0, 0.45, 1.0],
                ),
              ),
            ),
          ),

          // 2. Animated layers driven by AnimationController
          AnimatedBuilder(
            animation: _animController,
            builder: (BuildContext context, Widget? child) {
              final double animValue = _animController.value;

              // --- PHASE 1: 3D DIAMOND ---
              double diamondOpacity = 0.0;
              double diamondRotationY = 0.0;
              double diamondModelScale = 0.85;
              double diamondZoomScale = 1.0;
              bool showDiamond = false;

              if (animValue >= _diamondStartFraction && animValue <= _diamondEndFraction) {
                showDiamond = true;
                final double p = (animValue - _diamondStartFraction) /
                    (_diamondEndFraction - _diamondStartFraction);

                // Smooth ease-in-out 360-degree rotation (2 * PI)
                final double rotProgress = p < 0.5
                    ? 4.0 * p * p * p
                    : 1.0 - math.pow(-2.0 * p + 2.0, 3) / 2.0;
                diamondRotationY = rotProgress * math.pi * 2.0;

                // Natural luxury scale progression without extreme viewport exit jumps
                diamondModelScale = 0.85 + (p * 0.20);
                diamondZoomScale = 0.95 + (p * 0.20);

                // Smooth progressive opacity envelope (fade in smoothly, hold gleaming, dissolve softly)
                if (p < 0.15) {
                  diamondOpacity = p / 0.15;
                } else if (p > 0.65) {
                  diamondOpacity = math.max(0.0, (1.0 - p) / 0.35);
                } else {
                  diamondOpacity = 1.0;
                }
              }

              // --- PHASE 2 & 3: LOGO BRANDING ---
              double rawBrandingProgress = 0.0;
              if (animValue >= _logoRevealStartFraction) {
                if (animValue >= _logoRevealEndFraction) {
                  // Phase 3: Fully revealed; static luxury pause in center until totalDuration completes
                  rawBrandingProgress = 1.0;
                } else {
                  // Phase 2: Smooth luxury reveal between 1.35s and 1.95s
                  rawBrandingProgress = ((animValue - _logoRevealStartFraction) /
                      (_logoRevealEndFraction - _logoRevealStartFraction)).clamp(0.0, 1.0);
                }
              }
              final double curvedBranding = _luxuryCurve.transform(rawBrandingProgress);

              final Size screenSize = MediaQuery.sizeOf(context);
              // Make logo significantly larger and more prominent
              final double logoWidth = (screenSize.width * 0.74).clamp(260.0, 360.0);
              final double logoHeight = logoWidth * (47.0 / 181.0);

              return Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  // A. Phase 1: Full-Viewport 3D Faceted Crystal Diamond
                  if (showDiamond && diamondOpacity > 0.001)
                    Positioned.fill(
                      child: Transform.scale(
                        scale: diamondZoomScale,
                        alignment: Alignment.center,
                        child: RepaintBoundary(
                          child: CustomPaint(
                            painter: Diamond3DPainter(
                              rotationY: diamondRotationY,
                              scaleFactor: diamondModelScale,
                              opacity: diamondOpacity,
                            ),
                          ),
                        ),
                      ),
                    ),

                  // B. Phase 2: Authentic Swastik Brand Logo (Prominent, No Kitty Vault text)
                  if (curvedBranding > 0.001)
                    Center(
                      child: Opacity(
                        opacity: curvedBranding,
                        child: Transform.translate(
                          offset: Offset(0, (1.0 - curvedBranding) * 12.0),
                          child: Transform.scale(
                            scale: 0.94 + (0.06 * curvedBranding),
                            child: Container(
                              decoration: const BoxDecoration(
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                    color: Color(0x66000000),
                                    blurRadius: 32,
                                    offset: Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: SvgPicture.asset(
                                'assets/icons/swastiklogo.svg',
                                width: logoWidth,
                                height: logoHeight,
                                fit: BoxFit.contain,
                                placeholderBuilder: (BuildContext context) {
                                  return SizedBox(
                                    width: logoWidth,
                                    height: logoHeight,
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      ),
    );
  }
}
