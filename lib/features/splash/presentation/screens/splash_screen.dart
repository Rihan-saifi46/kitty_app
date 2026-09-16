import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/providers/auth_state_provider.dart';
import '../../../../core/routing/route_paths.dart';
import '../widgets/diamond_3d_painter.dart';

/// Splash Screen reproducing the approved Swastik Jewel 3D Diamond luxury sequence.
///
/// Timeline:
/// - 0.0s – 0.1s: Clean Deep Emerald background (#05241C).
/// - 0.1s – 2.3s: 3D Faceted Brilliant-Cut Diamond rotates 360° and approaches camera.
/// - 2.3s: Diamond exits outside viewport.
/// - 2.32s – 3.3s: Royal Damask Pattern + Swastik Jewel Logo fade in.
/// - ~3.3s: Session check resolution -> `/home` (if authenticated) or `/auth/login`.
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
  bool _hasResolvedSession = false;

  static const double _diamondStartFraction = 100.0 / 3320.0;
  static const double _diamondEndFraction = 2300.0 / 3320.0;
  static const double _logoRevealFraction = 2320.0 / 3320.0;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: widget.totalDuration,
    );

    _animController.addListener(_onTick);
    _animController.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed && widget.autoNavigate) {
        _resolveSessionAndNavigate();
      }
    });

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.removeListener(_onTick);
    _animController.dispose();
    super.dispose();
  }

  void _onTick() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _resolveSessionAndNavigate() async {
    if (_hasResolvedSession || !mounted) return;
    _hasResolvedSession = true;

    // Verify authentication state
    final AppAuthNotifier notifier = ref.read(appAuthStateProvider.notifier);
    await notifier.checkAuthStatus();

    if (!mounted) return;
    final AppAuthState auth = ref.read(appAuthStateProvider);

    if (auth.isAuthenticated) {
      context.go(RoutePaths.home);
    } else {
      context.go(RoutePaths.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double animValue = _animController.value;

    // Phase 1: 3D Diamond properties
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

      // Exponential scale-up approaching screen
      final double approach = math.pow(p, 2.85).toDouble();
      diamondScale = 0.82 + approach * 38.0;

      // Opacity envelope
      if (p < 0.06) {
        diamondOpacity = p / 0.06;
      } else if (p > 0.94) {
        diamondOpacity = math.max(0.0, (1.0 - p) / 0.06);
      } else {
        diamondOpacity = 1.0;
      }
    }

    // Phase 2: Damask pattern and Logo fade-in
    double brandingOpacity = 0.0;
    if (animValue >= _logoRevealFraction) {
      final double bp = (animValue - _logoRevealFraction) /
          (1.0 - _logoRevealFraction);
      brandingOpacity = bp.clamp(0.0, 1.0);
    }

    return Scaffold(
      backgroundColor: AppColors.deepEmeraldBase, // Exact #05241C
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          // 1. Royal Damask Wallpaper Pattern (Background)
          if (brandingOpacity > 0.0)
            Opacity(
              opacity: (0.12 * brandingOpacity).clamp(0.0, 1.0),
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

          // 2. Ambient radial glow behind diamond & branding
          Center(
            child: Container(
              width: 320,
              height: 320,
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

          // 3. Phase 1: Full-Viewport 3D Faceted Crystal Diamond
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

          // 4. Phase 2: Swastik Jewel Brand Logo (Foreground)
          if (brandingOpacity > 0.0)
            Center(
              child: Opacity(
                opacity: brandingOpacity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SvgPicture.asset(
                      'assets/icons/swastiklogo.svg',
                      width: 190,
                      height: 70,
                      fit: BoxFit.contain,
                      placeholderBuilder: (BuildContext context) {
                        return const Icon(
                          Icons.diamond_outlined,
                          size: 56,
                          color: AppColors.goldPrimary,
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'KITTY VAULT',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 4.0,
                        color: AppColors.goldLight.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
