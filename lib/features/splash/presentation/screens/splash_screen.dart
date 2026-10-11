import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/providers/auth_state_provider.dart';
import '../../../../core/routing/route_paths.dart';
import '../widgets/diamond_3d_painter.dart';
import 'web_loader_stub.dart' if (dart.library.js_interop) 'web_loader_web.dart';

/// Luxury Splash & Launch Sequence Screen.
///
/// Implements the exact launch flow:
/// Stage 1: Clean Gold Plans background (#FAF7F2).
/// Stage 2: 3D Diamond appears from center.
/// Stage 3: Diamond rotates a full 360° (2π).
/// Stage 4: Diamond moves/flies smoothly outside the frame.
/// Stage 5: Minimal Brand Screen containing ONLY "Swastik Jewels" centered in Playfair Display.
/// Stage 6: Transitions to Destination Screen (for authenticated patrons) or Login (unauthenticated).
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({
    super.key,
    this.diamondDuration = const Duration(milliseconds: 2300),
    this.brandDuration = const Duration(milliseconds: 1100),
    Duration? totalDuration,
    this.autoNavigate = true,
  }) : totalDuration = totalDuration ?? const Duration(milliseconds: 3400);

  final Duration diamondDuration;
  final Duration brandDuration;
  final Duration totalDuration;
  final bool autoNavigate;

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _diamondController;
  late final AnimationController _brandController;

  // Diamond lifecycle animations
  late final Animation<double> _appearanceScale;
  late final Animation<double> _appearanceOpacity;
  late final Animation<double> _rotationY;
  late final Animation<double> _exitTranslate;

  // Brand screen animations
  late final Animation<double> _brandFade;
  late final Animation<double> _brandScale;

  bool _isDiamondFinished = false;
  bool _isNavigated = false;

  @override
  void initState() {
    super.initState();

    if (kIsWeb) {
      dismissWebLoader();
    }

    final Duration dDuration = widget.totalDuration != const Duration(milliseconds: 3400)
        ? Duration(milliseconds: (widget.totalDuration.inMilliseconds * 0.68).round())
        : widget.diamondDuration;
    final Duration bDuration = widget.totalDuration != const Duration(milliseconds: 3400)
        ? Duration(milliseconds: (widget.totalDuration.inMilliseconds * 0.32).round())
        : widget.brandDuration;

    // 1. Diamond Animation Controller
    _diamondController = AnimationController(
      vsync: this,
      duration: dDuration,
    );

    // Stage 1 (0.00 to 0.08): Blank gold screen (scale = 0, opacity = 0)
    // Stage 2 (0.08 to 0.28): Diamond appears from center
    _appearanceScale = Tween<double>(begin: 0.0, end: 1.35).animate(
      CurvedAnimation(
        parent: _diamondController,
        curve: const Interval(0.08, 0.28, curve: Curves.easeOutBack),
      ),
    );
    _appearanceOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _diamondController,
        curve: const Interval(0.08, 0.24, curve: Curves.easeIn),
      ),
    );

    // Stage 3 (0.24 to 0.72): Diamond rotates full 360° (2π)
    _rotationY = Tween<double>(begin: 0.0, end: 2.0 * math.pi).animate(
      CurvedAnimation(
        parent: _diamondController,
        curve: const Interval(0.24, 0.72, curve: Curves.easeInOutCubic),
      ),
    );

    // Stage 4 (0.72 to 1.00): Diamond moves/flies smoothly outside the top of the frame
    _exitTranslate = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _diamondController,
        curve: const Interval(0.72, 1.00, curve: Curves.easeInOutCubic),
      ),
    );

    // 2. Minimal Brand Screen Controller ("Swastik Jewels" ONLY)
    _brandController = AnimationController(
      vsync: this,
      duration: bDuration,
    );
    _brandFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _brandController,
        curve: const Interval(0.0, 0.50, curve: Curves.easeOut),
      ),
    );
    _brandScale = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(
        parent: _brandController,
        curve: const Interval(0.0, 0.60, curve: Curves.easeOut),
      ),
    );

    _diamondController.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        if (!mounted) return;
        setState(() {
          _isDiamondFinished = true;
        });
        _brandController.forward();
      }
    });

    _brandController.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        if (widget.autoNavigate) {
          _resolveAuthAndNavigate();
        }
      }
    });

    _diamondController.forward();
  }

  @override
  void dispose() {
    _diamondController.dispose();
    _brandController.dispose();
    super.dispose();
  }

  /// Evaluates authentication state with guaranteed safety timeout:
  /// - Authenticated + KYC Verified -> Destination Screen (/onboarding/choice)
  /// - Authenticated + KYC Pending -> /kyc
  /// - Unauthenticated -> /auth/login
  Future<void> _resolveAuthAndNavigate() async {
    if (_isNavigated || !mounted) return;

    AppAuthState auth = ref.read(appAuthStateProvider);

    // If still in booting/initial state, give checkAuthStatus a quick moment to resolve
    if (auth.isInitial) {
      try {
        await ref
            .read(appAuthStateProvider.notifier)
            .checkAuthStatus()
            .timeout(const Duration(milliseconds: 1000), onTimeout: () {});
      } catch (_) {}
      auth = ref.read(appAuthStateProvider);
    }

    if (_isNavigated || !mounted) return;
    _isNavigated = true;

    if (auth.isAuthenticated) {
      if (!auth.isKycVerified) {
        context.go(RoutePaths.kyc);
      } else {
        context.go(RoutePaths.postKycChoice);
      }
    } else {
      context.go(RoutePaths.login);
    }
  }

  /// Instant user skip handler on tap.
  void _skipOrComplete() {
    if (_isNavigated || !mounted) return;

    if (!_isDiamondFinished) {
      _diamondController.stop();
      _diamondController.value = 1.0;
      setState(() {
        _isDiamondFinished = true;
      });
      _brandController.forward();
    } else {
      _brandController.stop();
      _brandController.value = 1.0;
      _resolveAuthAndNavigate();
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AppAuthState>(appAuthStateProvider, (previous, next) {
      if (!next.isInitial && _brandController.isCompleted && mounted) {
        _resolveAuthAndNavigate();
      }
    });

    final Size screenSize = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F2), // Exact Gold Plans Background
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _skipOrComplete,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            // 1. Subtle warm ambient radial illumination
            Center(
              child: Container(
                width: 380,
                height: 380,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: <Color>[
                      Color(0x1FC88A35),
                      Color(0x08F3EDE4),
                      Colors.transparent,
                    ],
                    stops: <double>[0.0, 0.50, 1.0],
                  ),
                ),
              ),
            ),

            // 2. Stage A: 3D Diamond Animation Layer
            if (!_isDiamondFinished)
              AnimatedBuilder(
                animation: _diamondController,
                builder: (BuildContext context, Widget? child) {
                  final double scale = _appearanceScale.value;
                  final double opacity = _appearanceOpacity.value;
                  final double rotY = _rotationY.value;
                  final double exitProgress = _exitTranslate.value;

                  // Moves upward completely outside the viewport
                  final double translateY =
                      -exitProgress * (screenSize.height * 0.70 + 200.0);

                  return Positioned.fill(
                    child: Center(
                      child: Transform.translate(
                        offset: Offset(0, translateY),
                        child: RepaintBoundary(
                          child: CustomPaint(
                            size: Size(screenSize.width, screenSize.height),
                            painter: Diamond3DPainter(
                              rotationY: rotY,
                              scaleFactor: scale,
                              opacity: opacity,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

            // 3. Stage B: Minimal Brand Screen (Swastik Jewels ONLY)
            if (_isDiamondFinished)
              AnimatedBuilder(
                animation: _brandController,
                builder: (BuildContext context, Widget? child) {
                  return Center(
                    child: Opacity(
                      opacity: _brandFade.value,
                      child: Transform.scale(
                        scale: _brandScale.value,
                        child: Text(
                          'Swastik Jewels',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 34,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0A221C),
                            letterSpacing: 0.6,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
