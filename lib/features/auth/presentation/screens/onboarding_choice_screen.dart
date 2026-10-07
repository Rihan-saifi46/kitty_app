import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/config/app_constants.dart';
import '../../../../core/routing/route_paths.dart';

/// Post-KYC Choice Screen.
///
/// Displayed immediately after statutory KYC completion.
/// Offers three distinct, clean journeys:
/// 1. "View on Instagram": Opens official Swastik Jewellers Instagram profile externally.
/// 2. "Shop Gold": Navigates directly to the internal Kitty App Gold Plans page.
/// 3. "Shop Jewellery": Opens the official Swastik Jewellers website catalog externally.
class OnboardingChoiceScreen extends ConsumerWidget {
  const OnboardingChoiceScreen({super.key});

  static const String _officialInstagramUrl =
      'https://www.instagram.com/swastikjewellers_official/';
  static const String _fallbackInstagramUrl = 'https://instagram.com/swastikjewel';

  static const String _instagramSvg = '''<svg viewBox="0 0 24 24" fill="none">
    <path d="M12 2.163c3.204 0 3.584.012 4.85.07 3.252.148 4.771 1.691 4.919 4.919.058 1.265.069 1.645.069 4.849 0 3.205-.012 3.584-.069 4.849-.149 3.225-1.664 4.771-4.919 4.919-1.266.058-1.644.07-4.85.07-3.204 0-3.584-.012-4.849-.07-3.26-.149-4.771-1.699-4.919-4.92-.058-1.265-.07-1.644-.07-4.849 0-3.204.013-3.583.07-4.849.149-3.227 1.664-4.771 4.919-4.919 1.266-.057 1.645-.069 4.849-.069zM12 0C8.741 0 8.333.014 7.053.072 2.695.272.273 2.69.073 7.052.014 8.333 0 8.741 0 12c0 3.259.014 3.668.072 4.948.2 4.358 2.618 6.78 6.98 6.98 1.281.058 1.689.072 4.948.072 3.259 0 3.668-.014 4.948-.072 4.354-.2 6.782-2.618 6.979-6.98.059-1.28.073-1.689.073-4.948 0-3.259-.014-3.667-.072-4.947-.196-4.354-2.617-6.78-6.979-6.98C15.668.014 15.259 0 12 0zm0 5.838a6.162 6.162 0 100 12.324 6.162 6.162 0 000-12.324zM12 16a4 4 0 110-8 4 4 0 010 8zm6.406-11.845a1.44 1.44 0 100 2.881 1.44 1.44 0 000-2.881z" fill="url(#ig-grad)"/>
    <defs>
      <linearGradient id="ig-grad" x1="2" y1="22" x2="22" y2="2" gradientUnits="userSpaceOnUse">
        <stop stop-color="#FFD600"/>
        <stop offset="0.25" stop-color="#FF7A00"/>
        <stop offset="0.5" stop-color="#FF0069"/>
        <stop offset="0.75" stop-color="#D300C5"/>
        <stop offset="1" stop-color="#7638FA"/>
      </linearGradient>
    </defs>
  </svg>''';

  Future<void> _launchInstagram(BuildContext context) async {
    await HapticFeedback.lightImpact();
    final Uri primaryUri = Uri.parse(_officialInstagramUrl);
    final Uri fallbackUri = Uri.parse(_fallbackInstagramUrl);

    try {
      final bool launched = await launchUrl(
        primaryUri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        await launchUrl(fallbackUri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {
      try {
        await launchUrl(fallbackUri, mode: LaunchMode.externalApplication);
      } catch (_) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not open Instagram profile.')),
          );
        }
      }
    }
  }

  void _navigateToShopGold(BuildContext context) {
    HapticFeedback.lightImpact();
    context.go(RoutePaths.offers);
  }

