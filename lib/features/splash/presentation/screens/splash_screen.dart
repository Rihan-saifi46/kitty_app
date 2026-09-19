import 'dart:math' as math;
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
    this.totalDuration = const Duration(milliseconds: 3320),
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
  static const double _diamondEndFraction = 2300.0 / 3320.0;
  static const double _logoRevealFraction = 2320.0 / 3320.0;

  static const Curve _luxuryCurve = Cubic(0.16, 1.0, 0.3, 1.0);

  @override
  void initState() {
    super.initState();

    // 1. Parallel Auth Check: Start token validation immediately in parallel
    // so it resolves during the 3D diamond animation without blocking navigation.
    final AppAuthState initialAuth = ref.read(appAuthStateProvider);
    if (initialAuth.isInitial) {
      ref.read(appAuthStateProvider.notifier).checkAuthStatus().then((_) {
        if (mounted) {
          _checkAndNavigate();
        }
      });
    }

    _animController = AnimationController(
      vsync: this,
      duration: widget.totalDuration,
    );

    _animController.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        _isAnimationCompleted = true;
        if (widget.autoNavigate) {
          _checkAndNavigate();
        }
      }
    });

    final double? webElapsed = getWebLoaderElapsedSeconds();
    if (webElapsed != null && widget.totalDuration.inMilliseconds > 0) {
      final double totalSec = widget.totalDuration.inMilliseconds / 1000.0;
      final double progress = (webElapsed / totalSec).clamp(0.0, 1.0);
      _animController.value = progress;
      dismissWebLoader();
    }

    _animController.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(const AssetImage('assets/patterns/damask-pattern.jpg'), context);
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
        context.go(RoutePaths.home);
      } else {
        context.go(RoutePaths.login);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.deepEmeraldBase, // Exact #05241C
      body: Stack(
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
              double diamondScale = 0.82;
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

                // Exponential scale-up approaching and passing camera
                final double approach = math.pow(p, 2.85).toDouble();
                diamondScale = 0.82 + approach * 38.0;

                // Opacity envelope (fade-in over first 6%, fade-out over last 6%)
                if (p < 0.06) {
                  diamondOpacity = p / 0.06;
                } else if (p > 0.94) {
                  diamondOpacity = math.max(0.0, (1.0 - p) / 0.06);
                } else {
                  diamondOpacity = 1.0;
                }
              }

              // --- PHASE 2: DAMASK WALLPAPER & LOGO BRANDING ---
              double rawBrandingProgress = 0.0;
              if (animValue >= _logoRevealFraction) {
                rawBrandingProgress = ((animValue - _logoRevealFraction) /
                    (1.0 - _logoRevealFraction)).clamp(0.0, 1.0);
              }
              final double curvedBranding = _luxuryCurve.transform(rawBrandingProgress);

              final Size screenSize = MediaQuery.sizeOf(context);
              final double logoWidth = (screenSize.width * 0.58).clamp(210.0, 300.0);
              final double logoHeight = logoWidth * (47.0 / 181.0);

              return Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  // A. Royal Damask Wallpaper Pattern (Background)
                  if (curvedBranding > 0.001)
                    Opacity(
                      opacity: (0.16 * curvedBranding).clamp(0.0, 1.0),
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: const AssetImage('assets/patterns/damask-pattern.jpg'),
                            repeat: ImageRepeat.repeat,
                            alignment: Alignment.topCenter,
                            colorFilter: ColorFilter.mode(
                              AppColors.goldPrimary.withValues(alpha: 0.85),
                              BlendMode.screen,
                            ),
                          ),
                        ),
                      ),
                    ),

                  // B. Phase 1: Full-Viewport 3D Faceted Crystal Diamond
                  if (showDiamond && diamondOpacity > 0.001)
                    Positioned.fill(
                      child: RepaintBoundary(
                        child: CustomPaint(
                          painter: Diamond3DPainter(
                            rotationY: diamondRotationY,
                            scaleFactor: diamondScale,
                            opacity: diamondOpacity,
                          ),
                        ),
                      ),
                    ),

                  // C. Phase 2: Swastik Jewel Brand Logo & Vault Title (Foreground)
                  if (curvedBranding > 0.001)
                    Center(
                      child: Opacity(
                        opacity: curvedBranding,
                        child: Transform.translate(
                          offset: Offset(0, (1.0 - curvedBranding) * 14.0),
                          child: Transform.scale(
                            scale: 0.96 + (0.04 * curvedBranding),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Container(
                                  decoration: const BoxDecoration(
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                        color: Color(0x66000000),
                                        blurRadius: 28,
                                        offset: Offset(0, 4),
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
                                const SizedBox(height: 10),
                                Text(
                                  'KITTY VAULT',
                                  style: TextStyle(
                                    fontFamily: 'Plus Jakarta Sans',
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 4.0,
                                    color: AppColors.goldLight.withValues(alpha: 0.90),
                                  ),
                                ),
                              ],
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
    );
  }
}