  Future<void> _launchShopJewellery(BuildContext context) async {
    await HapticFeedback.lightImpact();
    final Uri websiteUri = Uri.parse(AppConstants.jewelleryCatalogUrl);
    try {
      final bool launched = await launchUrl(
        websiteUri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open Swastik Jewellers website.')),
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open Swastik Jewellers website.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFF05241C),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          // Damask Wallpaper Pattern Overlay
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

          // Foreground Content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      // Swastik Logo
                      Center(
                        child: SvgPicture.asset(
                          'assets/icons/swastiklogo.svg',
                          width: 140,
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

                      const SizedBox(height: 20),

                      // Success Badge
                      Center(
                        child: Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const RadialGradient(
                              colors: <Color>[
                                Color(0x40CCA243),
                                Color(0x660D4A3A),
                              ],
                            ),
                            border: Border.all(
                              color: const Color(0xFFCCA243),
                              width: 1.5,
                            ),
                            boxShadow: const <BoxShadow>[
                              BoxShadow(
                                color: Color(0x4DCCA243),
                                blurRadius: 24,
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.check_rounded,
                              size: 32,
                              color: Color(0xFFFFE899),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      // Heading
                      Text(
                        'Welcome to Swastik Jewellers',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFFF4E2AA),
                          letterSpacing: 0.3,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Subtitle
                      Text(
                        'Your profile and statutory KYC have been verified successfully. Choose how you would like to proceed.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF8FA499),
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Choice 1: View on Instagram
                      _buildChoiceCard(
                        context: context,
                        title: 'View on Instagram',
                        subtitle: 'Follow our daily jewellery showcases & live updates',
                        leadingWidget: SizedBox(
                          width: 28,
                          height: 28,
                          child: SvgPicture.string(_instagramSvg),
                        ),
                        badgeText: 'Social',
                        onTap: () => _launchInstagram(context),
                      ),

                      const SizedBox(height: 16),

                      // Choice 2: Shop Gold (Inside Kitty App)
                      _buildChoiceCard(
                        context: context,
                        title: 'Shop Gold',
                        subtitle: 'Explore 24K digital gold schemes & savings plans',
                        leadingWidget: Container(
                          width: 38,
                          height: 38,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: <Color>[
                                Color(0xFFCCA243),
                                Color(0xFFF4E2AA),
                              ],
                            ),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.monetization_on_rounded,
                              color: Color(0xFF101915),
                              size: 22,
                            ),
                          ),
                        ),
                        badgeText: 'In-App',
                        isHighlighted: true,
                        onTap: () => _navigateToShopGold(context),
                      ),

                      const SizedBox(height: 16),

                      // Choice 3: Shop Jewellery (Official Website)
                      _buildChoiceCard(
                        context: context,
                        title: 'Shop Jewellery',
                        subtitle: 'Browse handcrafted wedding & luxury collections',
                        leadingWidget: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0x33CCA243),
                            border: Border.all(
                              color: const Color(0x66CCA243),
                              width: 1,
                            ),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.diamond_outlined,
                              color: Color(0xFFF4E2AA),
                              size: 20,
                            ),
                          ),
                        ),
                        badgeText: 'Website',
                        onTap: () => _launchShopJewellery(context),
                      ),

                      const SizedBox(height: 28),

                      // Secondary "Continue to Dashboard" button
                      Center(
                        child: TextButton.icon(
                          onPressed: () => _navigateToShopGold(context),
                          icon: const Icon(
                            Icons.arrow_forward_rounded,
                            size: 16,
                            color: Color(0xFFCCA243),
                          ),
                          label: Text(
                            'Enter App Directly',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFFCCA243),
                              letterSpacing: 0.3,
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
        ],
      ),
    );
  }

  Widget _buildChoiceCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required Widget leadingWidget,
    required String badgeText,
    required VoidCallback onTap,
    bool isHighlighted = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isHighlighted
            ? const Color(0xE6083025)
            : const Color(0xCC062018),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isHighlighted
              ? const Color(0xFFCCA243)
              : const Color(0x47CCA243),
          width: isHighlighted ? 1.5 : 1.0,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: isHighlighted
                ? const Color(0x2ECCA243)
                : const Color(0x40000000),
            blurRadius: isHighlighted ? 18 : 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Row(
              children: <Widget>[
                // Leading Icon / Mark
                leadingWidget,

                const SizedBox(width: 14),

                // Text Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Flexible(
                            child: Text(
                              title,
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0x26CCA243),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: const Color(0x4DCCA243),
                                width: 0.8,
                              ),
                            ),
                            child: Text(
                              badgeText,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFFFFE899),
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        subtitle,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF8FA499),
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // Trailing Arrow
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: Color(0xFFCCA243),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
